Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:37018
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757225AbbA2BoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:06 -0500
From: Steven Schlansker <sschlansker@opentable.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Indefinite hang in reserve_metadata_bytes on kernel 3.18.3
Date: Thu, 29 Jan 2015 01:44:02 +0000
Message-ID: <868704D3-B79F-476F-A4CF-33C41274E6D4@opentable.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ Please CC me on responses, I am not subscribed to the list ]

Hello linux-btrfs,

I am running an cluster of Docker containers managed by Apache Mesos.  Until recently, we'd found btrfs to be the most reliable storage backend for Docker.  But now we are having troubles where large numbers of our slave nodes go offline due to processes hanging indefinitely inside of btrfs.

We were initially running Ubuntu kernel 3.13.0-44, but had serious troubles, so I moved to 3.18.3 to preemptively address the "You should run a recent vanilla kernel" response I expected from this mailing list :)

The symptoms are an endlessly increasing stream of hung tasks and high load average.  The first process (a Mesos slave task) to hang is stuck here, according to /proc/*/stack:

[<ffffffffa004333a>] reserve_metadata_bytes+0xca/0x4c0 [btrfs]
[<ffffffffa00443c9>] btrfs_delalloc_reserve_metadata+0x149/0x490 [btrfs]
[<ffffffffa006dbe2>] __btrfs_buffered_write+0x162/0x590 [btrfs]
[<ffffffffa006e297>] btrfs_file_write_iter+0x287/0x4e0 [btrfs]
[<ffffffff811dc6f1>] new_sync_write+0x81/0xb0
[<ffffffff811dd017>] vfs_write+0xb7/0x1f0
[<ffffffff811dda96>] SyS_write+0x46/0xb0
[<ffffffff8187842d>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

A further attempt to access btrfs ( ls -Rl /mnt ) hangs here:

[<ffffffffa004333a>] reserve_metadata_bytes+0xca/0x4c0 [btrfs]
[<ffffffffa0043cc0>] btrfs_block_rsv_add+0x30/0x60 [btrfs]
[<ffffffffa005c1ba>] start_transaction+0x45a/0x5a0 [btrfs]
[<ffffffffa005c31b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
[<ffffffffa0061f88>] btrfs_dirty_inode+0xb8/0xe0 [btrfs]
[<ffffffffa0062014>] btrfs_update_time+0x64/0xd0 [btrfs]
[<ffffffff811f7c65>] update_time+0x25/0xc0
[<ffffffff811f7dfa>] touch_atime+0xfa/0x140
[<ffffffff811e2621>] SyS_readlink+0xd1/0x130
[<ffffffff8187842d>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

The only other processes with stack traces in btrfs code are the cleaner and transaction kthreads, sleeping here:
[<ffffffffa00536c5>] cleaner_kthread+0x165/0x190 [btrfs]
[<ffffffff8108d6b2>] kthread+0xd2/0xf0
[<ffffffff8187837c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa0057139>] transaction_kthread+0x1f9/0x240 [btrfs]
[<ffffffff8108d6b2>] kthread+0xd2/0xf0
[<ffffffff8187837c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

Here's the information asked on the mailing list page:

Linux ip-10-70-6-163 3.18.3 #4 SMP Tue Jan 27 20:14:45 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

root@ip-10-70-6-163:/proc/1086# btrfs fi show
Label: none  uuid: 5c10d6f5-6207-41fd-8756-6399fab731f5
	Total devices 2 FS bytes used 14.63GiB
	devid    1 size 74.99GiB used 9.01GiB path /dev/xvdc
	devid    2 size 74.99GiB used 9.01GiB path /dev/xvdd

Btrfs v3.12

root@ip-10-70-6-163:/proc/1086# btrfs fi df /mnt
Data, RAID0: total=16.00GiB, used=13.28GiB
System, RAID0: total=16.00MiB, used=16.00KiB
Metadata, RAID0: total=2.00GiB, used=1.35GiB
unknown, single: total=336.00MiB, used=0.00


What can I do to further diagnose this problem?  How do I keep my cluster from falling down around me in many tiny pieces?

Thanks,
Steven Schlansker