# Baryo Search Bar Design

## Visual Design

**Overall Appearance:**
- Rounded rectangle window (12px corner radius)
- Semi-transparent background with blur effect
- Drop shadow for depth
- Width: 600px, Height: 50px (collapsed), up to 400px (expanded)
- Centered horizontally, positioned 20% from top of screen

**Search Input:**
- Large, clean text field
- Placeholder text: "Search Baryo..."
- No visible borders
- Font: SF Pro Display, 18pt
- Text color: Dynamic (white on dark, black on light)

## Interaction States

**Collapsed State:**
- Just the search input visible
- Height: 50px
- Appears on hotkey press (Cmd+Space)

**Expanded State:**
- Search input + results list
- Height: Dynamic based on results (max 400px)
- Shows up to 8 results initially
- Smooth animation between states

**Results List:**
- Each result: 40px height
- Icon (24x24px) + Title + Subtitle + Shortcut indicator
- Highlight selected result with subtle background
- Keyboard navigation (arrow keys, Enter to select)

## Behavior

**Show/Hide:**
- Global hotkey: Cmd+Space (configurable)
- ESC key or click outside to dismiss
- Auto-hide after selection

**Search:**
- Real-time search as user types
- Minimum 1 character to start search
- Debounced input (200ms delay)
- Show loading indicator for slow searches

**Results Display:**
- Group by type (Apps, Files, Actions, etc.)
- Relevance-based ranking
- Preview on hover/arrow selection
- Quick actions on Tab or Right arrow

## Technical Implementation Notes

**Window Management:**
- NSPanel with NSNonactivatingPanelMask
- Always on top, but not stealing focus
- Floating window level
- Custom NSView for blur/transparency

**Accessibility:**
- Full VoiceOver support
- High contrast mode compatibility
- Reduced motion support
- Keyboard-only navigation