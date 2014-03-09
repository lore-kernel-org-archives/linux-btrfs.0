Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46403 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaCIMXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 08:23:39 -0400
Received: from merkaba.localnet (ppp-88-217-103-5.dynamic.mnet-online.de [88.217.103.5])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 55284B8
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 13:21:54 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Shrinking btrfs filesystem: btrfs command blocked for more than 120 seconds.
Date: Sun, 09 Mar 2014 13:23:37 +0100
Message-ID: <1490883.bG2ACygJ19@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On 3.14.0-rc4-tp520 (compiled with gcc 4.8.2) shrinking my /home from about
260 GiB to 150 GiB resulted in a BTRFS hang.

First it relocated block groups, but then on one the btrfs command was
blocked for more than 120 seconds.

A second attempt after a reboot quickly had the same result.

I didn´t to a scrub afterwards, but I migrated data with rsync without any
I/O error, so I bet the data has still been intact and it just hung.

I don´t have that BTRFS filesystem anymore as I completed the migration to
BTRFS RAID 1 by rsync´ing data to a new BTRFS volume and rebalancing from
there.

But maybe the following kern.log contents give some hint.

I think I also have a kern.log of the second attempt.


Mar  5 14:36:04 merkaba kernel: [30307.186077] BTRFS: new size for /dev/dm-1 is 161061273600
Mar  5 14:36:04 merkaba kernel: [30307.193279] BTRFS info (device dm-1): relocating block group 281865617408 flags 1
Mar  5 14:36:12 merkaba kernel: [30315.165879] BTRFS info (device dm-1): found 16730 extents
Mar  5 14:36:30 merkaba kernel: [30333.660543] BTRFS info (device dm-1): found 16730 extents
Mar  5 14:36:31 merkaba kernel: [30333.884331] BTRFS info (device dm-1): relocating block group 280791875584 flags 1
Mar  5 14:36:49 merkaba kernel: [30352.496390] BTRFS info (device dm-1): found 38538 extents
Mar  5 14:37:03 merkaba kernel: [30366.639983] BTRFS info (device dm-1): found 38538 extents
Mar  5 14:37:04 merkaba kernel: [30366.970321] BTRFS info (device dm-1): relocating block group 279718133760 flags 1
Mar  5 14:37:20 merkaba kernel: [30383.535441] BTRFS info (device dm-1): found 32617 extents
Mar  5 14:37:32 merkaba kernel: [30395.438551] BTRFS info (device dm-1): found 32617 extents
Mar  5 14:37:32 merkaba kernel: [30395.742040] BTRFS info (device dm-1): relocating block group 278644391936 flags 1
Mar  5 14:37:50 merkaba kernel: [30412.906795] BTRFS info (device dm-1): found 33075 extents
Mar  5 14:38:02 merkaba kernel: [30424.958759] BTRFS info (device dm-1): found 33075 extents
Mar  5 14:38:02 merkaba kernel: [30425.262850] BTRFS info (device dm-1): relocating block group 277570650112 flags 1
Mar  5 14:38:19 merkaba kernel: [30442.288674] BTRFS info (device dm-1): found 36760 extents
Mar  5 14:38:30 merkaba kernel: [30453.384489] BTRFS info (device dm-1): found 36760 extents
Mar  5 14:38:30 merkaba kernel: [30453.725124] BTRFS info (device dm-1): relocating block group 276496908288 flags 1
Mar  5 14:38:48 merkaba kernel: [30471.034032] BTRFS info (device dm-1): found 33895 extents
Mar  5 14:38:59 merkaba kernel: [30482.399149] BTRFS info (device dm-1): found 33895 extents
Mar  5 14:38:59 merkaba kernel: [30482.703846] BTRFS info (device dm-1): relocating block group 275423166464 flags 1
Mar  5 14:39:17 merkaba kernel: [30499.809127] BTRFS info (device dm-1): found 35305 extents
Mar  5 14:39:28 merkaba kernel: [30511.093615] BTRFS info (device dm-1): found 35305 extents
Mar  5 14:39:28 merkaba kernel: [30511.405650] BTRFS info (device dm-1): relocating block group 274349424640 flags 1
Mar  5 14:39:48 merkaba kernel: [30531.476249] BTRFS info (device dm-1): found 39650 extents
Mar  5 14:40:00 merkaba kernel: [30543.340336] BTRFS info (device dm-1): found 39650 extents
Mar  5 14:40:00 merkaba kernel: [30543.669302] BTRFS info (device dm-1): relocating block group 273275682816 flags 1
Mar  5 14:40:22 merkaba kernel: [30565.131434] BTRFS info (device dm-1): found 43175 extents
Mar  5 14:40:31 merkaba kernel: [30574.459535] BTRFS info (device dm-1): found 43175 extents
Mar  5 14:40:32 merkaba kernel: [30574.805974] BTRFS info (device dm-1): relocating block group 272201940992 flags 1
Mar  5 14:40:47 merkaba kernel: [30590.337494] BTRFS info (device dm-1): found 34034 extents
Mar  5 14:40:59 merkaba kernel: [30602.521451] BTRFS info (device dm-1): found 34034 extents
Mar  5 14:41:00 merkaba kernel: [30602.834130] BTRFS info (device dm-1): relocating block group 271128199168 flags 1
Mar  5 14:41:13 merkaba kernel: [30616.727400] BTRFS info (device dm-1): found 27056 extents
Mar  5 14:41:24 merkaba kernel: [30627.430196] BTRFS info (device dm-1): found 27056 extents
Mar  5 14:41:24 merkaba kernel: [30627.692179] BTRFS info (device dm-1): relocating block group 270054457344 flags 1
Mar  5 14:41:41 merkaba kernel: [30644.035018] BTRFS info (device dm-1): found 30508 extents
Mar  5 14:41:53 merkaba kernel: [30655.872679] BTRFS info (device dm-1): found 30508 extents
Mar  5 14:41:53 merkaba kernel: [30656.141286] BTRFS info (device dm-1): relocating block group 268980715520 flags 1
Mar  5 14:42:06 merkaba kernel: [30669.507843] BTRFS info (device dm-1): found 41342 extents
Mar  5 14:42:19 merkaba kernel: [30682.247271] BTRFS info (device dm-1): found 41342 extents
Mar  5 14:42:19 merkaba kernel: [30682.592249] BTRFS info (device dm-1): relocating block group 267906973696 flags 1
Mar  5 14:42:33 merkaba kernel: [30696.003883] BTRFS info (device dm-1): found 24417 extents
Mar  5 14:42:43 merkaba kernel: [30705.978469] BTRFS info (device dm-1): found 24417 extents
Mar  5 14:42:43 merkaba kernel: [30706.288465] BTRFS info (device dm-1): relocating block group 266833231872 flags 1
Mar  5 14:42:47 merkaba kernel: [30710.121174] BTRFS info (device dm-1): found 8153 extents
Mar  5 14:42:57 merkaba kernel: [30720.211419] BTRFS info (device dm-1): found 8153 extents
Mar  5 14:42:57 merkaba kernel: [30720.363272] BTRFS info (device dm-1): relocating block group 265759490048 flags 1
Mar  5 14:43:02 merkaba kernel: [30725.417833] BTRFS info (device dm-1): found 10016 extents
Mar  5 14:43:14 merkaba kernel: [30737.176310] BTRFS info (device dm-1): found 10016 extents
Mar  5 14:43:14 merkaba kernel: [30737.341232] BTRFS info (device dm-1): relocating block group 264685748224 flags 1
Mar  5 14:43:20 merkaba kernel: [30742.982628] BTRFS info (device dm-1): found 13092 extents
Mar  5 14:43:30 merkaba kernel: [30753.542969] BTRFS info (device dm-1): found 13092 extents
Mar  5 14:43:30 merkaba kernel: [30753.724855] BTRFS info (device dm-1): relocating block group 263612006400 flags 1
Mar  5 14:43:36 merkaba kernel: [30759.351844] BTRFS info (device dm-1): found 13578 extents
Mar  5 14:43:47 merkaba kernel: [30769.920636] BTRFS info (device dm-1): found 13578 extents
Mar  5 14:43:47 merkaba kernel: [30770.115206] BTRFS info (device dm-1): relocating block group 263075135488 flags 36
Mar  5 14:44:09 merkaba kernel: [30792.474899] BTRFS info (device dm-1): found 15910 extents
Mar  5 14:44:09 merkaba kernel: [30792.543514] BTRFS info (device dm-1): relocating block group 262001393664 flags 1


