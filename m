Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34357 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943661AbcJSPDy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 11:03:54 -0400
Received: by mail-qk0-f170.google.com with SMTP id f128so38640197qkb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 08:03:48 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, dsterba@suse.com, jbacik@fb.com
From: Nikolay Borisov <kernel@kyup.com>
Subject: Warning in __btrfs_free_extent due to -ENOENT backrefs
Message-ID: <58072AD0.7000109@kyup.com>
Date: Wed, 19 Oct 2016 11:12:00 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

So I got the following warnings on one of my server: 

[361464.059606] ------------[ cut here ]------------
[361464.059831] WARNING: CPU: 6 PID: 7637 at fs/btrfs/extent-tree.c:6543 __btrfs_free_extent.isra.66+0x65c/0xcb0 [btrfs]()
[361464.064134] CPU: 6 PID: 7637 Comm: btrfs-cleaner Tainted: P        W  O    4.4.22-clouder1 #12
[361464.064430] Hardware name: Supermicro X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
[361464.064727]  0000000000000000 ffff880486e03b00 ffffffff812f4999 0000000000000000
[361464.065213]  ffffffffa09e6fda ffff880486e03b38 ffffffff81052bd6 00000000fffffffe
[361464.065697]  0000000002e77000 ffff8805d4a30750 ffff88000513e000 0000000000000000
[361464.066178] Call Trace:
[361464.066355]  [<ffffffff812f4999>] dump_stack+0x67/0x9e
[361464.066531]  [<ffffffff81052bd6>] warn_slowpath_common+0x86/0xc0
[361464.066705]  [<ffffffff81052cca>] warn_slowpath_null+0x1a/0x20
[361464.066890]  [<ffffffffa094cd5c>] __btrfs_free_extent.isra.66+0x65c/0xcb0 [btrfs]
[361464.067194]  [<ffffffffa093ec2f>] ? btrfs_set_path_blocking+0x3f/0x70 [btrfs]
[361464.067500]  [<ffffffffa0950bf8>] __btrfs_run_delayed_refs+0x898/0x12c0 [btrfs]
[361464.067810]  [<ffffffffa09b42e8>] ? btrfs_add_delayed_extent_op+0x98/0xc0 [btrfs]
[361464.068116]  [<ffffffffa094e845>] ? btrfs_set_disk_extent_flags+0x85/0xc0 [btrfs]
[361464.068423]  [<ffffffffa0954382>] btrfs_run_delayed_refs+0x82/0x2f0 [btrfs]
[361464.068616]  [<ffffffffa098c32b>] ? free_extent_buffer+0x4b/0x90 [btrfs]
[361464.068807]  [<ffffffffa0968aa9>] btrfs_should_end_transaction+0x59/0x60 [btrfs]
[361464.069112]  [<ffffffffa0952ba6>] btrfs_drop_snapshot+0x436/0x800 [btrfs]
[361464.072161]  [<ffffffffa0968f83>] btrfs_clean_one_deleted_snapshot+0xb3/0xf0 [btrfs]
[361464.072468]  [<ffffffffa0960e82>] cleaner_kthread+0x1e2/0x280 [btrfs]
[361464.072655]  [<ffffffffa0960ca0>] ? check_leaf+0x340/0x340 [btrfs]
[361464.072833]  [<ffffffff8107174f>] kthread+0xef/0x110
[361464.073009]  [<ffffffff81071660>] ? kthread_park+0x60/0x60
[361464.073188]  [<ffffffff8161547f>] ret_from_fork+0x3f/0x70
[361464.073364]  [<ffffffff81071660>] ? kthread_park+0x60/0x60
[361464.073546] ---[ end trace 03d80b3e257b8bae ]---
[361464.073726] BTRFS info (device loop168): leaf 540753920 total ptrs 101 free space 42
[361464.074021] 	item 0 key (48619520 168 4096) itemoff 3944 itemsize 51
[361464.074198] 		extent refs 1 gen 684 flags 2
[361464.074370] 		tree block key (1690 1 0) level 0
[361464.074543] 		tree block backref root 354
[361464.074722] 	item 1 key (48623616 168 4096) itemoff 3893 itemsize 51
[361464.074898] 		extent refs 1 gen 671 flags 2
[361464.075070] 		tree block key (6027 1 0) level 1
[361464.075243] 		tree block backref root 351
[361464.075415] 	item 2 key (48627712 168 4096) itemoff 3842 itemsize 51
[361464.075591] 		extent refs 1 gen 671 flags 2
[361464.075767] 		tree block key (6066 1 0) level 0
[361464.075942] 		tree block backref root 351
[361464.076114] 	item 3 key (48631808 168 4096) itemoff 3791 itemsize 51
[361464.076294] 		extent refs 1 gen 671 flags 2
[361464.076466] 		tree block key (6071 96 65) level 0
[361464.076647] 		tree block backref root 351
[361464.076826] 	item 4 key (48635904 168 4096) itemoff 3740 itemsize 51
[361464.077003] 		extent refs 1 gen 671 flags 2
[361464.077175] 		tree block key (6070 96 4) level 0
[361464.077348] 		tree block backref root 351
[361464.077519] 	item 5 key (48640000 168 4096) itemoff 3689 itemsize 51
[361464.077694] 		extent refs 1 gen 671 flags 2
[361464.077873] 		tree block key (6073 84 3593620995) level 0
[361464.078048] 		tree block backref root 351
[361464.078220] 	item 6 key (48644096 168 4096) itemoff 3638 itemsize 51
[361464.078397] 		extent refs 1 gen 671 flags 2
[361464.078568] 		tree block key (6076 96 2) level 0
[361464.078747] 		tree block backref root 351
[361464.078920] 	item 7 key (48648192 168 4096) itemoff 3587 itemsize 51
[361464.079097] 		extent refs 1 gen 671 flags 2
[361464.079269] 		tree block key (6082 84 4159721953) level 0
[361464.079443] 		tree block backref root 351
[361464.079615] 	item 8 key (48652288 168 4096) itemoff 3536 itemsize 51
[361464.079794] 		extent refs 1 gen 671 flags 2
[361464.079965] 		tree block key (6086 96 2) level 0
[361464.080134] 		tree block backref root 351
[361464.080303] 	item 9 key (48656384 168 4096) itemoff 3485 itemsize 51
[361464.080476] 		extent refs 1 gen 671 flags 2
[361464.080645] 		tree block key (6094 108 0) level 0
[361464.080821] 		tree block backref root 351
[361464.080991] 	item 10 key (48660480 168 4096) itemoff 3434 itemsize 51
[361464.081165] 		extent refs 1 gen 671 flags 2
[361464.081334] 		tree block key (6099 12 6071) level 0
[361464.081506] 		tree block backref root 351
[361464.081678] 	item 11 key (48664576 168 4096) itemoff 3383 itemsize 51
[361464.081859] 		extent refs 1 gen 671 flags 2
[361464.082033] 		tree block key (6106 108 0) level 0
[361464.082205] 		tree block backref root 351
[361464.082377] 	item 12 key (48668672 168 4096) itemoff 3332 itemsize 51
[361464.082552] 		extent refs 1 gen 671 flags 2
[361464.082736] 		tree block key (6113 96 2) level 0
[361464.082910] 		tree block backref root 351
[361464.083082] 	item 13 key (48672768 168 4096) itemoff 3281 itemsize 51
[361464.083258] 		extent refs 1 gen 671 flags 2
[361464.083430] 		tree block key (6279 108 0) level 0
[361464.083603] 		tree block backref root 351
[361464.083780] 	item 14 key (48676864 168 4096) itemoff 3230 itemsize 51
[361464.083957] 		extent refs 1 gen 671 flags 2
[361464.084129] 		tree block key (6282 12 6118) level 0
[361464.084302] 		tree block backref root 351
[361464.084474] 	item 15 key (48680960 168 4096) itemoff 3179 itemsize 51
[361464.084649] 		extent refs 1 gen 671 flags 2
[361464.084825] 		tree block key (6119 84 2182722276) level 0
[361464.085001] 		tree block backref root 351
[361464.085173] 	item 16 key (48685056 168 4096) itemoff 3128 itemsize 51
[361464.085349] 		extent refs 1 gen 671 flags 2
[361464.085521] 		tree block key (6126 108 0) level 0
[361464.085694] 		tree block backref root 351
[361464.085871] 	item 17 key (48689152 168 4096) itemoff 3077 itemsize 51
[361464.086048] 		extent refs 1 gen 671 flags 2
[361464.086220] 		tree block key (6131 84 36426878) level 0
[361464.086394] 		tree block backref root 351
[361464.086571] 	item 18 key (48693248 168 4096) itemoff 3026 itemsize 51
[361464.086754] 		extent refs 1 gen 671 flags 2
[361464.086928] 		tree block key (6138 84 1048005942) level 0
[361464.087103] 		tree block backref root 351
[361464.087275] 	item 19 key (48697344 168 4096) itemoff 2975 itemsize 51
[361464.087451] 		extent refs 1 gen 671 flags 2
[361464.087624] 		tree block key (6290 108 0) level 1
[361464.087802] 		tree block backref root 351
[361464.087975] 	item 20 key (48701440 168 4096) itemoff 2924 itemsize 51
[361464.088152] 		extent refs 1 gen 671 flags 2
[361464.088323] 		tree block key (6307 108 0) level 0
[361464.088496] 		tree block backref root 351
[361464.088669] 	item 21 key (48705536 168 4096) itemoff 2873 itemsize 51
[361464.088849] 		extent refs 1 gen 671 flags 2
[361464.089023] 		tree block key (6314 12 5316) level 0
[361464.089196] 		tree block backref root 351
[361464.089369] 	item 22 key (48709632 168 4096) itemoff 2822 itemsize 51
[361464.089544] 		extent refs 1 gen 671 flags 2
[361464.089721] 		tree block key (6345 108 0) level 0
[361464.089895] 		tree block backref root 351
[361464.090067] 	item 23 key (48713728 168 4096) itemoff 2771 itemsize 51
[361464.090244] 		extent refs 1 gen 671 flags 2
[361464.090416] 		tree block key (6368 1 0) level 0
[361464.090588] 		tree block backref root 351
[361464.090765] 	item 24 key (48717824 168 4096) itemoff 2720 itemsize 51
[361464.090941] 		extent refs 1 gen 671 flags 2
[361464.091113] 		tree block key (6379 1 0) level 0
[361464.091286] 		tree block backref root 351
[361464.091458] 	item 25 key (48721920 168 4096) itemoff 2678 itemsize 42
[361464.091640] 		extent refs 73 gen 18 flags 258
[361464.091817] 		tree block key (10819 1 0) level 1
[361464.091992] 	item 26 key (48721920 176 300) itemoff 2678 itemsize 0
[361464.092167] 		tree block backref
[361464.092338] 	item 27 key (48721920 176 301) itemoff 2678 itemsize 0
[361464.092512] 		tree block backref
[361464.092684] 	item 28 key (48721920 176 302) itemoff 2678 itemsize 0
[361464.092863] 		tree block backref
[361464.093035] 	item 29 key (48721920 176 303) itemoff 2678 itemsize 0
[361464.093211] 		tree block backref
[361464.093381] 	item 30 key (48721920 176 304) itemoff 2678 itemsize 0
[361464.093556] 		tree block backref
[361464.093730] 	item 31 key (48721920 176 305) itemoff 2678 itemsize 0
[361464.093906] 		tree block backref
[361464.094078] 	item 32 key (48721920 176 306) itemoff 2678 itemsize 0
[361464.094249] 		tree block backref
[361464.094417] 	item 33 key (48721920 176 307) itemoff 2678 itemsize 0
[361464.094590] 		tree block backref
[361464.094763] 	item 34 key (48721920 176 308) itemoff 2678 itemsize 0
[361464.094937] 		tree block backref
[361464.095104] 	item 35 key (48721920 176 309) itemoff 2678 itemsize 0
[361464.095277] 		tree block backref
[361464.095445] 	item 36 key (48721920 176 310) itemoff 2678 itemsize 0
[361464.095618] 		tree block backref
[361464.095794] 	item 37 key (48721920 176 311) itemoff 2678 itemsize 0
[361464.095971] 		tree block backref
[361464.096142] 	item 38 key (48721920 176 312) itemoff 2678 itemsize 0
[361464.096318] 		tree block backref
[361464.096489] 	item 39 key (48721920 176 313) itemoff 2678 itemsize 0
[361464.096664] 		tree block backref
[361464.096840] 	item 40 key (48721920 176 314) itemoff 2678 itemsize 0
[361464.097017] 		tree block backref
[361464.097188] 	item 41 key (48721920 176 315) itemoff 2678 itemsize 0
[361464.097364] 		tree block backref
[361464.097534] 	item 42 key (48721920 176 316) itemoff 2678 itemsize 0
[361464.097709] 		tree block backref
[361464.097885] 	item 43 key (48721920 176 317) itemoff 2678 itemsize 0
[361464.098061] 		tree block backref
[361464.098232] 	item 44 key (48721920 176 318) itemoff 2678 itemsize 0
[361464.098408] 		tree block backref
[361464.098577] 	item 45 key (48721920 176 319) itemoff 2678 itemsize 0
[361464.098760] 		tree block backref
[361464.098931] 	item 46 key (48721920 176 320) itemoff 2678 itemsize 0
[361464.099106] 		tree block backref
[361464.099277] 	item 47 key (48721920 176 321) itemoff 2678 itemsize 0
[361464.099452] 		tree block backref
[361464.099623] 	item 48 key (48721920 176 322) itemoff 2678 itemsize 0
[361464.099801] 		tree block backref
[361464.099974] 	item 49 key (48721920 176 323) itemoff 2678 itemsize 0
[361464.100149] 		tree block backref
[361464.100320] 	item 50 key (48721920 176 324) itemoff 2678 itemsize 0
[361464.100495] 		tree block backref
[361464.100665] 	item 51 key (48721920 176 325) itemoff 2678 itemsize 0
[361464.100846] 		tree block backref
[361464.101017] 	item 52 key (48721920 176 326) itemoff 2678 itemsize 0
[361464.101193] 		tree block backref
[361464.101365] 	item 53 key (48721920 176 327) itemoff 2678 itemsize 0
[361464.101540] 		tree block backref
[361464.101711] 	item 54 key (48721920 176 328) itemoff 2678 itemsize 0
[361464.101891] 		tree block backref
[361464.102063] 	item 55 key (48721920 176 329) itemoff 2678 itemsize 0
[361464.102239] 		tree block backref
[361464.102410] 	item 56 key (48721920 176 330) itemoff 2678 itemsize 0
[361464.102585] 		tree block backref
[361464.102761] 	item 57 key (48721920 176 331) itemoff 2678 itemsize 0
[361464.102937] 		tree block backref
[361464.103108] 	item 58 key (48721920 176 332) itemoff 2678 itemsize 0
[361464.103283] 		tree block backref
[361464.106475] 	item 59 key (48721920 176 333) itemoff 2678 itemsize 0
[361464.106652] 		tree block backref
[361464.106828] 	item 60 key (48721920 176 334) itemoff 2678 itemsize 0
[361464.107004] 		tree block backref
[361464.107176] 	item 61 key (48721920 176 335) itemoff 2678 itemsize 0
[361464.107352] 		tree block backref
[361464.107525] 	item 62 key (48721920 176 336) itemoff 2678 itemsize 0
[361464.107705] 		tree block backref
[361464.107885] 	item 63 key (48721920 176 337) itemoff 2678 itemsize 0
[361464.108062] 		tree block backref
[361464.108233] 	item 64 key (48721920 176 338) itemoff 2678 itemsize 0
[361464.108408] 		tree block backref
[361464.108576] 	item 65 key (48721920 176 339) itemoff 2678 itemsize 0
[361464.108752] 		tree block backref
[361464.108923] 	item 66 key (48721920 176 340) itemoff 2678 itemsize 0
[361464.109095] 		tree block backref
[361464.109263] 	item 67 key (48721920 176 341) itemoff 2678 itemsize 0
[361464.109436] 		tree block backref
[361464.109604] 	item 68 key (48721920 176 342) itemoff 2678 itemsize 0
[361464.109781] 		tree block backref
[361464.109950] 	item 69 key (48721920 176 343) itemoff 2678 itemsize 0
[361464.110125] 		tree block backref
[361464.110295] 	item 70 key (48721920 176 344) itemoff 2678 itemsize 0
[361464.110470] 		tree block backref
[361464.110641] 	item 71 key (48721920 176 345) itemoff 2678 itemsize 0
[361464.110819] 		tree block backref
[361464.110991] 	item 72 key (48721920 176 346) itemoff 2678 itemsize 0
[361464.111167] 		tree block backref
[361464.111337] 	item 73 key (48721920 176 347) itemoff 2678 itemsize 0
[361464.111512] 		tree block backref
[361464.111683] 	item 74 key (48721920 176 348) itemoff 2678 itemsize 0
[361464.111863] 		tree block backref
[361464.112036] 	item 75 key (48721920 176 349) itemoff 2678 itemsize 0
[361464.112212] 		tree block backref
[361464.112382] 	item 76 key (48721920 176 350) itemoff 2678 itemsize 0
[361464.112557] 		tree block backref
[361464.112735] 	item 77 key (48721920 176 351) itemoff 2678 itemsize 0
[361464.112911] 		tree block backref
[361464.113082] 	item 78 key (48721920 176 352) itemoff 2678 itemsize 0
[361464.113257] 		tree block backref
[361464.113427] 	item 79 key (48721920 176 353) itemoff 2678 itemsize 0
[361464.113602] 		tree block backref
[361464.113777] 	item 80 key (48721920 176 354) itemoff 2678 itemsize 0
[361464.113955] 		tree block backref
[361464.114125] 	item 81 key (48721920 176 355) itemoff 2678 itemsize 0
[361464.114301] 		tree block backref
[361464.114471] 	item 82 key (48721920 176 356) itemoff 2678 itemsize 0
[361464.114646] 		tree block backref
[361464.114822] 	item 83 key (48721920 176 357) itemoff 2678 itemsize 0
[361464.114999] 		tree block backref
[361464.115170] 	item 84 key (48721920 176 358) itemoff 2678 itemsize 0
[361464.115345] 		tree block backref
[361464.115515] 	item 85 key (48721920 176 359) itemoff 2678 itemsize 0
[361464.115690] 		tree block backref
[361464.115865] 	item 86 key (48721920 176 360) itemoff 2678 itemsize 0
[361464.116041] 		tree block backref
[361464.116211] 	item 87 key (48721920 176 361) itemoff 2678 itemsize 0
[361464.116386] 		tree block backref
[361464.116558] 	item 88 key (48721920 176 362) itemoff 2678 itemsize 0
[361464.116738] 		tree block backref
[361464.116912] 	item 89 key (48721920 176 363) itemoff 2678 itemsize 0
[361464.117090] 		tree block backref
[361464.117266] 	item 90 key (48721920 176 364) itemoff 2678 itemsize 0
[361464.117441] 		tree block backref
[361464.117619] 	item 91 key (48721920 176 365) itemoff 2678 itemsize 0
[361464.117799] 		tree block backref
[361464.117970] 	item 92 key (48721920 176 366) itemoff 2678 itemsize 0
[361464.118145] 		tree block backref
[361464.118315] 	item 93 key (48721920 176 367) itemoff 2678 itemsize 0
[361464.118490] 		tree block backref
[361464.118660] 	item 94 key (48721920 176 368) itemoff 2678 itemsize 0
[361464.118840] 		tree block backref
[361464.119012] 	item 95 key (48721920 176 369) itemoff 2678 itemsize 0
[361464.119187] 		tree block backref
[361464.119357] 	item 96 key (48721920 176 370) itemoff 2678 itemsize 0
[361464.119532] 		tree block backref
[361464.119703] 	item 97 key (48721920 176 371) itemoff 2678 itemsize 0
[361464.119888] 		tree block backref
[361464.120059] 	item 98 key (48721920 176 372) itemoff 2678 itemsize 0
[361464.120235] 		tree block backref
[361464.120405] 	item 99 key (48726016 168 4096) itemoff 2618 itemsize 60
[361464.120580] 		extent refs 2 gen 18 flags 258
[361464.120759] 		tree block key (11022 108 106496) level 0
[361464.120934] 		tree block backref root 373
[361464.121106] 		shared block backref parent 48721920
[361464.121279] 	item 100 key (48738304 168 4096) itemoff 2567 itemsize 51
[361464.121455] 		extent refs 1 gen 18 flags 2
[361464.121628] 		tree block key (18446744073709551606 128 1441959936) level 0
[361464.121809] 		tree block backref root 7
[361464.121983] BTRFS error (device loop168): unable to find ref byte nr 48721920 parent 0 root 299  owner 1 offset 0

