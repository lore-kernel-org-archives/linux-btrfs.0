Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:53995 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3AKXvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 18:51:41 -0500
Date: Fri, 11 Jan 2013 15:34:15 -0800
From: Simon Kirby <sim@hostway.ca>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>
Subject: [3.8-rc2] Balance causes kernel BUG at fs/btrfs/inode.c:3910
Message-ID: <20130111233415.GC21978@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

A few kernel versions back, we set up a 5 disk volume which was set up as
"raid 1" data. This didn't quite go as expected, and it filled up the
first 4 disks without putting anything on the 5th. I've been trying to
balance it, lastly with: btrfs balance start -v -dconvert=single,devid=5

I attempted this while an rsync was running to it, and got:

[27242.914823] btrfs: relocating block group 9295936356352 flags 9
[27250.045926] ------------[ cut here ]------------
[27250.045974] kernel BUG at fs/btrfs/inode.c:3910!
[27250.046004] invalid opcode: 0000 [#1] SMP 
[27250.046036] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2 serio_raw microcode evdev
[27250.047582] CPU 2 
[27250.047595] Pid: 6311, comm: rsync Not tainted 3.8.0-rc2-hw+ #19 Dell Inc. PowerEdge 2950/0NH278
[27250.047660] RIP: 0010:[<ffffffff8133c340>]  [<ffffffff8133c340>] btrfs_evict_inode+0x330/0x350  
[27250.047720] RSP: 0018:ffff880296bdfcb8  EFLAGS: 00010286
[27250.047748] RAX: 00000000ffffffe4 RBX: ffff88041a2bb2f8 RCX: 00000000ffffffe4
[27250.047779] RDX: 000000000000003f RSI: 0000000000000000 RDI: ffff880033ea65e8
[27250.047810] RBP: ffff880296bdfcf8 R08: ffff88042c5061b0 R09: 00000000000195d0
[27250.047841] R10: ffff880110460e10 R11: 000000036ac78000 R12: 00000000ffffffe4
[27250.047872] R13: ffff8803fe926800 R14: ffff880203becb60 R15: ffff880189eb34c0
[27250.047904] FS:  00007f8a205fb700(0000) GS:ffff88043fc80000(0000) knlGS:0000000000000000
[27250.047951] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[27250.047979] CR2: 0000000006f00fe0 CR3: 0000000247d94000 CR4: 00000000000007e0
[27250.048011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[27250.048059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[27250.048095] Process rsync (pid: 6311, threadinfo ffff880296bde000, task ffff880416dfd9c0)
[27250.048146] Stack:
[27250.048168]  ffff88042c506130 0000000000008000 00001000817ccac0 ffff880203becb60
[27250.048227]  ffff880203becc50 ffffffff817ccac0 ffff8804239a4c00 ffff88017f980000
[27250.048282]  ffff880296bdfd28 ffffffff811473be ffff880296bdfd28 ffff880203becb60
[27250.048339] Call Trace:
[27250.048369]  [<ffffffff811473be>] evict+0xae/0x1b0
[27250.048399]  [<ffffffff811475b3>] iput+0xf3/0x180 
[27250.048428]  [<ffffffff81144658>] d_kill+0xf8/0x140
[27250.048457]  [<ffffffff81144df2>] dput+0xe2/0x1b0  
[27250.048487]  [<ffffffff8113d4d8>] sys_renameat+0x318/0x330
[27250.048519]  [<ffffffff8112ffed>] ? __sb_end_write+0x2d/0x60
[27250.048552]  [<ffffffff8114e6fa>] ? mnt_drop_write+0x1a/0x20
[27250.048582]  [<ffffffff8112cee5>] ? chmod_common+0x85/0xa0  
[27250.048612]  [<ffffffff8114c69c>] ? mntput_no_expire+0x4c/0x1b0
[27250.048643]  [<ffffffff8114c81c>] ? mntput+0x1c/0x30
[27250.048673]  [<ffffffff81137e4d>] ? path_put+0x1d/0x30
[27250.048702]  [<ffffffff8112cf52>] ? sys_fchmodat+0x52/0xc0
[27250.048732]  [<ffffffff8113d506>] sys_rename+0x16/0x20
[27250.048764]  [<ffffffff81787a69>] system_call_fastpath+0x16/0x1b
[27250.048793] Code: ef e8 b5 b0 fe ff e9 e0 fd ff ff 49 8b 85 50 04 00 00 4c 89 f6 48 89 df 48 89 43 40 e8 fa fb ff ff 85 c0 74 88 0f 0b eb fe 66 90 <0f> 0b eb fe 0f 1f 40 00 49
[27250.049049] RIP  [<ffffffff8133c340>] btrfs_evict_inode+0x330/0x350
[27250.049082]  RSP <ffff880296bdfcb8>
[27250.051056] ---[ end trace f00bde3453928d92 ]---

Later, we saw this, but I don't know if it's related:

Jan 10 20:10:01 backup02 kernel: [31364.993804] btrfs: csum mismatch on free space cache  
Jan 10 20:10:01 backup02 kernel: [31364.993869] btrfs: failed to load free space cache for block group 29360128
Jan 10 20:10:07 backup02 kernel: [31370.023364] btrfs: csum mismatch on free space cache
Jan 10 20:10:07 backup02 kernel: [31370.023419] btrfs: failed to load free space cache for block group 1793178206208
Jan 10 20:10:07 backup02 kernel: [31370.083269] btrfs: csum mismatch on free space cache
Jan 10 20:10:07 backup02 kernel: [31370.083374] btrfs: failed to load free space cache for block group 2221601193984
Jan 10 20:10:10 backup02 kernel: [31373.680461] btrfs: csum mismatch on free space cache
Jan 10 20:10:10 backup02 kernel: [31373.680513] btrfs: failed to load free space cache for block group 3657194012672
Jan 10 20:10:10 backup02 kernel: [31373.766913] btrfs: csum mismatch on free space cache
Jan 10 20:10:10 backup02 kernel: [31373.766963] btrfs: failed to load free space cache for block group 3659341496320
Jan 10 20:10:10 backup02 kernel: [31373.851741] btrfs: csum mismatch on free space cache
Jan 10 20:10:10 backup02 kernel: [31373.851799] btrfs: failed to load free space cache for block group 4190843699200
Jan 10 20:10:18 backup02 kernel: [31381.498276] btrfs: csum mismatch on free space cache
Jan 10 20:10:18 backup02 kernel: [31381.498329] btrfs: failed to load free space cache for block group 2223748677632
Jan 10 20:10:19 backup02 kernel: [31382.208026] btrfs: csum mismatch on free space cache
Jan 10 20:10:19 backup02 kernel: [31382.208096] btrfs: failed to load free space cache for block group 2228043644928
Jan 10 20:10:19 backup02 kernel: [31382.335050] btrfs: csum mismatch on free space cache
Jan 10 20:10:19 backup02 kernel: [31382.335104] btrfs: failed to load free space cache for block group 3164346515456
Jan 10 20:14:04 backup02 kernel: [31607.826017] btrfs: csum mismatch on free space cache
Jan 10 20:14:04 backup02 kernel: [31607.826130] btrfs: failed to load free space cache for block group 2224822419456
Jan 10 20:16:01 backup02 kernel: [31724.422885] btrfs: csum mismatch on free space cache
Jan 10 20:16:01 backup02 kernel: [31724.422934] btrfs: failed to load free space cache for block group 1121015824384
Jan 10 20:16:12 backup02 kernel: [31735.189689] btrfs: csum mismatch on free space cache
Jan 10 20:16:12 backup02 kernel: [31735.189765] btrfs: failed to load free space cache for block group 2094899658752
Jan 10 22:10:12 backup02 kernel: [38575.610711] btrfs: csum mismatch on free space cache
Jan 10 22:10:12 backup02 kernel: [38575.610782] btrfs: failed to load free space cache for block group 42979033088
Jan 10 22:10:12 backup02 kernel: [38575.711735] btrfs: csum mismatch on free space cache
Jan 10 22:10:12 backup02 kernel: [38575.711786] btrfs: failed to load free space cache for block group 47274000384
Jan 10 22:10:19 backup02 kernel: [38582.136800] btrfs: csum mismatch on free space cache
Jan 10 22:10:19 backup02 kernel: [38582.136907] btrfs: failed to load free space cache for block group 25799163904
Jan 10 22:10:19 backup02 kernel: [38582.190511] btrfs: csum mismatch on free space cache
Jan 10 22:10:19 backup02 kernel: [38582.190561] btrfs: failed to load free space cache for block group 26872905728
Jan 10 22:14:32 backup02 kernel: [38835.536099] btrfs: csum mismatch on free space cache
Jan 10 22:14:32 backup02 kernel: [38835.536193] btrfs: failed to load free space cache for block group 12914262016
Jan 10 22:25:41 backup02 kernel: [39504.670265] btrfs: csum mismatch on free space cache
Jan 10 22:25:41 backup02 kernel: [39504.670316] btrfs: failed to load free space cache for block group 17209229312

We rebooted into -rc3 (with clear_cache,nospace_cache) and got:

[  205.260282] device fsid f7445508-ab20-4f6a-9263-6e32b1994868 devid 4 transid 3200231 /dev/sdf
[  205.261500] btrfs: force zlib compression
[  205.261586] btrfs: turning off barriers
[  205.261660] btrfs: force clearing of disk cache
[  205.261735] btrfs: disabling disk space caching
[  232.792291] btrfs: unlinked 1 orphans
[  232.802587] btrfs: continuing balance
[  391.172274] btrfs: relocating block group 9295936356352 flags 9
[  457.911448] btrfs: relocating block group 9280907640832 flags 9
[  506.438194] btrfs: relocating block group 9273391972352 flags 9
[  545.061485] btrfs: relocating block group 9266949783552 flags 9
[  545.173398] btrfs: relocating block group 9261581074432 flags 9
[  545.295324] btrfs: relocating block group 9256212365312 flags 9
[  545.386958] btrfs: relocating block group 9250910502912 flags 9
[  545.512581] btrfs: relocating block group 9249690484736 flags 9
[  545.631416] btrfs: relocating block group 9248550158336 flags 9
[  545.775922] btrfs: relocating block group 9238801022976 flags 9
[  545.874302] btrfs: relocating block group 9233432313856 flags 9
[  545.962241] btrfs: relocating block group 9228063604736 flags 9
[  546.038325] btrfs: relocating block group 9222694895616 flags 9
[  546.114166] btrfs: relocating block group 9217326186496 flags 9
[  546.186333] btrfs: relocating block group 9211957477376 flags 9
[  546.282473] btrfs: relocating block group 9206588768256 flags 9
[  546.374569] btrfs: relocating block group 9201220059136 flags 9
[  546.454295] btrfs: relocating block group 9195851350016 flags 9
[  546.530740] btrfs: relocating block group 9190482640896 flags 9
[  546.606845] btrfs: relocating block group 9185113931776 flags 9
[  546.674652] btrfs: relocating block group 9179745222656 flags 9
[  546.758579] btrfs: relocating block group 9174376513536 flags 9
[  546.842813] btrfs: relocating block group 9169007804416 flags 9
[  546.922430] btrfs: relocating block group 9163639095296 flags 9
[  547.002448] btrfs: relocating block group 9158270386176 flags 9
[  547.070515] btrfs: relocating block group 9152901677056 flags 9
[  547.142384] btrfs: relocating block group 9147532967936 flags 9
[  547.210282] btrfs: relocating block group 9142164258816 flags 9
[  547.274267] btrfs: relocating block group 9136795549696 flags 9
[  547.338134] btrfs: relocating block group 9131426840576 flags 9
[  547.402242] btrfs: relocating block group 9126058131456 flags 9
[  547.462451] btrfs: relocating block group 9120689422336 flags 9
[  547.518312] btrfs: relocating block group 9115320713216 flags 9
[  547.578427] btrfs: relocating block group 9109952004096 flags 9
[  547.631203] btrfs: relocating block group 9104583294976 flags 9
[  547.682953] btrfs: relocating block group 9099214585856 flags 9
[  547.735076] btrfs: relocating block group 9093845876736 flags 9
[  547.786936] btrfs: relocating block group 9088477167616 flags 9
[  547.839922] btrfs: relocating block group 9083108458496 flags 9
[  547.907136] btrfs: relocating block group 9077739749376 flags 9
[  547.977250] btrfs: relocating block group 9072371040256 flags 9
[  548.037483] btrfs: relocating block group 9067002331136 flags 9
[  548.104039] btrfs: relocating block group 9061633622016 flags 9
[  548.161051] btrfs: relocating block group 9056264912896 flags 9
[  548.221951] btrfs: relocating block group 9050896203776 flags 9
[  548.279324] btrfs: relocating block group 9045527494656 flags 9
[  548.331836] btrfs: relocating block group 9040158785536 flags 9
[  548.383628] btrfs: relocating block group 9034790076416 flags 9
[  548.435333] btrfs: relocating block group 9029421367296 flags 9
[  548.497361] btrfs: relocating block group 9024052658176 flags 9
[  548.602576] btrfs: relocating block group 9018683949056 flags 9
[  548.686341] btrfs: relocating block group 9013315239936 flags 9
[  548.743393] btrfs: relocating block group 9007946530816 flags 9
[  548.795117] btrfs: relocating block group 9002577821696 flags 9
[  548.847219] btrfs: relocating block group 8997209112576 flags 9
[  548.899698] btrfs: relocating block group 8991840403456 flags 9
[  548.951469] btrfs: relocating block group 8986471694336 flags 9
[  549.007847] btrfs: relocating block group 8981102985216 flags 9
[  549.070503] btrfs: relocating block group 8975734276096 flags 9
[  549.123428] btrfs: relocating block group 8970365566976 flags 9
[  549.190508] btrfs: relocating block group 8964996857856 flags 9
[  549.270248] btrfs: relocating block group 8959628148736 flags 9
[  549.338408] btrfs: relocating block group 8954259439616 flags 9
[ 1311.112035] btrfs: found 10170 extents
[ 1355.497821] btrfs: found 10170 extents
[ 1355.847775] btrfs: relocating block group 8948890730496 flags 9
[ 1395.033420] btrfs: found 11438 extents
[ 1440.443443] btrfs: found 11438 extents
[ 1442.626599] btrfs: relocating block group 8943522021376 flags 9
[ 1499.734449] btrfs: found 10534 extents
[ 1529.311973] btrfs: found 10534 extents
[ 1529.665777] btrfs: relocating block group 8938153312256 flags 9
[ 1563.289253] btrfs: found 10913 extents
[ 1597.124530] btrfs: found 10913 extents
[ 1597.658411] btrfs: relocating block group 8932784603136 flags 9
[ 1601.584768] btrfs: found 1726 extents
[ 1618.566932] btrfs: found 1726 extents
[ 1621.015263] btrfs: relocating block group 8927415894016 flags 9
[ 1623.032222] btrfs: found 1161 extents
[ 1634.693731] btrfs: found 1161 extents
[ 1635.291280] btrfs: relocating block group 8922047184896 flags 9
[ 1635.538957] btrfs: found 84 extents
[ 1643.407973] btrfs: found 84 extents
[ 1644.131770] btrfs: relocating block group 8916678475776 flags 9
[ 1644.355772] btrfs: found 60 extents
[ 1646.032672] btrfs: found 60 extents
[ 1646.090770] btrfs: relocating block group 8911309766656 flags 9
[ 1646.148088] btrfs: relocating block group 8905941057536 flags 9
[ 1646.195711] btrfs: relocating block group 8900572348416 flags 9
[ 1646.241512] btrfs: relocating block group 8895203639296 flags 9
[ 1646.291594] btrfs: relocating block group 8889834930176 flags 9
[ 1646.335944] btrfs: relocating block group 8884466221056 flags 9
[ 1646.379730] btrfs: relocating block group 8879097511936 flags 9
[ 1646.423912] btrfs: relocating block group 8873728802816 flags 9
[ 1646.668414] btrfs: found 17 extents
[ 1649.335731] btrfs: found 17 extents
[ 1649.387661] btrfs: relocating block group 8868360093696 flags 9
[ 1650.339956] btrfs: found 23 extents
[ 1654.198232] btrfs: found 23 extents
[ 1655.345804] btrfs: relocating block group 8862991384576 flags 9
[ 1661.025050] btrfs: found 2148 extents
[ 1679.950073] btrfs: found 2148 extents
[ 1681.498377] btrfs: relocating block group 8857622675456 flags 9
[ 1694.185999] btrfs: found 4559 extents
[ 1728.446297] btrfs: found 4559 extents
[ 1730.270891] btrfs: relocating block group 8852253966336 flags 9
[ 1788.470043] btrfs: found 15261 extents
[ 1829.016229] btrfs: found 15261 extents
[ 1830.902657] btrfs: relocating block group 8846885257216 flags 9
[ 1905.655307] btrfs: found 12836 extents
[ 1924.331317] btrfs: found 12836 extents
[ 1925.468659] btrfs: relocating block group 8841516548096 flags 9
[ 2000.768460] btrfs: found 11956 extents
[ 2043.696458] btrfs: found 11956 extents
[ 2046.314469] btrfs: relocating block group 8836147838976 flags 9
[ 2111.486063] btrfs: found 10228 extents
[ 2144.165416] btrfs: found 10228 extents
[ 2144.674914] btrfs: relocating block group 8830779129856 flags 9
[ 2212.029031] btrfs: found 10176 extents
[ 2234.676308] btrfs: found 10176 extents
[ 2235.038829] btrfs: relocating block group 8825410420736 flags 9
[ 2245.513075] btrfs: found 2474 extents
[ 2269.118855] btrfs: found 2474 extents
[ 2269.636899] btrfs: relocating block group 8820041711616 flags 9
[ 2286.619271] btrfs: found 5295 extents
[ 2319.163984] btrfs: found 5295 extents
[ 2320.931411] btrfs: relocating block group 8814673002496 flags 9
[ 2376.136123] btrfs: found 8296 extents
[ 2416.031165] btrfs: found 8296 extents
[ 2419.364675] btrfs: relocating block group 8809304293376 flags 9
[ 2433.650630] btrfs: found 3385 extents
[ 2469.157127] btrfs: found 3385 extents
[ 2470.927189] btrfs: relocating block group 8803935584256 flags 9
[ 2474.436637] btrfs: found 882 extents
[ 2499.218063] btrfs: found 882 extents
[ 2501.412537] btrfs: relocating block group 8798566875136 flags 9
[ 2502.829683] btrfs: found 436 extents
[ 2509.713254] btrfs: found 436 extents
[ 2509.763300] btrfs: relocating block group 8338707578880 flags 9
[ 2519.513355] btrfs: found 4022 extents
[ 2606.805289] btrfs: found 4022 extents
[ 2616.933213] ------------[ cut here ]------------
[ 2616.933259] kernel BUG at fs/btrfs/inode.c:3910!
[ 2616.933287] invalid opcode: 0000 [#1] SMP 
[ 2616.933318] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe microcode evdev serio_raw bnx2
[ 2616.933393] CPU 7 
[ 2616.933403] Pid: 4424, comm: perl Not tainted 3.8.0-rc3-hw+ #21 Dell Inc. PowerEdge 2950/0NH278
[ 2616.933468] RIP: 0010:[<ffffffff813278a0>]  [<ffffffff813278a0>] btrfs_evict_inode+0x300/0x340
[ 2616.933529] RSP: 0018:ffff8803f8e41a68  EFLAGS: 00010286
[ 2616.933557] RAX: 00000000ffffffe4 RBX: ffff8802dabb7000 RCX: 0000000000018000
[ 2616.933587] RDX: 0000000000000016 RSI: ffff88023b99a000 RDI: ffff88023b99a048
[ 2616.933618] RBP: ffff8803f8e41aa8 R08: ffff88042c4ba1b0 R09: ffff88043fdd94d0
[ 2616.933649] R10: 6c00000000004e48 R11: 00000003615d8000 R12: ffff88023b9a85a0
[ 2616.933680] R13: ffff88042a03ea60 R14: 0000000000008000 R15: ffff8804150368e8
[ 2616.933712] FS:  00007fb253ac8700(0000) GS:ffff88043fdc0000(0000) knlGS:0000000000000000
[ 2616.933758] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2616.933786] CR2: 00007fc2a921a4f8 CR3: 00000003f2f35000 CR4: 00000000000007e0
[ 2616.933818] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2616.933849] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2616.933880] Process perl (pid: 4424, threadinfo ffff8803f8e40000, task ffff880427071670)
[ 2616.933926] Stack:
[ 2616.933948]  ffff8803f8e41a88 ffff88042c4ba130 ffff88023b9a8690 ffff88023b9a85a0
[ 2616.934005]  ffff88023b9a8690 ffffffff817a6900 ffffffff817a6900 0000000000000000
[ 2616.934061]  ffff8803f8e41ad8 ffffffff8113d5ca 00000000f8e41ad8 ffff88023b9a85a0
[ 2616.934116] Call Trace:
[ 2616.934148]  [<ffffffff8113d5ca>] evict+0xaa/0x1a0
[ 2616.934177]  [<ffffffff8113dd33>] iput+0x103/0x1a0
[ 2616.934207]  [<ffffffff81328188>] btrfs_orphan_cleanup+0x1a8/0x3f0
[ 2616.934239]  [<ffffffff81328710>] btrfs_lookup_dentry+0x340/0x4b0
[ 2616.934270]  [<ffffffff81328891>] btrfs_lookup+0x11/0x30
[ 2616.934301]  [<ffffffff8112e988>] lookup_real+0x18/0x50
[ 2616.934330]  [<ffffffff8112f0c3>] __lookup_hash+0x33/0x40
[ 2616.934360]  [<ffffffff8112f8f9>] lookup_slow+0x49/0xc0
[ 2616.934389]  [<ffffffff81131876>] path_lookupat+0x716/0x770
[ 2616.934419]  [<ffffffff8112fcd1>] ? final_putname+0x21/0x50
[ 2616.934450]  [<ffffffff811318fe>] filename_lookup.isra.50+0x2e/0x80
[ 2616.934481]  [<ffffffff81133c88>] user_path_at_empty+0x58/0xa0
[ 2616.934512]  [<ffffffff811419f4>] ? mntput_no_expire+0x44/0x160
[ 2616.934545]  [<ffffffff81129cdc>] ? cp_new_stat+0x10c/0x120
[ 2616.934575]  [<ffffffff81133cdc>] user_path_at+0xc/0x10
[ 2616.934604]  [<ffffffff81129eea>] vfs_fstatat+0x4a/0xb0
[ 2616.934634]  [<ffffffff81129f69>] vfs_lstat+0x19/0x20
[ 2616.934663]  [<ffffffff8112a0d5>] sys_newlstat+0x15/0x30
[ 2616.934697]  [<ffffffff8175d1d1>] ? do_device_not_available+0x11/0x20
[ 2616.934730]  [<ffffffff81764f8e>] ? device_not_available+0x1e/0x30
[ 2616.934761]  [<ffffffff81763ea9>] system_call_fastpath+0x16/0x1b
[ 2616.934790] Code: 49 8b 74 24 38 eb d9 48 8b 83 50 04 00 00 4c 89 e6 4c 89 ff 49 89 47 40 e8 9e af ff ff 85 c0 0f 84 7b ff ff ff 0f 0b 0f 1f 40 00 <0f> 0b 4c 8b 2d 17 bd 7b 00 4d 85 ed 0f 84 25 fd ff ff 49 8b 45 
[ 2616.935041] RIP  [<ffffffff813278a0>] btrfs_evict_inode+0x300/0x340
[ 2616.935074]  RSP <ffff8803f8e41a68>
[ 2616.935477] ---[ end trace 43b89b520e422103 ]---

For reference:

# btrfs scrub status /backup/bu003/vol00
scrub status for f7445508-ab20-4f6a-9263-6e32b1994868
        scrub started at Thu Jan 10 13:20:04 2013 and finished after 15958 seconds
        total bytes scrubbed: 4.55TB with 0 errors

# btrfs fi show /dev/sdf
failed to read /dev/sr0
Label: none  uuid: f7445508-ab20-4f6a-9263-6e32b1994868
        Total devices 5 FS bytes used 4.55TB
        devid    4 size 1.82TB used 1.82TB path /dev/sdf
        devid    3 size 1.82TB used 1.82TB path /dev/sde
        devid    2 size 1.82TB used 1.82TB path /dev/sdd
        devid    5 size 1.71TB used 599.91GB path /dev/sdb
        devid    1 size 1.82TB used 1.82TB path /dev/sdc

# btrfs fi df /backup/bu003/vol00
Data, RAID0: total=7.23TB, used=4.51TB
Data: total=463.52GB, used=0.00
System, RAID0: total=79.75MB, used=452.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=12.00GB, used=9.78GB
Metadata, RAID0: total=155.99GB, used=25.07GB
Metadata: total=8.00MB, used=0.00

There are a mix of things from previous balance attempts that were going
for more than a month. Prior to the balance, a scrub passed everything.

It seems that in both bug cases, RAX is 0x00000000ffffffe4, which is -28
(ENOSPC). The ENOSPC check above was last changed by Josef in ca7e70f5 and Miao
added the btrfs_update_inode() and BUG_ON() shortly after in 8407aa46.

I suppose the assumption is that btrfs_update_inode() should never fail
here?

An "ls" in a directory on the volume now hangs in D and R state:

# cat /proc/5377/stack
[<ffffffff812fa272>] read_block_for_search.isra.47+0x92/0x400
[<ffffffff812fcf4a>] btrfs_search_old_slot+0x2da/0x8e0
[<ffffffff812ffef7>] btrfs_next_old_leaf+0xe7/0x470
[<ffffffff8136fdc0>] __resolve_indirect_refs+0x2e0/0x610
[<ffffffff81370997>] find_parent_nodes+0x4e7/0x900
[<ffffffff81370e41>] btrfs_find_all_roots+0x91/0x100
[<ffffffff81373c63>] btrfs_qgroup_account_ref+0xf3/0x590
[<ffffffff81305fcb>] btrfs_delayed_refs_qgroup_accounting+0x9b/0xf0
[<ffffffff8131ce20>] __btrfs_end_transaction+0x70/0x3f0
[<ffffffff8131d1cb>] btrfs_end_transaction+0xb/0x10
[<ffffffff81327796>] btrfs_evict_inode+0x1f6/0x340
[<ffffffff8113d5ca>] evict+0xaa/0x1a0
[<ffffffff8113dd33>] iput+0x103/0x1a0
[<ffffffff81328188>] btrfs_orphan_cleanup+0x1a8/0x3f0
[<ffffffff81328710>] btrfs_lookup_dentry+0x340/0x4b0
[<ffffffff81328891>] btrfs_lookup+0x11/0x30
[<ffffffff8112e988>] lookup_real+0x18/0x50
[<ffffffff8112f0c3>] __lookup_hash+0x33/0x40
[<ffffffff8112f8f9>] lookup_slow+0x49/0xc0
[<ffffffff81131876>] path_lookupat+0x716/0x770
[<ffffffff811318fe>] filename_lookup.isra.50+0x2e/0x80
[<ffffffff81133c88>] user_path_at_empty+0x58/0xa0
[<ffffffff81133cdc>] user_path_at+0xc/0x10
[<ffffffff81129eea>] vfs_fstatat+0x4a/0xb0
[<ffffffff81129f69>] vfs_lstat+0x19/0x20
[<ffffffff8112a0d5>] sys_newlstat+0x15/0x30
[<ffffffff81763ea9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

Simon-