Mar  5 14:47:03 merkaba kernel: [30966.214074] INFO: task btrfs:1609 blocked for more than 120 seconds.
Mar  5 14:47:03 merkaba kernel: [30966.219246]       Tainted: G           O 3.14.0-rc4-tp520 #47
Mar  5 14:47:03 merkaba kernel: [30966.224381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  5 14:47:03 merkaba kernel: [30966.229164] btrfs           D ffff8800c3a66648     0  1609  32481 0x00000000
Mar  5 14:47:03 merkaba kernel: [30966.234006]  ffff8800cc7f19a0 0000000000000002 ffff8800cc7f1fd8 ffff8800c3a66140
Mar  5 14:47:03 merkaba kernel: [30966.238464]  0000000000012dc0 ffff8800c3a66140 ffff88021e312dc0 ffff8800c3a66140
Mar  5 14:47:03 merkaba kernel: [30966.242956]  ffff8800cc7f1a40 0000000000000002 ffffffff810d244f ffff8800cc7f19b0
Mar  5 14:47:03 merkaba kernel: [30966.247459] Call Trace:
Mar  5 14:47:03 merkaba kernel: [30966.251479]  [<ffffffff810d244f>] ? wait_on_page_read+0x37/0x37
Mar  5 14:47:03 merkaba kernel: [30966.255632]  [<ffffffff8143f791>] schedule+0x6e/0x70
Mar  5 14:47:03 merkaba kernel: [30966.259749]  [<ffffffff8143f923>] io_schedule+0x5b/0x75
Mar  5 14:47:03 merkaba kernel: [30966.263509]  [<ffffffff810d2458>] sleep_on_page+0x9/0xd
Mar  5 14:47:03 merkaba kernel: [30966.267288]  [<ffffffff8143fcd4>] __wait_on_bit_lock+0x41/0x85
Mar  5 14:47:03 merkaba kernel: [30966.271068]  [<ffffffff810d2509>] __lock_page+0x64/0x66
Mar  5 14:47:03 merkaba kernel: [30966.274542]  [<ffffffff8106bdcf>] ? autoremove_wake_function+0x2f/0x2f
Mar  5 14:47:03 merkaba kernel: [30966.278087]  [<ffffffff810d290d>] ? find_get_page+0x64/0x70
Mar  5 14:47:03 merkaba kernel: [30966.281603]  [<ffffffff810d2b86>] lock_page+0x19/0x1c
Mar  5 14:47:03 merkaba kernel: [30966.284849]  [<ffffffff810d2bd8>] find_lock_page+0x2e/0x50
Mar  5 14:47:03 merkaba kernel: [30966.288169]  [<ffffffffa02d84b5>] relocate_file_extent_cluster+0x117/0x31c [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.291545]  [<ffffffffa02d86e9>] relocate_data_extent+0x2f/0xa2 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.294668]  [<ffffffffa02dc127>] relocate_block_group+0x2f7/0x4be [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.297812]  [<ffffffffa02b1dd6>] ? btrfs_wait_ordered_roots+0x128/0x141 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.300990]  [<ffffffffa02dc441>] btrfs_relocate_block_group+0x153/0x265 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.303968]  [<ffffffffa02bb81a>] btrfs_relocate_chunk.isra.26+0x57/0x5ca [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.306958]  [<ffffffff81441d32>] ? _raw_spin_unlock+0x11/0x24
Mar  5 14:47:03 merkaba kernel: [30966.309958]  [<ffffffffa02b77ae>] ? free_extent_buffer+0x85/0x88 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.312975]  [<ffffffffa02bd4c1>] btrfs_shrink_device+0x1f6/0x38e [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.315874]  [<ffffffffa02c3425>] btrfs_ioctl_resize+0x2c5/0x320 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.318761]  [<ffffffffa02c7357>] btrfs_ioctl+0x6d6/0x2451 [btrfs]
Mar  5 14:47:03 merkaba kernel: [30966.321600]  [<ffffffff81444bad>] ? __do_page_fault+0x322/0x396
Mar  5 14:47:03 merkaba kernel: [30966.324468]  [<ffffffff81134208>] do_vfs_ioctl+0x351/0x415
Mar  5 14:47:03 merkaba kernel: [30966.327179]  [<ffffffff81062a1e>] ? vtime_account_user+0x41/0x46
Mar  5 14:47:03 merkaba kernel: [30966.329874]  [<ffffffff8113431e>] SyS_ioctl+0x52/0x7d
Mar  5 14:47:03 merkaba kernel: [30966.332591]  [<ffffffff81446b9b>] tracesys+0xdd/0xe2
Mar  5 14:49:03 merkaba kernel: [31086.355595] INFO: task btrfs:1609 blocked for more than 120 seconds.
Mar  5 14:49:03 merkaba kernel: [31086.361592]       Tainted: G           O 3.14.0-rc4-tp520 #47
Mar  5 14:49:03 merkaba kernel: [31086.367568] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  5 14:49:03 merkaba kernel: [31086.373015] btrfs           D ffff8800c3a66648     0  1609  32481 0x00000000
Mar  5 14:49:03 merkaba kernel: [31086.378619]  ffff8800cc7f19a0 0000000000000002 ffff8800cc7f1fd8 ffff8800c3a66140
Mar  5 14:49:03 merkaba kernel: [31086.383885]  0000000000012dc0 ffff8800c3a66140 ffff88021e312dc0 ffff8800c3a66140
Mar  5 14:49:03 merkaba kernel: [31086.388997]  ffff8800cc7f1a40 0000000000000002 ffffffff810d244f ffff8800cc7f19b0
Mar  5 14:49:03 merkaba kernel: [31086.393736] Call Trace:
Mar  5 14:49:03 merkaba kernel: [31086.398372]  [<ffffffff810d244f>] ? wait_on_page_read+0x37/0x37
Mar  5 14:49:03 merkaba kernel: [31086.403088]  [<ffffffff8143f791>] schedule+0x6e/0x70
Mar  5 14:49:03 merkaba kernel: [31086.407452]  [<ffffffff8143f923>] io_schedule+0x5b/0x75
Mar  5 14:49:03 merkaba kernel: [31086.411766]  [<ffffffff810d2458>] sleep_on_page+0x9/0xd
Mar  5 14:49:03 merkaba kernel: [31086.416051]  [<ffffffff8143fcd4>] __wait_on_bit_lock+0x41/0x85
Mar  5 14:49:03 merkaba kernel: [31086.420019]  [<ffffffff810d2509>] __lock_page+0x64/0x66
Mar  5 14:49:03 merkaba kernel: [31086.423906]  [<ffffffff8106bdcf>] ? autoremove_wake_function+0x2f/0x2f
Mar  5 14:49:03 merkaba kernel: [31086.427798]  [<ffffffff810d290d>] ? find_get_page+0x64/0x70
Mar  5 14:49:03 merkaba kernel: [31086.431376]  [<ffffffff810d2b86>] lock_page+0x19/0x1c
Mar  5 14:49:03 merkaba kernel: [31086.434860]  [<ffffffff810d2bd8>] find_lock_page+0x2e/0x50
Mar  5 14:49:03 merkaba kernel: [31086.438356]  [<ffffffffa02d84b5>] relocate_file_extent_cluster+0x117/0x31c [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.441662]  [<ffffffffa02d86e9>] relocate_data_extent+0x2f/0xa2 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.444950]  [<ffffffffa02dc127>] relocate_block_group+0x2f7/0x4be [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.448187]  [<ffffffffa02b1dd6>] ? btrfs_wait_ordered_roots+0x128/0x141 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.451237]  [<ffffffffa02dc441>] btrfs_relocate_block_group+0x153/0x265 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.454309]  [<ffffffffa02bb81a>] btrfs_relocate_chunk.isra.26+0x57/0x5ca [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.457350]  [<ffffffff81441d32>] ? _raw_spin_unlock+0x11/0x24
Mar  5 14:49:03 merkaba kernel: [31086.460431]  [<ffffffffa02b77ae>] ? free_extent_buffer+0x85/0x88 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.463374]  [<ffffffffa02bd4c1>] btrfs_shrink_device+0x1f6/0x38e [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.466321]  [<ffffffffa02c3425>] btrfs_ioctl_resize+0x2c5/0x320 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.469264]  [<ffffffffa02c7357>] btrfs_ioctl+0x6d6/0x2451 [btrfs]
Mar  5 14:49:03 merkaba kernel: [31086.472176]  [<ffffffff81444bad>] ? __do_page_fault+0x322/0x396
Mar  5 14:49:03 merkaba kernel: [31086.474945]  [<ffffffff81134208>] do_vfs_ioctl+0x351/0x415
Mar  5 14:49:03 merkaba kernel: [31086.477712]  [<ffffffff81062a1e>] ? vtime_account_user+0x41/0x46
Mar  5 14:49:03 merkaba kernel: [31086.480464]  [<ffffffff8113431e>] SyS_ioctl+0x52/0x7d
Mar  5 14:49:03 merkaba kernel: [31086.483197]  [<ffffffff81446b9b>] tracesys+0xdd/0xe2

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
