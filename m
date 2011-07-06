From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [BUG] delayed inodes and reflinks
Date: Wed, 06 Jul 2011 10:15:25 +0800
Message-ID: <4E13C53D.7000201@cn.fujitsu.com>
References: <4E1310B8.40706@jan-o-sch.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1310B8.40706@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 05 Jul 2011 15:25:12 +0200, Jan Schmidt wrote:
> I hit this bug an hour ago while executing some cp --reflink:
> 
> Jul  5 13:54:02 oglaroon kernel: [ 2654.545244] ------------[ cut here
> ]------------
> Jul  5 13:54:02 oglaroon kernel: [ 2654.600508] kernel BUG at
> fs/btrfs/delayed-inode.c:1637!
[SNIP]
> Jul  5 13:54:02 oglaroon kernel: [ 2656.485403] Call Trace:
> Jul  5 13:54:02 oglaroon kernel: [ 2656.514742]  [<ffffffffa01db4de>]
> btrfs_update_inode+0x3e/0x150 [btrfs]
> Jul  5 13:54:02 oglaroon kernel: [ 2656.593884]  [<ffffffffa0209160>]
> btrfs_ioctl_clone+0x9e0/0xca0 [btrfs]
> Jul  5 13:54:02 oglaroon kernel: [ 2656.673022]  [<ffffffff81151f00>] ?
> might_fault+0x40/0xa0
> Jul  5 13:54:02 oglaroon kernel: [ 2656.737613]  [<ffffffffa0209b05>]
> btrfs_ioctl+0x335/0xf70 [btrfs]
> Jul  5 13:54:02 oglaroon kernel: [ 2656.810612]  [<ffffffff81151f57>] ?
> might_fault+0x97/0xa0
> Jul  5 13:54:02 oglaroon kernel: [ 2656.875198]  [<ffffffff81151f0e>] ?
> might_fault+0x4e/0xa0
> Jul  5 13:54:02 oglaroon kernel: [ 2656.939782]  [<ffffffff81859006>] ?
> _raw_spin_unlock+0x26/0x30
> Jul  5 13:54:02 oglaroon kernel: [ 2657.009567]  [<ffffffff8117fcd3>] ?
> cp_new_stat+0xf3/0x110
> Jul  5 13:54:02 oglaroon kernel: [ 2657.075325]  [<ffffffff8118cb5c>]
> do_vfs_ioctl+0x9c/0x560
> Jul  5 13:54:02 oglaroon kernel: [ 2657.139982]  [<ffffffff818607ac>] ?
> sysret_check+0x27/0x62
> Jul  5 13:54:02 oglaroon kernel: [ 2657.205604]  [<ffffffff8118d0b9>]
> sys_ioctl+0x99/0xa0
> Jul  5 13:54:02 oglaroon kernel: [ 2657.266133]  [<ffffffff8186077b>]
> system_call_fastpath+0x16/0x1b
> Jul  5 13:54:02 oglaroon kernel: [ 2657.337995] Code: f8 05 00 00 8d 0c
> 49 48 89 ca 48 89 4d c8 e8 c8 c7 f9 ff 85 c0 48 8b 4d c8 75 10 48 89 4b
> 08 e9 3d ff ff ff 0f 1f 80 00 00 00 00 <0f> 0b eb fe 66 66 66 2e 0f 1f
> 84 00 00 00 00 00 55 48 89 e5 41
> Jul  5 13:54:02 oglaroon kernel: [ 2657.570642] RIP
> [<ffffffffa0222490>] btrfs_delayed_update_inode+0x120/0x130 [btrfs]
> Jul  5 13:54:02 oglaroon kernel: [ 2657.663516]  RSP <ffff88023010dbd8>
> Jul  5 13:54:02 oglaroon kernel: [ 2657.705561] ---[ end trace
> 0ae6cc23c8022b5b ]---
> 
> I was testing some completely different modifications I made myself, but
> I'm quite certain that my changes did not trigger this error. With the
> fs I could reproducably get to this bug by creating 10 reflinks of a
> certain file in a shell loop.
> 
> I lost the file system while trying to setup a clean, tight test case.
> The fs I used had something like 50 files, some reflinks and a snapshot
> with some files deleted. The tree had explicit backrefs and shared backrefs.
> 
> Anyway, I could not setup a new file system triggering this bug. The
> line that triggered is the BUG_ON in btrfs_delayed_update_inode (line
> 1693 in for-linus branch). We seem to have missed some reservation in
> some special case. The patch Miao sent some days ago does not
> interrelate at first sight.

I think you are right. btrfs_ioctl_clone() didn't reserve enough space because
we need reserve space for 3 items at least not 1 item:

  1 for old extents that will be dropped(in the some case, we may need more)
  1 for the new extent
  1 for the i-node

Maybe we need search the fs tree and find how many old extent need be dropped
and then reserve free space accurately

Thanks
Miao

> 
> If I get back to a situation where I can reproduce the bug, I'll send a
> follow up.
> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

