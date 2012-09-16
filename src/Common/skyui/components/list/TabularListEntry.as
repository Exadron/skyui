﻿import skyui.components.list.TabularList;
import skyui.components.list.ListLayout;
import skyui.components.list.ListState;
import skyui.components.list.ColumnLayoutData;
import skyui.components.list.IEntryFormatter;
import skyui.components.list.BasicListEntry;


// @abstract
class skyui.components.list.TabularListEntry extends BasicListEntry
{
  /* PRIVATE VARIABLES */
  
	private var _layoutUpdateCount: Number = -1;
	
	
  /* STAGE ELEMENTS */

	public var selectIndicator: MovieClip;
	
	
  /* PUBLIC FUNCTIONS */
	
	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		var layout: ListLayout = TabularList(a_state.list).layout;
			
		// Show select area if this is the current entry
		selectIndicator._visible = (a_entryObject == a_state.list.selectedEntry);
		
		var curLayoutUpdateCount = layout.layoutUpdateCount;
		
		// Has the view update sequence number changed? Then Update the columns positions etc.
		if (_layoutUpdateCount != curLayoutUpdateCount) {
			_layoutUpdateCount = curLayoutUpdateCount;
			
			setEntryLayout(a_entryObject, a_state);
			setSpecificEntryLayout(a_entryObject, a_state);
		}
		
		// Format the actual entry contents. Do this with every upate.
		for (var i = 0; i < layout.columnCount; i++) {
			var columnLayoutData: ColumnLayoutData = layout.columnLayoutData[i];
			var e = this[columnLayoutData.stageName];

			// Substitute @variables by entryObject properties
			if (columnLayoutData.entryValue != undefined)
				if (columnLayoutData.entryValue.charAt(0) == "@")
					e.SetText(a_entryObject[columnLayoutData.entryValue.slice(1)]);
			
			// Process based on column type 
			switch (columnLayoutData.type) {
				case ListLayout.COL_TYPE_EQUIP_ICON :
					formatEquipIcon(e, a_entryObject, a_state);
					break;

				case ListLayout.COL_TYPE_ITEM_ICON :
					formatItemIcon(e, a_entryObject, a_state);
					break;

				case ListLayout.COL_TYPE_NAME :
					formatName(e, a_entryObject, a_state);
					break;

				case ListLayout.COL_TYPE_TEXT :
				default :
					formatText(e, a_entryObject, a_state);
			}
		}
	}
	
	public function setEntryLayout(a_entryObject: Object, a_state: ListState): Void
	{
		var layout: ListLayout = TabularList(a_state.list).layout;
			
		background._width = selectIndicator._width = layout.entryWidth;
		background._height = selectIndicator._height = layout.entryHeight;
	
		// Set up all visible elements in this entry
		for (var i=0; i<layout.columnCount; i++) {
			var columnLayoutData: ColumnLayoutData = layout.columnLayoutData[i];
			var e = this[columnLayoutData.stageName];
			
			e._visible = true;
		
			e._x = columnLayoutData.x;
			e._y = columnLayoutData.y;
		
			if (columnLayoutData.width > 0)
				e._width = columnLayoutData.width;
		
			if (columnLayoutData.height > 0)
				e._height = columnLayoutData.height;
			
			if (e instanceof TextField)
				e.setTextFormat(columnLayoutData.textFormat);
		}
		
		// Hide any unused elements
		var hiddenStageNames = layout.hiddenStageNames;
		
		for (var i=0; i<hiddenStageNames.length; i++)
			this[hiddenStageNames[i]]._visible = false;

	}
	
	// Do any clip-specific tasks when the view was changed for this entry.
	// @abstract
	public function setSpecificEntryLayout(a_entryObject: Object, a_state: ListState): Void {}

	// @abstract
	public function formatName(a_entryField: Object, a_entryObject: Object, a_state: ListState): Void {}
	
	// @abstract
	public function formatEquipIcon(a_entryField: Object, a_entryObject: Object, a_state: ListState): Void {}

	// @abstract
	public function formatItemIcon(a_entryField: Object, a_entryObject: Object, a_state: ListState): Void {}
	
	// @abstract
	public function formatText(a_entryField: Object, a_entryObject: Object, a_state: ListState): Void {}
}