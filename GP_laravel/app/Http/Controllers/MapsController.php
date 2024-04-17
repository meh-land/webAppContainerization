<?php

namespace App\Http\Controllers;

use App\Models\Maps;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;


class MapsController extends Controller
{
    public function getMaps(){
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Not authenticated'], 401); 
        }

        $maps = $user->maps;
        return response()->json($maps);
    }

    public function createMap(Request $request){
        // Ensure there's an authenticated user
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Not authenticated'], 401); 
        }

        // Assume $mapContent contains the JSON content of your map
        // This might be generated based on some logic or data in your application
        $mapContent = json_encode([
            // Example map data
            'name' => $request->name,
            'nodes' => $request->nodes,
            'edges' => $request->edges,
        ]);

        // Sanitize the map name to create a safe filename
        $safeName = preg_replace('/[^A-Za-z0-9\-_]/', '', $request->name);
        $filename = $safeName . '.json';

        // Define the path to save the file (within the storage/app directory)
        $path = 'maps/' . $filename;

        // Use Laravel's Storage to save the content to a .json file
        Storage::disk('local')->put($path, $mapContent);

        // If you want to save the file outside of the storage/app directory, use absolute path
        // and PHP's file_put_contents (ensure proper permissions for the web server to write to the target directory)
        // $absolutePath = '/home/maps/' . $filename;
        // file_put_contents($absolutePath, $mapContent);

        // Create a new map record
        $map = new Maps();
        $map->name = $request->name;
        $map->user_id = $user->id;
        $map->file = $filename; // Save the filename or path in the database
        $map->save();

        // Get updated maps
        $maps = $user->maps;

        return response()->json($maps, 201);
    }

    public function getMap($mapId)
    {
        // Find the map by id or return a 404 error if not found
        $map = Maps::where('id', $mapId)->firstOrFail();

        // Define the path to the file
        $path = 'maps/' . $map->file;

        // Check if the file exists
        if (!Storage::disk('local')->exists($path)) {
            return response()->json(['message' => 'File not found'], 404);
        }

        // Read the content of the file
        $content = Storage::disk('local')->get($path);

        // Return the content of the map file as JSON
        return response()->json(json_decode($content, true));
    }

    public function deleteMap(Request $request)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Not authenticated'], 401);
        }

        $mapId = $request->id;
        // Find the map owned by the user with the given name or return a 404 error if not found
        $map = Maps::where('id', $mapId)->where('user_id', $user->id)->first();

        // Define the path to the file
        $path = 'maps/' . $map->file;

        // Check if the file exists and delete it
        if (Storage::disk('local')->exists($path)) {
            Storage::disk('local')->delete($path);
        }

        // Delete the map record from the database
        $map->delete();

        $maps = $user->maps;
        // Return a success response
        return response()->json([
            'message' => 'Map deleted successfully',
            'remainingMaps' => $maps
        ], 200);
    }

    public function editMap(Request $request, $mapId)
    {
        $user = Auth::user();
        if (!$user) {
            return response()->json(['message' => 'Not authenticated'], 401);
        }

        // Find the map owned by the user with the given ID or return a 404 error if not found
        $map = Maps::where('id', $mapId)->where('user_id', $user->id)->firstOrFail();

        $oldPath = 'maps/' . $map->file;

        // Check if name is provided and different from the current name
        if ($request->has('name') && $map->name !== $request->name) {
            $map->name = $request->name;
            
            // Generate a new filename based on the updated name
            $safeName = preg_replace('/[^A-Za-z0-9\-_]/', '', $request->name);
            $newFilename = $safeName . '.json';
            $newPath = 'maps/' . $newFilename;

            // Rename the file in storage if it exists
            if (Storage::disk('local')->exists($oldPath)) {
                Storage::disk('local')->move($oldPath, $newPath);
            }

            // Update the filename in the database
            $map->file = $newFilename;
        }

        // Update the map file with new nodes and edges if provided
        if ($request->has('nodes') && $request->has('edges')) {
            $mapContent = json_encode([
                'name' => $request->name,
                'nodes' => $request->nodes,
                'edges' => $request->edges,
            ]);

            // Use the current or new path depending on if the name (and thus filename) was changed
            $pathToUpdate = isset($newPath) ? $newPath : $oldPath;

            // Overwrite the existing or new .json file with updated content
            Storage::disk('local')->put($pathToUpdate, $mapContent);
        }

        $map->save(); // Save the updated map record

        return response()->json($map, 200);
    }

}
