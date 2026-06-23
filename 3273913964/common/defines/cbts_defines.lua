-- Links
NDefines.NWiki.BASE_URL = "https://en.wikipedia.org/wiki/Main_Page"
-- Vanilla is "http://www.hoi4wiki.com/"

-- Game
NDefines.NGame.START_DATE = "1933.1.1.12"                                   -- Vanilla: 1936.1.1.12
NDefines.NGame.END_DATE = "1948.1.1.1"                                      -- Vanilla: 1949.1.1.1
NDefines.NGame.SAVE_VERSION = 4                                            -- 1.11.0 (Barbarossa)
NDefines.NGame.DECISION_ALERT_TIMEOUT_DAYS = 60                             -- Vanilla: 30
NDefines.NGame.HANDS_OFF_START_TAG = "CUB"                                  -- Vanilla: URG
NDefines.NGame.GAME_SPEED_SECONDS = { 1.0, 0.25, 0.1, 0.05, 0.0 } 
-- Country
NDefines.NCountry.MAJOR_MIN_FACTORIES = 50                                  -- Vanilla: 35
NDefines.NCountry.RESISTANCE_IMPORTANT_LEVEL = 0.24                         -- Vanilla: 0.25
NDefines.NCountry.STATE_OCCUPATION_COST_MULTIPLIER = 0.25                   -- Vanilla: 0.01
NDefines.NCountry.BASE_FUEL_GAIN_PER_OIL = 2.4                              -- Vanilla: 2
NDefines.NCountry.BASE_FUEL_GAIN = 1                                      -- Vanilla: 2
NDefines.NCountry.SPECIAL_FORCES_CAP_MIN = 32								-- Vanilla: 24
NDefines.NCountry.SCORCHED_EARTH_STATE_COST = 8 							-- Vanilla: 5

--Trade
NDefines.NTrade.BASE_TRADE_FACTOR = 85                                     -- Vanilla: 150
NDefines.NTrade.RELATION_TRADE_FACTOR = 0.7                                 -- Vanilla: 1
-- Diplomacy
NDefines.NDiplomacy.DIPLOMACY_REQUEST_EXPIRY_DAYS = 40                      -- Vanilla: 30
NDefines.NDiplomacy.MAX_TRUST_VALUE = 200									-- Vanilla is 100
NDefines.NDiplomacy.MIN_TRUST_VALUE = -200									-- Vanilla is -100
NDefines.NDiplomacy.MAX_OPINION_VALUE = 200                                 -- Vanilla: 100
NDefines.NDiplomacy.MIN_OPINION_VALUE = -200                                -- Vanilla: -100
NDefines.NDiplomacy.VERY_GOOD_OPINION = 100									-- Vanilla: 50
NDefines.NDiplomacy.VERY_BAD_OPINION = -100									-- Vanilla: -50
NDefines.NDiplomacy.FRONT_IS_DANGEROUS = -50									-- Vanilla: -100

NDefines.NDiplomacy.BASE_PEACE_PUPPET_FACTOR = 0                            -- Vanilla: 100
NDefines.NDiplomacy.BASE_PEACE_LIBERATE_FACTOR = 0                          -- Vanilla: 100
NDefines.NDiplomacy.PEACE_SCORE_PER_PASS = 0.65                             -- Vanilla: 0.2

NDefines.NDiplomacy.TENSION_TIME_SCALE_START_DATE = "1933.1.1.12"	-- Starting at this date, the tension values will be scaled down (will be equal to 1 before that) Vanilla: 1936.1.1.12

-- World Tension
-- NDefines.NDiplomacy.TENSION_CB_WAR = 3										-- Vanilla is 7
NDefines.NDiplomacy.TENSION_ANNEX_NO_CLAIM = 3								-- Vanilla is 2
NDefines.NDiplomacy.TENSION_VOLUNTEER_FORCE_DIVISION = 0					-- Vanilla is 0.5

-- Peace Conference
-- NDefines.NDiplomacy.BASE_PEACE_PUPPET_FACTOR = 0							-- Vanilla: 100
-- NDefines.NDiplomacy.BASE_PEACE_LIBERATE_FACTOR = 0							-- Vanilla: 100
-- NDefines.NDiplomacy.PEACE_SCORE_PER_PASS = 0.5								-- Vanilla: 0.2
-- NDefines.NCountry.STATE_OCCUPATION_COST_MULTIPLIER = 0.10					-- Vanilla: 0.01

-- Politics
NDefines.NPolitics.BASE_POLITICAL_POWER_INCREASE = 1.5                      -- Vanilla: 2

