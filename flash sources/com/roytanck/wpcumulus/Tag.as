/*
		com.roytanck.wpcumulus.Tag
		Copyright 2009: Roy Tanck 
		
		This file is part of WP-Cumulus.

    WP-Cumulus is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    WP-Cumulus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with WP-Cumulus.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.roytanck.wpcumulus
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.system.System;
	import flash.utils.escapeMultiByte;
	import flash.external.ExternalInterface;
	
	public class Tag extends Sprite {
		
		private var _back:Sprite;
		private var _node:XML;
		private var _cx:Number;
		private var _cy:Number;
		private var _cz:Number;
		private var _color:Number;
		private var _hicolor:Number;
		private var _active:Boolean;
		private var _tf:TextField;
		
		public function Tag( node:XML, color:Number, hicolor:Number ){
			System.useCodePage = false;
			
			_node = node;
			_color = color;
			_hicolor = hicolor;
			_active = false;
			// create the text field
			_tf = new TextField();
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.selectable = false;
			// set styles
			var format:TextFormat = new TextFormat();
			format.font = "微软雅黑, 宋体, Arial, 黑体";
			format.bold = true;
			format.color = color;
			format.size = 5 * getNumberFromString( node["@style"] );
			_tf.defaultTextFormat = format;
			//_tf.embedFonts = true;
			// set text
			_tf.text = node;
			_tf.filters = [new BlurFilter(5, 5, 1)];
			
			var bitmap:Bitmap = new Bitmap(null, "auto", true);
			var bitmapData:BitmapData = new BitmapData(_tf.width, _tf.height, true, color);
			bitmapData.draw(_tf);
			bitmap.bitmapData = bitmapData;
			bitmap.scaleX = 0.3;
			bitmap.scaleY = 0.3;

			addChild(bitmap);
			// scale and add
			bitmap.x = -this.width / 2;
			bitmap.y = -this.height / 2;
			// create the back
			_back = new Sprite();
			_back.graphics.beginFill( _hicolor, 0 );
			_back.graphics.lineStyle( 0, _hicolor );
			_back.graphics.drawRect( 0, 0, bitmap.width, bitmap.height );
			_back.graphics.endFill();
			addChildAt( _back, 0 );
			_back.x = -( bitmap.width/2 );
			_back.y = -( bitmap.height/2 );
			_back.visible = false;

			// force mouse cursor on rollover
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			// events
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

		}
		
		private function mouseOverHandler( e:MouseEvent ):void {
			_back.visible = true;
			_tf.textColor = _hicolor;
			_active = true;
		}
		
		private function mouseOutHandler( e:MouseEvent ):void {
			_back.visible = false;
			_tf.textColor = _color;
			_active = false;
		}
		
		private function mouseUpHandler( e:MouseEvent ):void {
			var action = _node["@action"];
			if( action != null ) {
				ExternalInterface.call(action); 
			}
		}

		private function getNumberFromString( s:String ):Number {
			return( Number( s.match( /(\d|\.|\,)/g ).join("").split(",").join(".") ) );
		}
		
		// setters and getters
		public function set cx( n:Number ){ _cx = n }
		public function get cx():Number { return _cx; }
		public function set cy( n:Number ){ _cy = n }
		public function get cy():Number { return _cy; }
		public function set cz( n:Number ){ _cz = n }
		public function get cz():Number { return _cz; }
		public function get active():Boolean { return _active; }

	}

}
