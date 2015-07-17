Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50206 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbbGQShc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 14:37:32 -0400
Date: Fri, 17 Jul 2015 11:36:44 -0700
From: Omar Sandoval <osandov@fb.com>
To: Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: btrfs_create_pending_block_groups:9460: errno=-27 unknown
Message-ID: <20150717183644.GA29328@huxley.DHCP.TheFacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, Filipe,

I've been seeing errors of this sort:

[  658.221300] ------------[ cut here ]------------
[  658.221948] WARNING: CPU: 0 PID: 1636 at fs/btrfs/extent-tree.c:9460 btrfs_create_pending_block_groups+0x16b/0x210()
[  658.223274] CPU: 0 PID: 1636 Comm: btrfs-transacti Not tainted 4.2.0-rc2 #65
[  658.224205] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153802- 04/01/2014
[  658.225389]  0000000000000000 000000007e9aaa02 ffff880037a3bb78 ffffffff81a02490
[  658.226435]  0000000000000026 ffff880037a3bbd0 ffff880037a3bbb8 ffffffff81080b81
[  658.227494]  0000000002000000 ffff88002c724000 ffff88002c7241a8 ffff88003691c160
[  658.228536] Call Trace:
[  658.228860]  [<ffffffff81a02490>] dump_stack+0x4c/0x6e
[  658.229510]  [<ffffffff81080b81>] warn_slowpath_common+0x81/0xc0
[  658.230272]  [<ffffffff81080c45>] warn_slowpath_fmt+0x55/0x70
[  658.231032]  [<ffffffff814a884b>] btrfs_create_pending_block_groups+0x16b/0x210
[  658.231987]  [<ffffffff814a8fb1>] btrfs_start_dirty_block_groups+0xd1/0x3f0
[  658.232852]  [<ffffffff814baf84>] btrfs_commit_transaction+0x1c4/0xed0
[  658.233692]  [<ffffffff814bbd34>] ? start_transaction+0xa4/0x730
[  658.234477]  [<ffffffff814b6168>] transaction_kthread+0x208/0x270
[  658.235225]  [<ffffffff814b5f60>] ? btrfs_cleanup_transaction+0x700/0x700
[  658.236078]  [<ffffffff810a4c5e>] kthread+0xfe/0x120
[  658.236861]  [<ffffffff810ad660>] ? finish_task_switch+0x50/0x1a0
[  658.237731]  [<ffffffff810a4b60>] ? __kthread_parkme+0xa0/0xa0
[  658.238596]  [<ffffffff81a0b99f>] ret_from_fork+0x3f/0x70
[  658.239364]  [<ffffffff810a4b60>] ? __kthread_parkme+0xa0/0xa0
[  658.240207] ---[ end trace f3b05c72d6a843fb ]---
[  658.240887] BTRFS: error (device loop0) in btrfs_create_pending_block_groups:9460: errno=-27 unknown
[  658.242235] BTRFS info (device loop0): forced readonly
[  658.338726] BTRFS warning (device loop0): Skipping commit of aborted transaction.
[  658.339629] BTRFS: error (device loop0) in cleanup_transaction:1710: errno=-27 unknown

on 4.2-rc2 which I tracked down to your commit 4fbcdf669454 ("Btrfs: fix
-ENOSPC when finishing block group creation").

Here's a reproducer, run on a 100TB Btrfs sparse image which is mounted
over loopback:

----
truncate -s 100T big.img
mkfs.btrfs big.img
mount -o loop big.img /mnt/loop

num=5
for ((i = 0; i < num; i++)); do
	echo fallocate $i
	fallocate -l 10T /mnt/loop/testfile$i
done
btrfs filesystem sync /mnt/loop

for ((i = 0; i < num; i++)); do
	echo rm $i
	rm /mnt/loop/testfile$i
	btrfs filesystem sync /mnt/loop
done

umount /mnt/loop
----

That works pre-4.2 but not with 4fbcdf669454 applied.

That -27 is EFBIG which is coming from btrfs_add_system_chunk(). It
seems like something is causing spurious allocations of system chunks or
something, but I'm not familiar with the code. Could you take a look?

Thanks a lot,
-- 
Omar
