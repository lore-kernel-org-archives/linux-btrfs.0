Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966753Ab3DROmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 10:42:21 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 135CFA52D8
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:42:20 +0200 (CEST)
Date: Thu, 18 Apr 2013 16:42:18 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [bug] 3.9-rc7+next: NULL deref in
 btrfs_next_old_leaf/btrfs_search_slot
Message-ID: <20130418144218.GH16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

xfstests loop has hit this after a day, failing test was 276. The sources are
btrfs-next/linus-base branch. I've hit this some time ago with
3.9.0-rc4-default+ .

[64394.422743] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
[64394.426716] IP: [<ffffffffa0010e0f>] btrfs_search_slot+0xbf/0x9e0 [btrfs]
[64394.426716] PGD 79201067 PUD 771c4067 PMD 0
[64394.426716] Oops: 0002 [#1] SMP
[64394.426716] Modules linked in: aoe dm_crypt loop btrfs
[64394.426716] CPU 1
[64394.426716] Pid: 32556, comm: btrfs-cache-1 Not tainted 3.9.0-rc7-default+ #292 Intel Corporation Santa Rosa platform/Matanzas
[64394.426716] RIP: 0010:[<ffffffffa0010e0f>]  [<ffffffffa0010e0f>] btrfs_search_slot+0xbf/0x9e0 [btrfs]
[64394.426716] RSP: 0018:ffff88004cb4fb68  EFLAGS: 00010202
[64394.426716] RAX: 0000000000000000 RBX: ffff880003ec5b18 RCX: ffff880077893000
[64394.426716] RDX: 0000000000000000 RSI: ffff880077893000 RDI: 0000000000000000
[64394.426716] RBP: ffff88004cb4fbf8 R08: 0000000000000000 R09: 0000000000000000
[64394.426716] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[64394.426716] R13: 0000000000000030 R14: 0000000000000000 R15: 0000160000000000
[64394.426716] FS:  0000000000000000(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
[64394.426716] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[64394.426716] CR2: 0000000000000078 CR3: 00000000760cf000 CR4: 00000000000007e0
[64394.426716] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[64394.426716] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[64394.426716] Process btrfs-cache-1 (pid: 32556, threadinfo ffff88004cb4e000, task ffff8800250f0a80)
[64394.426716] Stack:
[64394.426716]  000000794cb4fc58 ffff880077893000 0000100000000001 ffffffff00000000
[64394.426716]  0000000000000001 0000000000000000 00000000364d0000 ffff88004cb4fc58
[64394.426716]  000000006cfbb7a8 ffff880077893000 0000000000000000 00000032ffffffff
[64394.426716] Call Trace:
[64394.426716]  [<ffffffffa0014977>] btrfs_next_old_leaf+0x247/0x4e0 [btrfs]
[64394.426716]  [<ffffffffa0014c20>] btrfs_next_leaf+0x10/0x20 [btrfs]
[64394.426716]  [<ffffffffa0019775>] caching_thread+0x1f5/0x3c0 [btrfs]
[64394.426716]  [<ffffffffa0063cc4>] worker_loop+0xc4/0x5a0 [btrfs]
[64394.426716]  [<ffffffffa0063c00>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[64394.426716]  [<ffffffff8107669e>] kthread+0xde/0xf0
[64394.426716]  [<ffffffff810765c0>] ? flush_kthread_worker+0x1e0/0x1e0
[64394.426716]  [<ffffffff81967eac>] ret_from_fork+0x7c/0xb0
[64394.426716]  [<ffffffff810765c0>] ? flush_kthread_worker+0x1e0/0x1e0
[64394.426716] Code: 8c ff ff ff ff 45 0f b6 e4 a8 10 49 bf 00 00 00 00 00 16 00 00 44 89 65 88 0f 84 a6 01 00 00 48 8b 4d b8 48 8b 41 08 48 89 45 c0 <f0> ff 40 78 48 8b 45 c0 4c 89 fa 48 b9 b7 6d db b6 6d db b6 6d
[64394.426716] RIP  [<ffffffffa0010e0f>] btrfs_search_slot+0xbf/0x9e0 [btrfs]
[64394.426716]  RSP <ffff88004cb4fb68>
[64394.426716] CR2: 0000000000000078

Happens probably during umount of the scratch partition:

32562 pts/0    D+     0:00 /bin/umount /dev/sda9
[<ffffffff813a55c3>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffffa00227ff>] btrfs_free_block_groups+0x2f/0x390 [btrfs]
[<ffffffffa0030606>] close_ctree+0x146/0x240 [btrfs]
[<ffffffffa0003bf9>] btrfs_put_super+0x19/0x20 [btrfs]
[<ffffffff81163572>] generic_shutdown_super+0x62/0xf0
[<ffffffff81163696>] kill_anon_super+0x16/0x30
[<ffffffffa0004b2a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[<ffffffff811638ed>] deactivate_locked_super+0x3d/0x90
[<ffffffff8116458a>] deactivate_super+0x4a/0x70
[<ffffffff81180720>] mntput_no_expire+0x100/0x160
[<ffffffff811817bc>] sys_umount+0xcc/0x3c0
[<ffffffff81967f59>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

/dev/sda5 on /mnt/a1 type btrfs (rw,noatime,compress-force=lzo,space_cache,enospc_debug)

$ btrfs fi df /mnt/a1
Data, RAID10: total=17.95GB, used=41.12MB
Data: total=8.00MB, used=0.00
System, RAID10: total=16.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=2.00GB, used=2.71MB
Metadata: total=8.00MB, used=0.00

previous test parameters were same as now:

MKFS_OPTIONS  -- -m single -d single /dev/sda9
MOUNT_OPTIONS -- -o enospc_debug,space_cache,noatime,compress-force=lzo /dev/sda9 /mnt/a2


david
