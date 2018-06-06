Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932552AbeFFQMb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 12:12:31 -0400
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
To: syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>, clm@fb.com,
        dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000096009b056df92dc1@google.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <70a3c2d1-3f53-d4c0-13b3-29f836ec46d9@oracle.com>
Date: Thu, 7 Jun 2018 00:15:04 +0800
MIME-Version: 1.0
In-Reply-To: <00000000000096009b056df92dc1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/06/2018 09:31 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of 
> git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f700af800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=5b658d997a83984507a6
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com
> 
> RDX: 0000000020000080 RSI: 0000000020000040 RDI: 00007f787067fbf0
> RBP: 0000000000000001 R08: 00000000200000c0 R09: 0000000020000080
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000014
> R13: 0000000000000001 R14: 0000000000700008 R15: 0000000000000043
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/volumes.c:1032!
> invalid opcode: 0000 [#1] SMP KASAN
> CPU: 1 PID: 22303 Comm: syz-executor1 Not tainted 4.17.0+ #86
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> RIP: 0010:btrfs_prepare_close_one_device fs/btrfs/volumes.c:1032 [inline]

btrfs_prepare_close_one_device()
::
1031           name = rcu_string_strdup(device->name->str, GFP_NOFS);
1032           BUG_ON(!name); /* -ENOMEM */

The way we close our devices needs new memory allocations
at the time of device close. By doing this apart from the BUG_ON
reported here, there _were_ other complications like managing the sysfs
links and moving them to the newly allocated btrfs_fs_devices.
So sometime back I attempted to correct this approach to a simple
device close without fresh allocation, however it wasn't successful.
I am going to try that again, but its not p1.

Thanks, Anand


> RIP: 0010:close_fs_devices+0xba7/0xfa0 fs/btrfs/volumes.c:1052
> Code: 56 18 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 2b 03 00 00 49 83 6c 
> 24 30 01 e9 25 f8 ff ff e8 90 f4 b3 fe 0f 0b e8 89 f4 b3 fe <0f> 0b 48 
> 89 f7 e8 ef 64 f0 fe e9 f6 f5 ff ff e8 75 f4 b3 fe 0f 0b
> RSP: 0018:ffff8801af6ff050 EFLAGS: 00010246
> RAX: 0000000000040000 RBX: dffffc0000000000 RCX: ffffc9000c70c000
> RDX: 0000000000040000 RSI: ffffffff82c56437 RDI: 0000000000000286
> RBP: ffff8801af6ff350 R08: ffffed003b5e46d7 R09: ffffed003b5e46d6
> R10: ffffed003b5e46d6 R11: ffff8801daf236b3 R12: ffff8801c58ac190
> R13: 0000000000000000 R14: ffff8801b1a6a940 R15: ffff8801b4d7d680
> FS:  00007f7870680700(0000) GS:ffff8801daf00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000704094 CR3: 00000001c51e8000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   btrfs_close_devices+0x29/0x150 fs/btrfs/volumes.c:1085
>   btrfs_mount_root+0x1419/0x1e70 fs/btrfs/super.c:1610
>   mount_fs+0xae/0x328 fs/super.c:1277
>   vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
>   vfs_kern_mount+0x40/0x60 fs/namespace.c:1027
>   btrfs_mount+0x4a1/0x213e fs/btrfs/super.c:1661
>   mount_fs+0xae/0x328 fs/super.c:1277
>   vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
>   vfs_kern_mount fs/namespace.c:1027 [inline]
>   do_new_mount fs/namespace.c:2518 [inline]
>   do_mount+0x564/0x30b0 fs/namespace.c:2848
>   ksys_mount+0x12d/0x140 fs/namespace.c:3064
>   __do_sys_mount fs/namespace.c:3078 [inline]
>   __se_sys_mount fs/namespace.c:3075 [inline]
>   __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
>   do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45843a
> Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 dd 8f fb ff c3 66 2e 
> 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 
> f0 ff ff 0f 83 ba 8f fb ff c3 66 0f 1f 84 00 00 00 00 00
> RSP: 002b:00007f787067fba8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000020000080 RCX: 000000000045843a
> RDX: 0000000020000080 RSI: 0000000020000040 RDI: 00007f787067fbf0
> RBP: 0000000000000001 R08: 00000000200000c0 R09: 0000000020000080
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000014
> R13: 0000000000000001 R14: 0000000000700008 R15: 0000000000000043
> Modules linked in:
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> ---[ end trace 383b0406a01f2edd ]---
> RIP: 0010:btrfs_prepare_close_one_device fs/btrfs/volumes.c:1032 [inline]
> RIP: 0010:close_fs_devices+0xba7/0xfa0 fs/btrfs/volumes.c:1052
> Code: 56 18 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 2b 03 00 00 49 83 6c 
> 24 30 01 e9 25 f8 ff ff e8 90 f4 b3 fe 0f 0b e8 89 f4 b3 fe <0f> 0b 48 
> 89 f7 e8 ef 64 f0 fe e9 f6 f5 ff ff e8 75 f4 b3 fe 0f 0b
> RSP: 0018:ffff8801af6ff050 EFLAGS: 00010246
> RAX: 0000000000040000 RBX: dffffc0000000000 RCX: ffffc9000c70c000
> RDX: 0000000000040000 RSI: ffffffff82c56437 RDI: 0000000000000286
> RBP: ffff8801af6ff350 R08: ffffed003b5e46d7 R09: ffffed003b5e46d6
> R10: ffffed003b5e46d6 R11: ffff8801daf236b3 R12: ffff8801c58ac190
> R13: 0000000000000000 R14: ffff8801b1a6a940 R15: ffff8801b4d7d680
> FS:  00007f7870680700(0000) GS:ffff8801daf00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000704094 CR3: 00000001c51e8000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with 
> syzbot.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
