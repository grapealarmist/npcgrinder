<#
    File: NPCgrinder.ps1
    Version: 13
    Modified: 2017-04-17

    !!
    This file requires the JSON data file mentioned below. It literally
    can't even pick a gender without it.

    !!
    You will need to change two things to make it work:
    1. The JSON data file location
    2. The ouput file location
#>

param (
    [string]$OutputToHere = 'C:\Example\OutTest.html',
    [string]$DataFile = 'C:\Example\NPCgrinderData.json'

)

$JSONdata = Get-Content $DataFile | ConvertFrom-Json

############################################################## Common functions
function Get-TrueOrFalse { 
    # This just randomly returns true or false.
    # Used as a coin flip for some naming stuff.
    $Rando = Get-Random -Minimum 1 -Maximum 100 
    if ($Rando%2) {return $True}
    else {return $False}
}

function Get-SingleStat {
    # This function generates a random value from a weighted list of stats
    # between 6 and 14. This list is weighted in this way to represent a
    # more or less "average" person on the theory that 10 is average.
    return $JSONdata.WeightedStat | Get-Random
}

function Set-Stats {
    # This function sets the six base stats using the Get-SingleStat function.
    # It just adds them directly to the character object.
    $JSONdata.BaseStats | foreach {
        $ThisOne = Get-SingleStat
        Add-Member -InputObject $Character -MemberType NoteProperty -Name $_ -Value $ThisOne
    }
}

function Set-Skills {
    # Strength-based
    #Athletics
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Athletics" -Value $Character.Strength
    
    # Dexterity-based
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Acrobatics" -Value $Character.Dexterity
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "SleightOfHand" -Value $Character.Dexterity
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Stealth" -Value $Character.Dexterity
    
    # Constitution-based
    # :(
    
    # Intelligence-based
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Arcana" -Value $Character.Intelligence
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "History" -Value $Character.Intelligence
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Investigation" -Value $Character.Intelligence
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Nature" -Value $Character.Intelligence
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Religion" -Value $Character.Intelligence
    
    # Wisdom-based
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "AnimalHandling" -Value $Character.Wisdom
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Insight" -Value $Character.Wisdom
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Medicine" -Value $Character.Wisdom
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Perception" -Value $Character.Wisdom
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Survival" -Value $Character.Wisdom

    # Charisma-based
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Deception" -Value $Character.Charisma
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Intimidation" -Value $Character.Charisma
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Performance" -Value $Character.Charisma
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Persuasion" -Value $Character.Charisma
}

function Set-Race {
    # This function is used to set a race for the character.
    # It is weighted to more or less reflect what you would run into in a city
    # in Faerun, but the numbers are my approximate guesses.
    
    $YoRace = switch (Get-Random -Minimum 1 -Maximum 101) {
        {$_ -le 1}{"Orc"; break}
        {$_ -le 2}{"Tiefling"; break}
        {$_ -le 3}{"Dragonborn"; break}
        {$_ -le 5}{"Gnome"; break}
        {$_ -le 7}{"Halfling"; break}
        {$_ -le 9}{"Half-Orc"; break}
        {$_ -le 13}{"Dwarf"; break}
        {$_ -le 17}{"Elf"; break}
        {$_ -le 22}{"Half-Elf"; break}
        default {"Human"}
    }
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Race" -Value $YoRace
}

function Set-Gender {
    # This function is used to set gender.
	# The classic binary genders are the only ones supported right now, but
	# the you could modify it to include others if you were inclined.
    $YoGender = $JSONdata.Genders | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Gender" -Value $YoGender
}

function Set-Name {
    # This function will kick off the name generating process.
    # This is all still in draft form, so some of the races don't have a
    # specific naming function yet. Those that don't just use the generic one.
    switch ($Character.Race) {
        "Orc" {Set-OrcName}
        "Tiefling" {Set-GenericName}
        "Dragonborn" {Set-GenericName}
        "Gnome" {Set-GenericName}
        "Halfling" {Set-GenericName}
        "Half-Orc" {Set-HalfOrcName}
        "Dwarf" {Set-DwarfName}
        "Elf" {Set-ElfName}
        "Half-Elf" {Set-HalfElfName}
        "Human" {Set-GenericName}
        default {"This isn't working right"}
    }
}

function Set-GenericName {
    # This is the generic name generator. Good for humans, but occassionaly
    # creatures of other races will end up with a common name as well.
    # Nothing special, just a first and last name from the list based on
    # the gender of the character.
    switch ($Character.Gender) {
        "Male" {$FirstName = $JSONdata.CommonMaleFirstNames | Get-Random}
        "Female" {$FirstName = $JSONdata.CommonFemaleFirstNames | Get-Random}
        default {"This isn't working right"}
    }
    $LastName = $JSONdata.CommonLastNames | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"

}

function Set-ElfName {
    # I didn't bother with gender for elves. Their names are all fairly 
    # gender-neutral anyway...
    $FirstName = $JSONdata.ElfFirstNames | Get-Random
    $LastName = $JSONdata.ElfLastNames | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"
}

