package flixel.graphics.tile;

import flixel.FlxCamera;
import flixel.graphics.tile.FlxDrawBaseItem;
import flixel.math.FlxMatrix;
import openfl.Vector;
import openfl.display.TriangleCulling;

class FlxDrawMeshItem extends FlxDrawBaseItem<FlxDrawMeshItem>
{
  public var verts:Vector<Float> = new Vector<Float>();
  public var indices:Vector<Int> = new Vector<Int>();
  public var uvtData:Vector<Float> = new Vector<Float>();
  public var color:Int;
  public var alpha:Float;

  public function new()
  {
    super();
    type = FlxDrawItemType.MESH;
    reset();
  }

  override function reset():Void
  {
    super.reset();

    verts.length = 0;
    indices.length = 0;
    uvtData.length = 0;
    blend = null;
    color = 0xFFFFFF;
    alpha = 1;
  }

  public function addMesh(vertices:Vector<Float>, meshIndices:Vector<Int>, meshUvt:Vector<Float>, matrix:FlxMatrix):Void
  {
    var vertOffset:Int = verts.length;
    var indexOffset:Int = Std.int(vertOffset / 2);

    verts.length = vertOffset + vertices.length;

    if (matrix != null)
    {
      var i:Int = 0;
      while (i < vertices.length)
      {
        var x:Float = vertices[i];
        var y:Float = vertices[i + 1];
        verts[vertOffset + i] = matrix.a * x + matrix.c * y + matrix.tx;
        verts[vertOffset + i + 1] = matrix.b * x + matrix.d * y + matrix.ty;
        i += 2;
      }
    }

    if (meshUvt != null)
    {
      var uvOffset:Int = uvtData.length;
      uvtData.length = uvOffset + meshUvt.length;
      for (j in 0...meshUvt.length)
        uvtData[uvOffset + j] = meshUvt[j];
    }

    if (meshIndices != null)
    {
      var idxOffset:Int = indices.length;
      indices.length = idxOffset + meshIndices.length;
      for (j in 0...meshIndices.length)
        indices[idxOffset + j] = meshIndices[j] + indexOffset;
    }
  }

  override function render(camera:FlxCamera):Void
  {
    super.render(camera);

    camera.canvas.graphics.overrideBlendMode(blend);
    camera.canvas.graphics.beginFill(color, alpha);
    camera.canvas.graphics.drawTriangles(verts, indices, uvtData.length > 0 ? uvtData : null, TriangleCulling.NONE);
    camera.canvas.graphics.endFill();
  }
}