Followed by : 

[361464.122468] WARNING: CPU: 6 PID: 7637 at fs/btrfs/extent-tree.c:6549 __btrfs_free_extent.isra.66+0x6c8/0xcb0 [btrfs]()
[361464.122775] BTRFS: Transaction aborted (error -2)
[361464.126782] CPU: 6 PID: 7637 Comm: btrfs-cleaner Tainted: P        W  O    4.4.22-clouder1 #12
[361464.127080] Hardware name: Supermicro X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
[361464.127378]  0000000000000000 ffff880486e03ab0 ffffffff812f4999 ffff880486e03af8
[361464.127866]  ffffffffa09e6fda ffff880486e03ae8 ffffffff81052bd6 00000000fffffffe
[361464.128354]  0000000002e77000 ffff8805d4a30750 ffff88000513e000 0000000000000000
[361464.128852] Call Trace:
[361464.129026]  [<ffffffff812f4999>] dump_stack+0x67/0x9e
[361464.129201]  [<ffffffff81052bd6>] warn_slowpath_common+0x86/0xc0
[361464.129378]  [<ffffffff81052c5c>] warn_slowpath_fmt+0x4c/0x50
[361464.129567]  [<ffffffffa094cdc8>] __btrfs_free_extent.isra.66+0x6c8/0xcb0 [btrfs]
[361464.129875]  [<ffffffffa093ec2f>] ? btrfs_set_path_blocking+0x3f/0x70 [btrfs]
[361464.130184]  [<ffffffffa0950bf8>] __btrfs_run_delayed_refs+0x898/0x12c0 [btrfs]
[361464.130493]  [<ffffffffa09b42e8>] ? btrfs_add_delayed_extent_op+0x98/0xc0 [btrfs]
[361464.130800]  [<ffffffffa094e845>] ? btrfs_set_disk_extent_flags+0x85/0xc0 [btrfs]
[361464.131107]  [<ffffffffa0954382>] btrfs_run_delayed_refs+0x82/0x2f0 [btrfs]
[361464.131300]  [<ffffffffa098c32b>] ? free_extent_buffer+0x4b/0x90 [btrfs]
[361464.131491]  [<ffffffffa0968aa9>] btrfs_should_end_transaction+0x59/0x60 [btrfs]
[361464.131797]  [<ffffffffa0952ba6>] btrfs_drop_snapshot+0x436/0x800 [btrfs]
[361464.131987]  [<ffffffffa0968f83>] btrfs_clean_one_deleted_snapshot+0xb3/0xf0 [btrfs]
[361464.132295]  [<ffffffffa0960e82>] cleaner_kthread+0x1e2/0x280 [btrfs]
[361464.132483]  [<ffffffffa0960ca0>] ? check_leaf+0x340/0x340 [btrfs]
[361464.132661]  [<ffffffff8107174f>] kthread+0xef/0x110
[361464.132839]  [<ffffffff81071660>] ? kthread_park+0x60/0x60
[361464.133025]  [<ffffffff8161547f>] ret_from_fork+0x3f/0x70
[361464.133202]  [<ffffffff81071660>] ? kthread_park+0x60/0x60
[361464.133391] ---[ end trace 03d80b3e257b8baf ]---
[361464.133569] BTRFS: error (device loop168) in __btrfs_free_extent:6549: errno=-2 No such entry
[361464.133869] BTRFS info (device loop168): forced readonly
[361464.134047] BTRFS: error (device loop168) in btrfs_run_delayed_refs:2927: errno=-2 No such entry
[361465.644848] BTRFS error (device loop168): cleaner transaction attach returned -30


So if I understood it correctly while freeing the extents the code tried to 
find all the back references, however it couldn't. Does this mean the consistency of 
this particular file is broken? How can such situations arise/be prevented?
