From: David Sterba <dave@jikos.cz>
Subject: Re: BUG at fs/btrfs/tree-log.c:3106 (Re: new integration-danger branch pushed out (kernel))
Date: Tue, 1 Nov 2011 17:39:41 +0100
Message-ID: <20111101163941.GI12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny> <20111101103637.GD12759@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: liubo2009@cn.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101103637.GD12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:36:37AM +0100, David Sterba wrote:
> xfstests/214
> 
> [ 3142.654774] ------------[ cut here ]------------
> [ 3142.656017] kernel BUG at fs/btrfs/tree-log.c:3106!
> [ 3142.656017] invalid opcode: 0000 [#1] SMP
> [ 3142.656017] CPU 0
> [ 3142.656017] Modules linked in: loop btrfs aoe
> [ 3142.656017]
> [ 3142.656017] Pid: 27328, comm: xfs_io Tainted: G        W   3.1.0-default+ #64 Intel Corporation Santa Rosa platform/Matanzas
> [ 3142.656017] RIP: 0010:[<ffffffffa006fe74>]  [<ffffffffa006fe74>] btrfs_log_inode+0x554/0x600 [btrfs]
> [ 3142.656017] RSP: 0018:ffff88005c801d58  EFLAGS: 00010282
> [ 3142.656017] RAX: 00000000ffffffef RBX: ffff88003ef39e20 RCX: 0000000000000006
> [ 3142.656017] RDX: 0000000000000001 RSI: ffff8800643aa170 RDI: 0000000000000286
> [ 3142.656017] RBP: ffff88005c801e48 R08: 0000000000000001 R09: 0000000000000001
> [ 3142.656017] R10: 0000000000000001 R11: 0000000000000002 R12: ffff88003405fe70
> [ 3142.656017] R13: ffff88005c801db8 R14: 0000000000000003 R15: ffff8800340604b0
> [ 3142.656017] FS:  00007f7034667700(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
> [ 3142.656017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3142.656017] CR2: 00000000006b1fb0 CR3: 00000000778df000 CR4: 00000000000006f0
> [ 3142.656017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3142.656017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3142.656017] Process xfs_io (pid: 27328, threadinfo ffff88005c800000, task ffff8800643a9ac0)
> [ 3142.656017] Stack:
> [ 3142.656017]  0000000000000000 0000000000000000 ffff8800340602b0 ffff880072efe000
> [ 3142.656017]  0000000000000000 00000000000004c8 000000005c801dd8 ffff8800340604b0
> [ 3142.656017]  ffff88003ef39eb0 ffff88000dfb4420 0000000000000019 0000000000000308
> [ 3142.656017] Call Trace:
> [ 3142.656017]  [<ffffffffa0070d28>] btrfs_log_inode_parent+0x198/0x480 [btrfs]
> [ 3142.656017]  [<ffffffff8115941c>] ? dget_parent+0x1c/0xd0
> [ 3142.656017]  [<ffffffffa0071059>] btrfs_log_dentry_safe+0x49/0x70 [btrfs]
> [ 3142.656017]  [<ffffffffa0049406>] btrfs_sync_file+0x146/0x1d0 [btrfs]
> [ 3142.656017]  [<ffffffff81143e80>] ? fget_raw+0x210/0x210
> [ 3142.656017]  [<ffffffff81171029>] do_fsync+0x59/0x80
> [ 3142.656017]  [<ffffffff81171340>] sys_fsync+0x10/0x20
> [ 3142.656017]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
> [ 3142.656017] Code: 60 ff ff ff 45 89 f1 48 8b bd 58 ff ff ff 4c 89 e1 4c 89 fe 89 14 24 48 8b 95 50 ff ff ff e8 44 cf ff ff 85 c0 0f 84 04 fe ff ff <0f> 0b 48 89 df e8 f2 62 fa ff 48 8b bd 50 ff ff ff e8 e6 62 fa
> [ 3142.656017] RIP  [<ffffffffa006fe74>] btrfs_log_inode+0x554/0x600 [btrfs]
> [ 3142.656017]  RSP <ffff88005c801d58>
> [ 3142.995743] ---[ end trace 81d2bc6c70d7ca63 ]---

for the record, exactly same crash at xfstets/256 (run from 215- on),
with "rm -f /mnt/a1/25365.falloc" stuck (D) at vfs_unlink


david
