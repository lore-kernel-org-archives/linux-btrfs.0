Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21369 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbdIRROK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:14:10 -0400
Date: Mon, 18 Sep 2017 14:14:08 -0300
From: grondinm <marcfgrondin@gcfam.net>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Message-ID: <15e95fb9dad.106adde5c581450.625084479133539284@gcfam.net>
In-Reply-To: 
Subject: Help Recovering BTRFS array
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I will try to provide all information pertinent to the situation i find myself in.

Yesterday while trying to write some data to a BTRFS filesystem on top of a mdadm raid5 array encrypted with dmcrypt comprising of 4 1tb HDD my system became unresponsive and i had no choice but to hard reset. System came back up no problem and the array in question mounted without a complaint. Once i tried to write data to it again however the system became unresponsive again and required another hard reset. Again system came back up and everything mounted with no complaints.

This time i decided to run some checks. Ran a raid check by issuing 'echo check > /sys/block/md0/md/sync_action'. This completed without a single error. So i performed a proper restart just because and once the system came back up i initiated a scrub on the btrfs filesystem. This greeted me with my first indication that something is wrong:

btrfs sc stat /media/Storage2 
scrub status for e5bd5cf3-c736-48ff-b1c6-c9f678567788
        scrub started at Mon Sep 18 06:05:21 2017, running for 07:40:47
        total bytes scrubbed: 1.03TiB with 1 errors
        error details: super=1
        corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

I was concerned but since it was still scrubbing i left it. Now things look really bleak... 

Every few minutes the scrub process goes into a D status as shown by htop it eventually keeps going and as far as i can see is still scrubbing(slowly). I decided to check a something else(based on the error above) I ran btrfs inspect-internal dump-super -a -f /dev/md0 which gave me this:

superblock: bytenr=65536, device=/dev/md0 
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/md0 at 65536

superblock: bytenr=67108864, device=/dev/md0
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/md0 at 67108864

superblock: bytenr=274877906944, device=/dev/md0
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/md0 at 274877906944

Now i'm really panicked. Is the FS toast? Can any recovery be attempted?

Here is the output of dump-super with the -F option:

