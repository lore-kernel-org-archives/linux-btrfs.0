From: David Sterba <dave@jikos.cz>
Subject: Re: NOCOW + compress-force = bug
Date: Thu, 16 Feb 2012 15:30:23 +0100
Message-ID: <20120216143023.GC1046@twin.jikos.cz>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213141040.GG15350@twin.jikos.cz> <20120216195515.643f4aa7@natsu>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, dima <dolenin@parallels.com>,
	linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120216195515.643f4aa7@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 07:55:15PM +0600, Roman Mamedov wrote:
>   5813                 BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
> 
> I was unable to make netconsole work over a bridged interface, so can only
> post screenshots of this OOPS:
>   http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-1.jpg
>   http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-2.jpg
> 
> This happened four times already, and always on snapshot creation (but not
> every case). I have hourly snapshots in crontab, and only one case out of about
> ten fails with this problem. Did not try to deliberately reproduce it yet by
> manually making snapshots very often, etc.

I've hit a different bug with

* a process doing random reads/writes to a file
* looped toggling of NOCOW flag on the file every 10 seconds
* snapshotting of the fs every 10 seconds

and it triggered after a few minutes. It's an ENOSPC at

920         btrfs_i_size_write(parent_inode, parent_inode->i_size +
921                                          dentry->d_name.len * 2);
922         ret = btrfs_update_inode(trans, parent_root, parent_inode);
923         BUG_ON(ret);


[49220.539979] ------------[ cut here ]------------
[49220.543580] kernel BUG at fs/btrfs/transaction.c:923!
[49220.543580] invalid opcode: 0000 [#1] SMP
[49220.543580] CPU 0
[49220.543580] Modules linked in: btrfs aoe [last unloaded: btrfs]
[49220.543580]
[49220.543580] Pid: 12646, comm: btrfs Not tainted 3.2.0-default+ #114 Intel Corporation Santa Rosa platform/Matanzas
[49220.543580] RIP: 0010:[<ffffffffa01086da>]  [<ffffffffa01086da>] create_pending_snapshot+0x4ca/0x4d0 [btrfs]
[49220.543580] RSP: 0018:ffff880000869b48  EFLAGS: 00010286
[49220.543580] RAX: 00000000ffffffe4 RBX: ffff8800191afdf8 RCX: ffff88000e8679d8
[49220.543580] RDX: ffff88006cddd440 RSI: ffffffff8187d42d RDI: 0000000000000246
[49220.543580] RBP: ffff880000869c08 R08: 0000000000000000 R09: 0000000000000000
[49220.543580] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800347b6740
[49220.543580] R13: ffff880054eb5180 R14: ffff880062b56000 R15: ffff880078f45510
[49220.543580] FS:  00007f6637f5c740(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[49220.543580] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[49220.543580] CR2: 00007f80a26c7000 CR3: 000000001edad000 CR4: 00000000000006f0
[49220.543580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[49220.543580] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[49220.543580] Process btrfs (pid: 12646, threadinfo ffff880000868000, task ffff88006cddd440)
[49220.543580] Stack:
[49220.543580]  ffff880000000002 0000000000000083 ffff880078394000 ffff8800105d8390
[49220.543580]  ffff88001016bcd0 ffff880062b56000 ffff88007a15e070 ffff8800105d8390
[49220.543580]  ffff880079c14000 ffff8800347b6758 0000000000000175 ffffffffffffff84
[49220.543580] Call Trace:
[49220.543580]  [<ffffffffa00e65fa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[49220.543580]  [<ffffffffa0108726>] create_pending_snapshots+0x46/0x70 [btrfs]
[49220.543580]  [<ffffffffa0109a57>] btrfs_commit_transaction+0x3e7/0x8d0 [btrfs]
[49220.543580]  [<ffffffff81077aa0>] ? wake_up_bit+0x40/0x40
[49220.543580]  [<ffffffff81357eee>] ? do_raw_spin_unlock+0x5e/0xb0
[49220.543580]  [<ffffffffa0139e48>] btrfs_mksubvol+0x358/0x360 [btrfs]
[49220.543580]  [<ffffffffa0139f50>] btrfs_ioctl_snap_create_transid+0x100/0x160 [btrfs]
[49220.543580]  [<ffffffff81113f73>] ? might_fault+0x53/0xb0
[49220.543580]  [<ffffffffa013a12d>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
[49220.543580]  [<ffffffffa013ba47>] btrfs_ioctl+0x4a7/0x1270 [btrfs]
[49220.543580]  [<ffffffff81883400>] ? do_page_fault+0x2d0/0x580
[49220.543580]  [<ffffffff8187f150>] ? _raw_spin_unlock_irq+0x30/0x50
[49220.543580]  [<ffffffff8103ff23>] ? finish_task_switch+0x83/0xf0
[49220.543580]  [<ffffffff8103fee6>] ? finish_task_switch+0x46/0xf0
[49220.543580]  [<ffffffff8114d5e8>] do_vfs_ioctl+0x98/0x560
[49220.543580]  [<ffffffff8108b7a9>] ? trace_hardirqs_off_caller+0x29/0xc0
[49220.543580]  [<ffffffff8187f919>] ? retint_swapgs+0x13/0x1b
[49220.543580]  [<ffffffff8114daff>] sys_ioctl+0x4f/0x80
[49220.543580]  [<ffffffff81887c02>] system_call_fastpath+0x16/0x1b
[49220.543580] Code: 75 fd ff ff 0f 1f 44 00 00 0f b7 16 83 e8 02 48 83 c6 02 66 89 17 48 83 c7 02 e9 64 fd ff ff 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b <0f> 0b 0f 1f 40 00 55 48 89 e5 41 56 41 55 41 54 53 66 66 66 66
[49220.543580] RIP  [<ffffffffa01086da>] create_pending_snapshot+0x4ca/0x4d0 [btrfs]
[49220.543580]  RSP <ffff880000869b48>
[49220.937724] ---[ end trace 8f8b8a074f8e75d4 ]---