-- Buildings
NDefines.NBuildings.OWNER_CHANGE_EXTRA_SHARED_SLOTS_FACTOR = 1              -- Vanilla: 0.5
NDefines.NBuildings.INFRASTRUCTURE_RESOURCE_BONUS = 0.05                    -- Vanilla: 0.1

-- Technology
NDefines.NTechnology.BASE_TECH_COST = 125                                   -- Vanilla: 85
NDefines.NTechnology.MIN_RESEARCH_SPEED = 0.05                              -- Vanilla: 0.1

-- Agency and Operations
NDefines.NOperatives.AGENCY_CREATION_DAYS = 120                             -- Vanilla: 30
NDefines.NOperatives.AGENCY_UPGRADE_DAYS = 60                               -- Vanilla: 30
NDefines.NOperatives.AGENCY_CREATION_FACTORIES = 10                         -- Vanilla: 5
--NDefines.NOperatives.AGENCY_UPGRADE_PER_OPERATIVE_SLOT = 4                 -- Vanilla: 5
NDefines.NOperatives.MAX_OPERATIVE_SLOT_FROM_AGENCY_UPGRADES = 2            -- Vanilla: 1
NDefines.NMilitary.NEW_OPERATIVE_RANDOM_PERSONALITY_TRAIT_CHANCES = {       -- chances to gain a personality trait for new operatives
    0.6, -- Vanilla: 50% for first trait
    0.15 -- Vanilla: 10% for second trait after that
}
NDefines.NMilitary.NEW_OPERATIVE_RANDOM_BASIC_TRAIT_CHANCES = {             -- chances to gain a basic trait for new operatives
    0.30, -- Vanilla: 25% ; for first trait
    0.10  -- Vanilla: 5% ; for second trait after that
}
NDefines.NOperatives.OPERATIVE_BASE_INTEL_NETWORK_GAIN = 0.32				-- Vanilla: 0.4 Base amount of network strength gain per day provided by an operative
-- NDefines.NOperatives.MAX_RECRUITED_OPERATIVES = 12                          -- Vanilla: 10
NDefines.NOperatives.OPERATION_COMPLETION_XP = 24                           -- Vanilla: 18
NDefines.NOperatives.OPERATIVE_BASE_ROOT_OUT_RESISTANCE_EFFICIENCY = 0.9    -- Vanilla: 1.0 ; The base efficiency of an operative at the RootOutResistance mission (this is a percentage, 1.0 == 100%)
-- NDefines.NOperatives.OPERATIVE_BASE_BOOST_IDEOLOGY = 0.08                   -- Vanilla: 0.1 ; Base amount of daily ideology drift provoked by an operative

-- used for calculating how many operatives will a spy master gain from its faction members
-- first number in every now is number of operatives gained
-- second number is total factory needed (mil and civ) for giving previous ratio
NDefines.NOperatives.OPERATIVE_SLOTS_FROM_FACTION_MEMBERS_FOR_SPY_MASTER = {
    0.0, 	0.0, -- 0 operative for [0, 10)
    0.25,  	10.0, -- 0.25 operative for [10, 50)
    0.5, 	50.0, -- 0.5 operative for [50, 90]
    0.75,   90.0, -- 0.75 operative for >= 90
}

-- Military
NDefines.NMilitary.MAX_DIVISION_SUPPORT_WIDTH = 2                           -- Vanilla: 1
NDefines.NMilitary.BASE_DIVISION_BRIGADE_CHANGE_COST = 10                   -- Vanilla: 5
NDefines.NMilitary.BASE_DIVISION_BRIGADE_GROUP_COST = 25                    -- Vanilla: 20
NDefines.NMilitary.BASE_DIVISION_SUPPORT_SLOT_COST = 15                     -- Vanilla: 10
NDefines.NMilitary.COMBAT_MINIMUM_TIME = 2                                  -- Vanilla: 4

-- Volunteers
NDefines.NAI.SEND_VOLUNTEER_EVAL_BASE_DISTANCE = 1000.0  					-- Vanilla is 175.0
NDefines.NAI.SEND_VOLUNTEER_EVAL_CONTAINMENT_FACTOR = 0						-- Vanilla is 0.1
NDefines.NDiplomacy.VOLUNTEERS_DIVISIONS_REQUIRED = 0						-- Vanilla is 30
NDefines.NDiplomacy.VOLUNTEERS_PER_TARGET_PROVINCE = 0.025					-- Vanilla is 0.05
NDefines.NDiplomacy.VOLUNTEERS_PER_COUNTRY_ARMY = 0.025						-- Vanilla is 0.05

