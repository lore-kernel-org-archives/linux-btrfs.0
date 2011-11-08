From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/btrfs/file.c:1656 [for-linus]
Date: Tue, 8 Nov 2011 12:45:20 -0500
Message-ID: <20111108174520.GL4954@shiny>
References: <20111108171347.GS12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108171347.GS12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 06:13:47PM +0100, David Sterba wrote:
> Hi,
> 
> a new BUG_ON on for-linus branch with
> 
> commit 45ea6095c8f0d6caad5658306416a5d254f1205e
> Author: slyich@gmail.com <slyich@gmail.com>
> Date:   Mon Nov 7 16:08:01 2011 -0500
> 
>     btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
> 
> on top. Freshly created fs,
> 
> === DF for /dev/sda5
> Data, RAID0: total=4.00GB, used=0.00
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
> === DF for /dev/sda9
> Data: total=8.00MB, used=0.00
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
> 
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 3.1.0-rc10-default+
> MKFS_OPTIONS  -- /dev/sda9
> MOUNT_OPTIONS -- -o compress=lzo,discard,space_cache,autodefrag
> /dev/sda9 /mnt/a2
> 
> xfstests/013 (tests running from 001 up to it)
> 
> [  267.150042] ------------[ cut here ]------------
> [  267.152882] kernel BUG at fs/btrfs/file.c:1656!
> [  267.152882] invalid opcode: 0000 [#1] SMP
> [  267.152882] CPU 1
> [  267.152882] Modules linked in: loop btrfs aoe
> [  267.152882]
> [  267.152882] Pid: 8324, comm: fsstress Not tainted 3.1.0-rc10-default+ #59
> [  267.152882] RIP: 0010:[<ffffffffa0047d70>]  [<ffffffffa0047d70>] btrfs_fallocate+0x380/0x3d0 [btrfs]
> [  267.152882] RSP: 0018:ffff8800732b7e88  EFLAGS: 00010202
> [  267.152882] RAX: ffffffffffffffef RBX: 0000000000112000 RCX: 0000000000000006
> [  267.152882] RDX: 0000000000000001 RSI: ffff880077c6d078 RDI: 0000000000000000
> [  267.220213] RBP: ffff8800732b7f38 R08: 0000000000000001 R09: 0000000000000001
> [  267.220213] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffffffffef
> [  267.220213] R13: 0000000000112000 R14: ffff88006f961be8 R15: 0000000000158000
> [  267.220213] FS:  00007fd4d475e700(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
> [  267.220213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  267.220213] CR2: 00007fa5545d9000 CR3: 0000000077731000 CR4: 00000000000006e0
> [  267.220213] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  267.220213] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  267.220213] Process fsstress (pid: 8324, threadinfo ffff8800732b6000, task ffff880077c6ca00)
> [  267.220213] Stack:
> [  267.220213]  ffff880077c6ca00 ffff880077c6d078 ffff8800732b7ec8 ffff88006f9617f8
> [  267.220213]  00000000000e3000 ffff88006f9618b0 0000000000157fff 0000000181143ef4
> [  267.220213]  ffff88006f961cc8 fffffffffffff000 0000000000000fff 0000000100000001
> [  267.220213] Call Trace:
> [  267.220213]  [<ffffffff81141330>] do_fallocate+0xe0/0xf0
> [  267.220213]  [<ffffffff8114138e>] sys_fallocate+0x4e/0x80
> [  267.220213]  [<ffffffff81a1d742>] system_call_fastpath+0x16/0x1b
> [  267.220213] Code: 8b 7d 90 e8 e3 b5 9c e1 e9 f2 fc ff ff 66 0f 1f 44 00 00 49 39 c7 48 89 c3 49 0f 46 df e9 12 ff ff ff 66 0f 1f 84 00 00 00 00 00 <0f> 0b 66 0f 1f 44 00 00 48 89 c7 4c 89 e3 4d 89 fd e8 8a b4 00
> [  267.220213] RIP  [<ffffffffa0047d70>] btrfs_fallocate+0x380/0x3d0 [btrfs]
> [  267.220213]  RSP <ffff8800732b7e88>
> [  267.393603] ---[ end trace d0abb6e726d09321 ]---
> 
> btrfs_fallocate():
> 1651         while (1) {
> 1652                 u64 actual_end;
> 1653
> 1654                 em = btrfs_get_extent(inode, NULL, 0, cur_offset,
> 1655                                       alloc_end - cur_offset, 0);
> 1656                 BUG_ON(IS_ERR_OR_NULL(em));
> 
> RAX says its -17 EEXIST. We saw this with raid10 + inode_cache, but this is not
> the case.
> 
> the process that triggered it:
> 
> D+   17:52   0:00 rm -rf /mnt/a1/fsstress.8088.1 /mnt/a1/fsstress.8088.2
> 
> $ cat /proc/8458/stack
> [<ffffffff81152205>] vfs_unlink+0x65/0x100
> [<ffffffff8115243b>] do_unlinkat+0x19b/0x1d0
> [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
> [<ffffffff81a1d742>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff

In this case, btrfs_get_extent is trying to insert into the rbtree
mapping offset to disk.  merge_extent_mapping must be failing.

The only part that confuses me is that we don't fallocate from unlink,
so that process must have moved on.

At any rate, mege_extent_mapping is pretty simple, were there any other
errors in the dmesg?

-chris