function Set-DwarfName {
    # Nothing too fancy about dwarven names, just pulling from the lists...
    switch ($Character.Gender) {
        "Male" {$FirstName = $JSONdata.DwarfMaleFirstNames | Get-Random}
        "Female" {$FirstName = $JSONdata.DwarfFemaleFirstNames | Get-Random}
        default {"This isn't working right"}
    }    
    $LastName = $JSONdata.DwarfLastNames | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"
}

function Set-OrcName {
    # I have no idea if there is a difference between male and female orc names.
    $FirstName = $JSONdata.OrcFirstNames | Get-Random
    $LastName = $JSONdata.OrcLastNames | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"
}

function Set-HalfElfName {
    # Half elves have a stacked set of choices given that they might have a
    # human or elven name. The chance of either is just 50/50.
    # This is true for both first and last name.
    ## Pick a first name
    if (Get-TrueOrFalse) {
        switch ($Character.Gender) {
            "Male" {$FirstName = $JSONdata.CommonMaleFirstNames | Get-Random}
            "Female" {$FirstName = $JSONdata.CommonFemaleFirstNames | Get-Random}
            default {"This isn't working right"}
        }
    }
    else {
        $FirstName = $JSONdata.ElfFirstNames | Get-Random
    }
    ## Pick a last name
    if (Get-TrueOrFalse) {
        $LastName = $JSONdata.CommonLastNames | Get-Random
    }
    else {
        $LastName = $JSONdata.ElfLastNames | Get-Random
    }    
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"
}

function Set-HalfOrcName {
    # Half orcs have a stacked set of choices given that they might have a
    # human or orcish name. The chance of either is just 50/50.
    # This is true for both first and last name.
    ## Pick a first name
    if (Get-TrueOrFalse) {
        switch ($Character.Gender) {
            "Male" {$FirstName = $JSONdata.CommonMaleFirstNames | Get-Random}
            "Female" {$FirstName = $JSONdata.CommonFemaleFirstNames | Get-Random}
            default {"This isn't working right"}
        }
    }
    else {
        $FirstName = $JSONdata.OrcFirstNames | Get-Random        
    }
    ## Pick a last name
    if (Get-TrueOrFalse) {
        $LastName = $JSONdata.CommonLastNames | Get-Random
    }
    else {
        $LastName = $JSONdata.OrcLastNames | Get-Random
    }
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Name" -Value "$FirstName $LastName"
}

function Set-Possessions {
    # Money
    $MoneyQty = Get-Random -Minimum 4 -Maximum 40
    $MoneyType = $JSONdata.CurrencyTypes | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "LootMoney" -Value "$MoneyQty $MoneyType"
    # Item
    $RandomItem = $JSONdata.RandomLoot | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "LootItem" -Value $RandomItem
}

function Set-Mannerism {
    $Mannerism = $JSONdata.Mannerisms | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Mannerism" -Value $Mannerism
}

function Set-Demeanor {
    $Demeanor = $JSONdata.Demeanor | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Demeanor" -Value $Demeanor
}

function Set-Ideal {
    $Ideal = $JSONdata.Ideals | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Ideal" -Value $Ideal
}

function Set-Bond {
    $Bond = $JSONdata.Bonds | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Bond" -Value $Bond
}

function Set-Flaw {
    $Flaw = $JSONdata.Flaws | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Flaw" -Value $Flaw
}

function Set-RandomFact {
    $RandomFact = $JSONdata.RandomFact | Get-Random
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "RandomFact" -Value $RandomFact
}

function Set-PhysicalTraits {
    $Trait1 = $JSONdata.PhysicalTraits | Get-Random
    $Trait2 = $JSONdata.PhysicalTraits | Get-Random
    if ($Trait1 -eq $Trait2) {
        $YoTrait = $Trait1
    }
    else {
        $YoTrait = "$Trait1 and $Trait2"
    }
    $YoTrait = $YoTrait.substring(0,1).toupper()+$YoTrait.substring(1)
    Add-Member -InputObject $Character -MemberType NoteProperty -Name "Trait" -Value $YoTrait
}