-- Battleplan AI
NDefines.NAI.HOUR_BAD_COMBAT_REEVALUATE = 60                                -- Vanilla: 100
NDefines.NAI.AI_FRONT_MOVEMENT_FACTOR_FOR_READY = 0.2                       -- Vanilla: 0.25
NDefines.NAI.MIN_PLAN_VALUE_TO_MICRO_INACTIVE = 0.1                         -- Vanilla: 0.2
NDefines.NAI.MIN_PLAN_VALUE_TO_MICRO_INACTIVE = 0.1							-- Vanilla: 0.2

--NDefines.NAI.VP_LEVEL_IMPORTANCE_HIGH = 25                                  -- Vanilla: Undefined
--NDefines.NAI.VP_LEVEL_IMPORTANCE_LOW = 3                                    -- Vanilla: Undefined

-- Combat AI
--NDefines.NAI.MAX_DIST_PORT_RUSH = 40.0                                      -- Vanilla: 20.0
NDefines.NAI.FORTIFIED_RATIO_TO_CONSIDER_A_FRONT_FORTIFIED = 0.4            -- Vanilla: 0.5
--NDefines.NAI.HEAVILY_FORTIFIED_RATIO_TO_CONSIDER_A_FRONT_FORTIFIED = 0.3    -- Vanilla: 0.5
--NDefines.NAI.INVASION_DISTANCE_RANDOMNESS = 400                             -- Vanilla: 300
NDefines.NMilitary.PLAN_EXECUTE_CAREFUL_MAX_FORT = 4                        -- Vanilla: 5
NDefines.NAI.ATTACK_HEAVILY_DEFENDED_LIMIT = 0.8                            -- Vanilla: 0.5

-- Production AI
NDefines.NAI.WAIT_YEARS_BEFORE_FREER_BUILDING = 6                           -- Vanilla: 3
-- NDefines.NAI.MANPOWER_RESERVED_THRESHOLD = 0.1                              -- Vanilla: Undefined
NDefines.NAI.DEPLOY_MIN_TRAINING_WAR_FACTOR = 0.50                          -- Vanilla: 0.95
NDefines.NAI.DEPLOY_MIN_EQUIPMENT_WAR_FACTOR = 0.90                         -- Vanilla: 0.95
--NDefines.NAI.MIN_FIELD_STRENGTH_TO_BUILD_UNITS = 0.6                        -- Vanilla: 0.7
--NDefines.NAI.MIN_MANPOWER_TO_BUILD_UNITS = 0.6                              -- Vanilla: 0.7
--NDefines.NAI.UPGRADE_DIVISION_RELUCTANCE = 14                               -- Vanilla: 7

-- Which settings will AI use for area defense by default
NDefines.NAI.AREA_DEFENSE_SETTING_VP = true
NDefines.NAI.AREA_DEFENSE_SETTING_COASTLINES = false

-- Naval Invasions AI (numbers taken from BICE)
NDefines.NAI.ENEMY_NAVY_STRENGTH_DONT_BOTHER = 1.9                          -- If the enemy has a navy at least these many times stronger that the own, don't bother invading. Vanilla: 2.5
NDefines.NAI.RELATIVE_STRENGTH_TO_INVADE = 0.09                             -- Compares the estimated strength of the country/faction compared to it's enemies to see if it should invade or stay at home to defend. Vanilla: 0.08
-- NDefines.NAI.RELATIVE_STRENGTH_TO_INVADE_DEFENSIVE = 0.1                 -- Compares the estimated strength of the country/faction compared to it's enemies to see if it should invade or stay at home to defend, but while being a defensive country. Vanilla: 0.4

