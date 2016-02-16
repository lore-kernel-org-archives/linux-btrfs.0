Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33429 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbcBPKbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 05:31:23 -0500
Received: by mail-wm0-f41.google.com with SMTP id g62so184627869wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 02:31:22 -0800 (PST)
Received: from [10.3.28.25] ([155.210.217.96])
        by smtp.gmail.com with ESMTPSA id x186sm19843865wmg.19.2016.02.16.02.31.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 16 Feb 2016 02:31:20 -0800 (PST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Psalle <psalleetsile@gmail.com>
Subject: Deadlock while removing device, kernel 4.4.1
Message-ID: <56C2FA77.2010604@gmail.com>
Date: Tue, 16 Feb 2016 11:31:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a test system so I'm reporting in case this is unknown but no 
data at risk.

This filesystem was created with a device (well, actually partition) 
/dev/sdb3, then /dev/sdc{2,3,4} were added, and finally I attempted to 
remove /dev/sdb3. No profiles were passed at any point.

Briefly after starting the remove, which seemed to proceed fine 
according to fi show, I started a rsync involving around 8GB from 
another fs into the one being reshaped. Not sure if this could have been 
related; rsync never transferred anything. Source was a degraded raid5 
with six devices, one of them missing.

Soon everything requiring disk access froze. This was with latest ubuntu 
stable upstream, i.e. 4.4.1-040401-generic

I rebooted without problems to mount the filesystems. As I write, I'm 
doing the same process with latest 15.10 kernel 4.2.0-27-generic, for 
the moment things going smoothly.

Login as root I captured the dmesg. Here is the final bit:

[  600.114436] INFO: task D-Bus thread:7692 blocked for more than 120 
seconds.
[  600.114438]       Tainted: P           OE   4.4.1-040401-generic 
#201601311534
[  600.114440] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  600.114442] D-Bus thread    D ffff88007e4bfde8     0  7692   2842 
0x00000000
[  600.114446]  ffff88007e4bfde8 0000000000000000 ffffffff81e11500 
ffff8800b0b65940
[  600.114450]  ffff88007e4c0000 ffff8800bf509e68 ffff8800bf509e80 
ffff88007e4bff58
[  600.114454]  ffff8800b0b65940 ffff88007e4bfe00 ffffffff817f9b15 
ffff8800b0b65940
[  600.114458] Call Trace:
[  600.114461]  [<ffffffff817f9b15>] schedule+0x35/0x80
[  600.114464]  [<ffffffff817fc990>] rwsem_down_read_failed+0xe0/0x140
[  600.114467]  [<ffffffff817fd069>] ? 
schedule_hrtimeout_range_clock+0x19/0x40
[  600.114471]  [<ffffffff813d7254>] call_rwsem_down_read_failed+0x14/0x30
[  600.114474]  [<ffffffff817fbf60>] ? down_read+0x20/0x30
[  600.114477]  [<ffffffff810686f5>] __do_page_fault+0x375/0x400
[  600.114480]  [<ffffffff810687a2>] do_page_fault+0x22/0x30
[  600.114483]  [<ffffffff817ffd38>] page_fault+0x28/0x30
[  600.114487] INFO: task BrowserBlocking:7697 blocked for more than 120 
seconds.
[  600.114489]       Tainted: P           OE   4.4.1-040401-generic 
#201601311534
[  600.114491] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  600.114493] BrowserBlocking D ffff88003565fbe0     0  7697   2842 
0x00000000
[  600.114497]  ffff88003565fbe0 00000058c6dff62b ffff88011abf8000 
ffff8800ae816600
[  600.114501]  ffff880035660000 00000000ffffff00 ffff8800ae816600 
ffff8800ae816600
[  600.114505]  ffff8800a35c1c70 ffff88003565fbf8 ffffffff817f9b15 
ffff8800a35c1cd8
[  600.114509] Call Trace:
[  600.114512]  [<ffffffff817f9b15>] schedule+0x35/0x80
[  600.114534]  [<ffffffffc0104cd6>] btrfs_tree_read_lock+0xe6/0x140 [btrfs]
[  600.114538]  [<ffffffff810bfec0>] ? wake_atomic_t_function+0x60/0x60
[  600.114554]  [<ffffffffc009eb24>] btrfs_read_lock_root_node+0x34/0x50 
[btrfs]
[  600.114569]  [<ffffffffc00a3bef>] btrfs_search_slot+0x73f/0x9f0 [btrfs]
[  600.114574]  [<ffffffff81383f60>] ? crypto_shash_update+0x30/0xe0
[  600.114593]  [<ffffffffc00bc217>] 
btrfs_check_dir_item_collision+0x77/0x120 [btrfs]
[  600.114614]  [<ffffffffc00d8150>] btrfs_rename2+0x130/0x7b0 [btrfs]
[  600.114618]  [<ffffffff81210500>] ? generic_permission+0x110/0x190
[  600.114622]  [<ffffffff8121338a>] vfs_rename+0x54a/0x870
[  600.114626]  [<ffffffff81333400>] ? security_path_rename+0x20/0xd0
[  600.114630]  [<ffffffff812180bb>] SyS_rename+0x38b/0x3d0
[  600.114634]  [<ffffffff817fdbb6>] entry_SYSCALL_64_fastpath+0x16/0x75

There's more before this but it looks similar.

Known issue?