function Dump-HTML {
    $HTMLOutput = "<html><head><style type=`"text/css`">div{margin:2px;}#TopSection{width:100%;float:left;border-top:2px solid black;border-left: 2px solid black;}#BaseStatBlock{border-top: 2px solid black;border-left: 2px solid black;float: left;clear: both;}#SkillBlock1 {border-top: 2px solid black;border-left: 2px solid black;float: left;}#SkillBlock2 {border-top: 2px solid black;border-left: 2px solid black;float: left;}.TopAttribute {float: left;width: 8em;font-weight: bold;}.TopValue {float: left;}.Container {width: 100%;border: none;border-bottom: 1px solid black;float: left;clear: both;}.Attribute {width:8em;float:left;font-weight: bold;}.Value {text-align:right;width:2em;float:right;}</style></head><body><div id=`"TopSection`"><div class=`"Container`"><div class=`"TopAttribute`">Name</div><div class=`"TopValue`">" + $Character.Name + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Race</div><div class=`"TopValue`">" + $Character.Race + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Gender</div><div class=`"TopValue`">" + $Character.Gender + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Mannerism</div><div class=`"TopValue`">" + $Character.Mannerism + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Demeanor</div><div class=`"TopValue`">" + $Character.Demeanor + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Ideal</div><div class=`"TopValue`">" + $Character.Ideal + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Bond</div><div class=`"TopValue`">" + $Character.Bond + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Flaw</div><div class=`"TopValue`">" + $Character.Flaw + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Random Fact</div><div class=`"TopValue`">" + $Character.RandomFact + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Physical Trait</div><div class=`"TopValue`">" + $Character.Trait + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Cash</div><div class=`"TopValue`">" + $Character.LootMoney + "</div></div><div class=`"Container`"><div class=`"TopAttribute`">Item</div><div class=`"TopValue`">" + $Character.LootItem + "</div></div></div><div id=`"BaseStatBlock`"><div class=`"Container`"><div class=`"Attribute`">Strength</div><div class=`"Value`">" + $Character.Strength + "</div></div><div class=`"Container`"><div class=`"Attribute`">Dexterity</div><div class=`"Value`">" + $Character.Dexterity + "</div></div><div class=`"Container`"><div class=`"Attribute`">Constitution</div><div class=`"Value`">" + $Character.Constitution + "</div></div><div class=`"Container`"><div class=`"Attribute`">Intelligence</div><div class=`"Value`">" + $Character.Intelligence + "</div></div><div class=`"Container`"><div class=`"Attribute`">Wisdom</div><div class=`"Value`">" + $Character.Wisdom + "</div></div><div class=`"Container`"><div class=`"Attribute`">Charisma</div><div class=`"Value`">" + $Character.Charisma + "</div></div></div><div id=`"SkillBlock1`"><div class=`"Container`"><div class=`"Attribute`">Acrobatics</div><div class=`"Value`">" + $Character.Acrobatics + "</div></div><div class=`"Container`"><div class=`"Attribute`">Animal Handling</div><div class=`"Value`">" + $Character.AnimalHandling + "</div></div><div class=`"Container`"><div class=`"Attribute`">Arcana</div><div class=`"Value`">" + $Character.Arcana + "</div></div><div class=`"Container`"><div class=`"Attribute`">Athletics</div><div class=`"Value`">" + $Character.Athletics + "</div></div><div class=`"Container`"><div class=`"Attribute`">Deception</div><div class=`"Value`">" + $Character.Deception + "</div></div><div class=`"Container`"><div class=`"Attribute`">History</div><div class=`"Value`">" + $Character.History + "</div></div><div class=`"Container`"><div class=`"Attribute`">Insight</div><div class=`"Value`">" + $Character.Insight + "</div></div><div class=`"Container`"><div class=`"Attribute`">Intimidation</div><div class=`"Value`">" + $Character.Intimidation + "</div></div><div class=`"Container`"><div class=`"Attribute`">Investigation</div><div class=`"Value`">" + $Character.Investigation + "</div></div></div><div id=`"SkillBlock2`"><div class=`"Container`"><div class=`"Attribute`">Medicine</div><div class=`"Value`">" + $Character.Medicine + "</div></div><div class=`"Container`"><div class=`"Attribute`">Nature</div><div class=`"Value`">" + $Character.Nature + "</div></div><div class=`"Container`"><div class=`"Attribute`">Perception</div><div class=`"Value`">" + $Character.Perception + "</div></div><div class=`"Container`"><div class=`"Attribute`">Performance</div><div class=`"Value`">" + $Character.Performance + "</div></div><div class=`"Container`"><div class=`"Attribute`">Persuasion</div><div class=`"Value`">" + $Character.Persuasion + "</div></div><div class=`"Container`"><div class=`"Attribute`">Religion</div><div class=`"Value`">" + $Character.Religion + "</div></div><div class=`"Container`"><div class=`"Attribute`">Sleight of Hand</div><div class=`"Value`">" + $Character.SleightOfHand + "</div></div><div class=`"Container`"><div class=`"Attribute`">Stealth</div><div class=`"Value`">" + $Character.Stealth + "</div></div><div class=`"Container`"><div class=`"Attribute`">Survival</div><div class=`"Value`">" + $Character.Survival + "</div></div></div></body></html>"
    $HTMLOutput | Out-File -FilePath $OutputToHere
}


########################################################################## MAIN

$Character = New-Object psobject
function Create-Charcter {
    Set-Race
    Set-Gender
    Set-Name
    Set-Stats
    Set-Skills
    Set-Mannerism
    Set-Demeanor
    Set-Ideal
    Set-Bond
    Set-Flaw
    Set-RandomFact
    Set-PhysicalTraits
    Set-Possessions
}

Create-Charcter
Dump-HTML