superblock: bytenr=65536, device=/dev/md0
---------------------------------------------------------
csum_type               43668 (INVALID)
csum_size               32
csum                    0x76c647b04abf1057f04e40d1dc52522397258064b98a1b8f6aa6934c74c0dd55 [DON'T MATCH]
bytenr                  6376050623103086821
flags                   0x7edcc412b742c79f
                        ( WRITTEN |
                          RELOC |
                          METADUMP |
                          unknown flag: 0x7edcc410b742c79c )
magic                   ..l~...q [DON'T MATCH]
fsid                    2cf827fa-7ab8-e290-b152-1735c2735a37
label                   .a.9.@.=....4.#.|.D...]..dh=d....,..k..n..~.5.....i.8...(.._.tl.a......1sX@..2..Qi....dJ.>Hy.U......{X5.....kG0.)....t..;..../.2...@.T.|.u.<.`!........J*9./....8...&.g....\.V...*.,/95.uEs..W.i..z..h...n(...VGn^F.......H.......5.DT..3.A..mK...~..}.1......n.
generation              1769598730239175261
root                    14863846352370317867
sys_array_size          1744503544
chunk_root_generation   18100024505086712407
root_level              79
chunk_root              10848092274453435018
chunk_root_level        156
log_root                7514172289378668244
log_root_transid        6227239369566282426
log_root_level          18
total_bytes             5481087866519986730
bytes_used              13216280034370888020
sectorsize              4102056786
nodesize                1038279258
leafsize                276348297
stripesize              2473897044
root_dir                12090183195204234845
num_devices             12836127619712721941
compat_flags            0xf98ff436fc954bd4
compat_ro_flags         0x3fe8246616164da7
                        ( FREE_SPACE_TREE |
                          FREE_SPACE_TREE_VALID |
                          unknown flag: 0x3fe8246616164da4 )
incompat_flags          0x3989a5037330bfd8
                        ( COMPRESS_LZO |
                          COMPRESS_LZOv2 |
                          EXTENDED_IREF |
                          RAID56 |
                          SKINNY_METADATA |
                          NO_HOLES |
                          unknown flag: 0x3989a5037330bc10 )
cache_generation        10789185961859482334
uuid_tree_generation    14921288820846890813
dev_item.uuid           e6e382b3-de66-4c25-7cc9-3cc43cde9c24
dev_item.fsid           f8430e37-12ca-adaf-b038-f0ee10ce6327 [DON'T MATCH]
dev_item.type           7909001383421391155
dev_item.total_bytes    4839925749276763097
dev_item.bytes_used     14330418354255459170
dev_item.io_align       4136652250
dev_item.io_width       1113335506
dev_item.sector_size    1197062542
dev_item.devid          16559830033162408461
dev_item.dev_group      3271056113
dev_item.seek_speed     113
dev_item.bandwidth      35
dev_item.generation     15723849675231264550
sys_chunk_array[2048]:
        item 0 key (12549421470303619499 FREE_SPACE_EXTENT 12715844338991310897)
ERROR: unexpected item type 199 in sys_array at offset 17
backup_roots[4]:
        backup 0:
                backup_tree_root:       5918676053091157562     gen: 4599194864203214963        level: 144
                backup_chunk_root:      8975008186939396462     gen: 9664304934392981307        level: 235
                backup_extent_root:     7756240529876556730     gen: 11265888412945796540       level: 76
                backup_fs_root:         14967994453532855475    gen: 14136483082973799135       level: 83
                backup_dev_root:        4954192454133918329     gen: 10448900784675204431       level: 88
                backup_csum_root:       17904990185861936348    gen: 16603807809187172614       level: 7
                backup_total_bytes:     9741488400785312878
                backup_bytes_used:      1720631489440696202
                backup_num_devices:     7931588452052946894

        backup 1:
                backup_tree_root:       13684698678564474567    gen: 33043910689084607  level: 140
                backup_chunk_root:      6974714140403509989     gen: 16650332720823634889       level: 9
                backup_extent_root:     3516452618597086684     gen: 6721909999031129955        level: 223
                backup_fs_root:         5571396873850442777     gen: 9961414730092117271        level: 191
                backup_dev_root:        12512234014059269698    gen: 15283952794535835341       level: 219
                backup_csum_root:       1602565535990769763     gen: 2136912881039835078        level: 131
                backup_total_bytes:     14489406064823832967
                backup_bytes_used:      7530374675662623713
                backup_num_devices:     11808512257789822277

        backup 2:
                backup_tree_root:       1996397391337300003     gen: 18162243921156386044       level: 44
                backup_chunk_root:      4216057549420117484     gen: 17057376761029942685       level: 206
                backup_extent_root:     7825952091071540206     gen: 16405179489532307152       level: 196
                backup_fs_root:         3619121322246444309     gen: 2206909528630697779        level: 138
                backup_dev_root:        13438213769779314384    gen: 16262689976944350697       level: 71
                backup_csum_root:       11158912803848319140    gen: 4080194652350711178        level: 102
                backup_total_bytes:     8272238769505738558
                backup_bytes_used:      2576815956740779944
                backup_num_devices:     3304053143692865210

        backup 3:
                backup_tree_root:       6075859188169321540     gen: 3028573589797862085        level: 29
                backup_chunk_root:      15239419444928921132    gen: 2443952642303102760        level: 12
                backup_extent_root:     6347616010285651669     gen: 2556158545601457306        level: 0
                backup_fs_root:         12762145105300866492    gen: 16088334343865581774       level: 111
                backup_dev_root:        17265158067002101903    gen: 3661539768757457899        level: 128
                backup_csum_root:       5238561502854589650     gen: 13986831142192892137       level: 71
                backup_total_bytes:     1680040557947059672
                backup_bytes_used:      9379121512784539833
                backup_num_devices:     12952468782229959036


superblock: bytenr=67108864, device=/dev/md0
---------------------------------------------------------
csum_type               65211 (INVALID)
csum_size               32
csum                    0x4e1b51fe2fcccfeaff3977e08e271e9479da4ce9d3f67819483cca9caab206bb [DON'T MATCH]
bytenr                  6151545373820009586
flags                   0xa350e057fb4826b7
                        ( WRITTEN |
                          RELOC |
                          SEEDING |
                          METADUMP |
                          METADUMP_V2 |
                          unknown flag: 0xa350e050fb4826b4 )
magic                   .x..V... [DON'T MATCH]
fsid                    ee64660a-2116-e3d1-bc81-57b2815ec175
label                   .....Z.(...B.u.f.../_....?x........!....4.)P+4......s.....6....>#+.U.xD...N.],7.;..z...i...5.g]l....`..."..k.Po.....
generation              9204480862653147048
root                    15374020348068925257
sys_array_size          140002398
chunk_root_generation   5853066660345508532
root_level              163
chunk_root              3974206076299456518
chunk_root_level        221
log_root                6202016390021464484
log_root_transid        14498449761713243809
log_root_level          201
total_bytes             14339628566885106025
bytes_used              17973936159968091942
sectorsize              4203000179
nodesize                2861897139
leafsize                804415224
stripesize              1724696015
root_dir                6813288129527782924
num_devices             13544860601977045288
compat_flags            0x17ba4d6371928997
compat_ro_flags         0x80f879377aba010a
                        ( FREE_SPACE_TREE_VALID |
                          unknown flag: 0x80f879377aba0108 )
incompat_flags          0xf35623bf46fd1c61
                        ( MIXED_BACKREF |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          unknown flag: 0xf35623bf46fd1c00 )
cache_generation        11325987263756088267
uuid_tree_generation    4050409366984057912
dev_item.uuid           bff94652-989f-2b33-72ec-29da20f3b479
dev_item.fsid           9354d3c0-6e85-ef63-4890-6788401fc26d [DON'T MATCH]
dev_item.type           14799036415562724559
dev_item.total_bytes    8381745741598706536
dev_item.bytes_used     15795328293767567346
dev_item.io_align       2308776314
dev_item.io_width       941981659
dev_item.sector_size    1063805735
dev_item.devid          12559357670314928468
dev_item.dev_group      942585008
dev_item.seek_speed     160
dev_item.bandwidth      39
dev_item.generation     18008986788126981566
sys_chunk_array[2048]:
        item 0 key (13965545642286451913 UNKNOWN.255 7678635361941794030)
ERROR: unexpected item type 255 in sys_array at offset 17
backup_roots[4]:
        backup 0:
                backup_tree_root:       1087501316855813684     gen: 12596045152199850401       level: 181
                backup_chunk_root:      6557971774951271289     gen: 10208907930953549416       level: 246
                backup_extent_root:     17481591668916579532    gen: 17453085530363153960       level: 243
                backup_fs_root:         5601146632676646164     gen: 1465306770263226833        level: 12
                backup_dev_root:        10902104218396152245    gen: 6092605485111932734        level: 75
                backup_csum_root:       4442090594103425789     gen: 16911190536176118325       level: 97
                backup_total_bytes:     801355142582085876
                backup_bytes_used:      15028783946215022130
                backup_num_devices:     16206375141624920634

        backup 1:
                backup_tree_root:       6351022532463796747     gen: 12652270837466734092       level: 253
                backup_chunk_root:      2129606227456051738     gen: 7578364203725752851        level: 56
                backup_extent_root:     11797685505978116035    gen: 10821301879062427211       level: 123
                backup_fs_root:         288698854728497504      gen: 3081381278827790906        level: 13
                backup_dev_root:        12061358643958707086    gen: 3512250687651845182        level: 123
                backup_csum_root:       7522723451362117623     gen: 8328549283143475261        level: 218
                backup_total_bytes:     3787127650231681413
                backup_bytes_used:      12262463780944988829
                backup_num_devices:     6357846707684110191

        backup 2:
                backup_tree_root:       12526877211419749609    gen: 1680728446797631925        level: 161
                backup_chunk_root:      16243421936188306600    gen: 14674402491217930546       level: 170
                backup_extent_root:     11709157221414435615    gen: 10762394217518893925       level: 7
                backup_fs_root:         10470162224093528971    gen: 3157933380710680810        level: 141
                backup_dev_root:        9370932758463595836     gen: 8195536874915306599        level: 87
                backup_csum_root:       12862340132242466490    gen: 9499669518915523221        level: 70
                backup_total_bytes:     4872773697414434976
                backup_bytes_used:      1090914674363382351
                backup_num_devices:     7250132742877406898

        backup 3:
                backup_tree_root:       4211606369908709000     gen: 9090072647248956366        level: 35
                backup_chunk_root:      2842930413763548032     gen: 12574535419719702846       level: 227
                backup_extent_root:     14215872060939819175    gen: 14386746624218700558       level: 247
                backup_fs_root:         15269817613881593429    gen: 13012357796004765397       level: 82
                backup_dev_root:        3593902900654541720     gen: 13357519206322201065       level: 75
                backup_csum_root:       5284950982560001279     gen: 7162449733826645409        level: 134
                backup_total_bytes:     2093390614757276942
                backup_bytes_used:      871113832302380517
                backup_num_devices:     820958227809071147


superblock: bytenr=274877906944, device=/dev/md0
---------------------------------------------------------
csum_type               26389 (INVALID)
csum_size               32
csum                    0xe03c6b131b4ec6cb2114a4419277489fbf40b002906b4ed953638893397f6602 [DON'T MATCH]
bytenr                  13664584384672311294
flags                   0x59bdb26c99b54734
                        ( CHANGING_FSID |
                          METADUMP_V2 |
                          unknown flag: 0x59bdb26099b54734 )
magic                   .F.&8... [DON'T MATCH]
fsid                    847b0be0-2312-b08f-a471-273a39e385d4
label                   .C..l...xIg}B>~....&w.T>.<..Ay9 .)p...btH1....;...l..gk.J.....(.....f.|}....n^.M.|.3E.....I....:...)......H...}1.......L......B.l).s........]\[..\.\.X.~.A.x.......h......,.\.&h.y.6..m=.?..t.S.........[>a...(vt@...X......<o...v|.....U.gj...Lq...O.[u.....)0X
generation              12015793396287018420
root                    8265308008657923830
sys_array_size          2413164638
chunk_root_generation   17965737574707260379
root_level              207
chunk_root              14573544619304334351
chunk_root_level        163
log_root                4378696952282061090
log_root_transid        15003646425698952082
log_root_level          164
total_bytes             11252436429982035164
bytes_used              17981997017222930567
sectorsize              2924702014
nodesize                3928239295
leafsize                3697142194
stripesize              3756194375
root_dir                702748544839699505
num_devices             4380849543563758050
compat_flags            0xd9bcafa18166c944
compat_ro_flags         0xb7789875e93811c2
                        ( FREE_SPACE_TREE_VALID |
                          unknown flag: 0xb7789875e93811c0 )
incompat_flags          0x41b06fab5f783f39
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          COMPRESS_LZOv2 |
                          BIG_METADATA |
                          SKINNY_METADATA |
                          NO_HOLES |
                          unknown flag: 0x41b06fab5f783c10 )
cache_generation        2790664258309518082
uuid_tree_generation    14560986793057547729
dev_item.uuid           9e68c747-6dd8-f3fc-1051-88123e6a0adf
dev_item.fsid           75e5ac67-228c-114d-a0bf-10a13b374c0c [DON'T MATCH]
dev_item.type           15303811306433940600
dev_item.total_bytes    15956271228860727248
dev_item.bytes_used     12663614323963693149
dev_item.io_align       742657370
dev_item.io_width       1198324740
dev_item.sector_size    3703211052
dev_item.devid          12808946261635193203
dev_item.dev_group      3986818674
dev_item.seek_speed     91
dev_item.bandwidth      25
dev_item.generation     16511076442895313212
sys_chunk_array[2048]:
        item 0 key (0x01b68e621940ad8f UUID_KEY_SUBVOL 0x07e8f4b15269df74)
ERROR: unexpected item type 251 in sys_array at offset 17
backup_roots[4]:
        backup 0:
                backup_tree_root:       10929332989678721259    gen: 2410752186462201473        level: 168
                backup_chunk_root:      12005036188293733529    gen: 6017658543726827580        level: 4
                backup_extent_root:     5772439121786530440     gen: 9771362028433917927        level: 213
                backup_fs_root:         15873974038452009066    gen: 5162464511863081610        level: 102
                backup_dev_root:        10880196960241275662    gen: 5444842538697534609        level: 76
                backup_csum_root:       732437746216976091      gen: 12889163759242890293       level: 17
                backup_total_bytes:     4726471422280643128
                backup_bytes_used:      7638379647440950994
                backup_num_devices:     16086614005965457184

        backup 1:
                backup_tree_root:       365908921308135486      gen: 7955498484582942906        level: 222
                backup_chunk_root:      2320600280382439909     gen: 16307549195721352448       level: 255
                backup_extent_root:     63915797200689228       gen: 7223963135006628664        level: 122
                backup_fs_root:         12093496594110329491    gen: 8673088152230422327        level: 176
                backup_dev_root:        7071018315773203076     gen: 2123646002765713136        level: 68
                backup_csum_root:       2256649538333048592     gen: 1242771109749269014        level: 209
                backup_total_bytes:     13370841764183390953
                backup_bytes_used:      1581695008980451655
                backup_num_devices:     15998246508876073400

        backup 2:
                backup_tree_root:       2377137025235210394     gen: 3690996016117903730        level: 29
                backup_chunk_root:      15708758458351285828    gen: 17427968661543407470       level: 251
                backup_extent_root:     13419652187983998816    gen: 7021427764963897079        level: 140
                backup_fs_root:         5475447812522438330     gen: 7816979085263009751        level: 33
                backup_dev_root:        16577324916178280834    gen: 6576710502850587987        level: 204
                backup_csum_root:       12227591344944562665    gen: 17430186024557184819       level: 199
                backup_total_bytes:     18360656019908872927
                backup_bytes_used:      3948283139050748388
                backup_num_devices:     9142284180596408193

        backup 3:
                backup_tree_root:       18431410624458069403    gen: 16232386146948169557       level: 215
                backup_chunk_root:      6863200809691904167     gen: 12426138819402850753       level: 233
                backup_extent_root:     12822236089199474581    gen: 13741181971180163621       level: 146
                backup_fs_root:         14102329897235867390    gen: 7763083095823881448        level: 186
                backup_dev_root:        17346249016785915998    gen: 582294204541486187 level: 40
                backup_csum_root:       5772528336744043720     gen: 1284328790601276594        level: 18
                backup_total_bytes:     5440822434798926871
                backup_bytes_used:      12538610060624890670
                backup_num_devices:     7489880256855801674

Thank you

Marc Grondin



