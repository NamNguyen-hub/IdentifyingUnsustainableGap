on run argv
    set fileName to (item 1 of argv)
    set pageNum to (item 2 of argv) as integer

    tell application "Skim"
        open fileName
        close document 1
        open fileName
        tell document 1 to go to page pageNum
        tell document 1 to set view settings to {auto scales:true}	
    end tell

    tell application "System Events"
        tell process "Skim"
            try
                set theWindow to (first window whose name contains "_main.pdf")
                perform action "AXRaise" of theWindow
                do shell script "open -a Skim"
            end try
        end tell
    end tell

end run


