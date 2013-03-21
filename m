Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox1.develooper.com ([207.171.7.178]:33731 "EHLO
	mbox1.develooper.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3CUTTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 15:19:30 -0400
Received: from mbox1.develooper.com (mbox1.develooper.com [127.0.0.1])
	by mbox1.develooper.com (Postfix) with ESMTP id 45697175B2D
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 11:56:37 -0700 (PDT)
From: =?iso-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs "stuck" on 
Message-Id: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
Date: Thu, 21 Mar 2013 11:56:37 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

A few weeks ago I replaced a ZFS backup system with one backed by btrfs. A script loops over a bunch of hosts rsyncing them to each their own subvolume.  After each rsync I snapshot the "host-specific" subvolume.

The "disk" is an iscsi disk that in my benchmarks performs roughly like a local raid with 2-3 SATA disks.

It worked fine for about a week (~150 snapshots from ~20 sub volumes) before it "suddenly" exploded in disk io wait. Doing anything (in particular changes) on the file system is just insanely slow, rsync basically can't complete (an rsync that should take 10-20 minutes takes 24 hours; I have a directory of 60k files I tried deleting and it's deleting one file every few minutes, that sort of thing).

I am using 3.8.2-206.fc18.x86_64 (Fedora 18). I tried rebooting, it doesn't make a difference. As soon as I boot "[btrfs-cleaner]" and "[btrfs-transacti]" gets really busy.

I wonder if it's because I deleted a few snapshots at some point? 

The file system is mounted with "-o compress=zlib,noatime"

# mount | grep tank
/dev/sdc on /tank type btrfs (rw,noatime,seclabel,compress=zlib,space_cache,_netdev)

I don't recall mounting it with space_cache; though I don't think that's the default so I wonder if I did do that at some point. Could that be what's messing me up?

btrfs-cleaner stack:

# cat /proc/1117/stack 
[<ffffffffa022598a>] btrfs_commit_transaction+0x36a/0xa70 [btrfs]
[<ffffffffa022677f>] start_transaction+0x23f/0x460 [btrfs]
[<ffffffffa0226cb8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[<ffffffffa021487f>] btrfs_drop_snapshot+0x3ef/0x5d0 [btrfs]
[<ffffffffa0226e1f>] btrfs_clean_old_snapshots+0x9f/0x120 [btrfs]
[<ffffffffa021eda9>] cleaner_kthread+0xa9/0x120 [btrfs]
[<ffffffff81081f90>] kthread+0xc0/0xd0
[<ffffffff816584ac>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff


btrfs-transaction stack:

#  cat /proc/1118/stack 
[<ffffffffa0256b35>] btrfs_tree_read_lock+0x95/0x110 [btrfs]
[<ffffffffa020033b>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[<ffffffffa0205649>] btrfs_search_slot+0x3f9/0x7a0 [btrfs]
[<ffffffffa020be5e>] lookup_inline_extent_backref+0x8e/0x4d0 [btrfs]
[<ffffffffa020dd38>] __btrfs_free_extent+0xc8/0x870 [btrfs]
[<ffffffffa0211f29>] run_clustered_refs+0x459/0xb50 [btrfs]
[<ffffffffa0215e48>] btrfs_run_delayed_refs+0xc8/0x2f0 [btrfs]
[<ffffffffa02256a6>] btrfs_commit_transaction+0x86/0xa70 [btrfs]
[<ffffffffa021e7c5>] transaction_kthread+0x1a5/0x220 [btrfs]
[<ffffffff81081f90>] kthread+0xc0/0xd0
[<ffffffff816584ac>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff


Thank you for reading this far. Any suggestions would be most appreciated!


Ask