NDefines.NAI.MAX_INVASION_SIZE = 14 								   	    -- max invasion group size. Vanilla: 24
NDefines.NAI.MAX_UNIT_RATIO_FOR_INVASIONS = 0.3                             -- countries won't use armies more than this ratio of total units for invasions. Vanilla: 0.4
-- NDefines.NAI.MIN_UNIT_RATIO_FOR_INVASIONS = 0.1                          -- don't allocate more divisions than this for naval invasions. Vanilla: 0.1
-- NDefines.NAI.MIN_INVASION_PLAN_VALUE_TO_EXECUTE = 0.2                    -- ai will only activate invasions if plan value is above this. Vanilla: 0.2
-- NDefines.NAI.MIN_INVASION_ORG_FACTOR_TO_EXECUTE = 0.75				    -- ai will only activate invasions if average org factor is above this. Vanilla: 0.75
NDefines.NAI.MAX_INVASION_FRONT_SCORE = 2000                                -- max score for naval invasion front scores. Vanilla: 1000
-- NDefines.NAI.INVASION_DISTANCE_RANDOMNESS = 300                             -- The higher this value, the more unpredictable the invasions. Compares to actual map distance in pixels. Vanilla: 300
NDefines.NAI.INVASION_COASTAL_PROVS_PER_ORDER = 14                          -- AI will consider one extra invasion per number of provinces stated here (num orders = total coast / this). Vanilla: 24
-- NDefines.NAI.MIN_FRONT_SCORE_FOR_AFTER_INVASION_AREAS = 1500             -- min score for army fronts that are created on recently invaded regions. Vanilla: 1500
-- NDefines.NAI.NAVAL_INVADED_AREA_PRIO_DURATION = 90                          -- after successful invasion, AI will prio the enemy area for this number of days. Vanilla: 90
NDefines.NAI.NAVAL_INVADED_AREA_PRIO_MULT = 2.0                             -- fronts that belongs to recent invasions gets more prio. Vanilla: 1.2
NDefines.NAI.MIN_NUM_CONQUERED_PROVINCES_TO_DEPRIO_NAVAL_INVADED_FRONTS = 30    -- if you conquer this amount of provinces after a naval invasion, it will lose its prio status and will act as a regular front. Vanilla: 20

-- NDefines.NAI.FAILED_INVASION_AVOID_DURATION = 135                        -- after a failed invasion, AI will down-prioritize invading the same area again for this number of days. Vanilla: 135
-- NDefines.NAI.FAILED_INVASION_AREA_PRIO_FACTOR = 0.5                      -- for every failed invasion on an area, factor that area's invasion prio with this value. Vanilla: 0.5
-- NDefines.NAI.FAILED_INVASION_PORT_PRIO_FACTOR = 0.66                     -- for every failed invasion on a target port (province), factor the chance that we try to invade that same port again (relative to other ports). Vanilla: 0.66

-- NDefines.NAI.MIN_INVASION_AREA_SIZE_FOR_FLOATING_HARBORS = 15            -- AI will consider using floating harbors for naval invasion if invasion area is larger than this many provinces. Vanilla: 15

-- Graphics
NDefines.NGraphics.POLITICAL_GRID_SMALL_BOX_LIMIT = 12						-- Vanilla: 6
NDefines.NGraphics.COUNTRY_FLAG_TEX_MAX_SIZE = 2048                         -- Tweak dependly on amount of countries. Must be power of 2. No more than 2048. Vanilla: 256
NDefines.NGraphics.COUNTRY_FLAG_SMALL_TEX_MAX_SIZE = 512                    -- Tweak dependly on amount of countries. Must be power of 2. No more than 2048. Vanilla: 256
-- NDefines.NGraphics.COUNTRY_FLAG_SMALL_TEX_WIDTH = 11						-- Vanilla: 10
-- NDefines.NGraphics.COUNTRY_FLAG_STRIPE_TEX_MAX_HEIGHT = 8196             -- Vanilla: 4096
NDefines.NGraphics.COUNTRY_FLAG_STRIPE_TEX_MAX_WIDTH = 10					-- Vanilla: 10
NDefines.NGraphics.COUNTRY_FLAG_LARGE_STRIPE_MAX_WIDTH = 41                 -- Vanilla: 41
NDefines.NGraphics.COUNTRY_FLAG_LARGE_STRIPE_MAX_HEIGHT = 24000             -- Vanilla: 8192
NDefines.NGraphics.VICTORY_POINT_MAP_ICON_TEXT_CUTOFF = {200, 350, 600}     -- Vanilla: 100, 250, 500
NDefines.NGraphics.VICTORY_POINTS_DISTANCE_CUTOFF = {300, 500, 1000}        -- Vanilla: 300, 500, 1500

-- Topbar
Nlua = {
    NTopbar = {
        GAME_SPEED_LIMIT = 0,	-- Unlocks Speed to match as much as the proccessor can handle
        GAME_SPEED_STEPS = 5,	-- DONT CHANGE -- Deals with graphics and speed settings
        GAME_SPEED_ONE = 1,	-- DONT CHANGE --
        GAME_SPEED_TWO = 2,	-- DONT CHANGE --
        GAME_SPEED_THREE = 3,	-- DONT CHANGE --
        GAME_SPEED_FOUR = 4,	-- DONT CHANGE --
        GAME_SPEED_FIVE = 5,	-- DONT CHANGE --
    }
}