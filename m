Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f199.google.com ([209.85.223.199]:35163 "EHLO
        mail-io0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeFFNRD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 09:17:03 -0400
Received: by mail-io0-f199.google.com with SMTP id r16-v6so4824453ioj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jun 2018 06:17:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 06 Jun 2018 06:17:02 -0700
Message-ID: <000000000000832e70056df8fb38@google.com>
Subject: general protection fault in open_fs_devices
From: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1732a6f7800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
dashboard link: https://syzkaller.appspot.com/bug?extid=909a5177749d7990ffa4
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=16ba31f7800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d4ac8f800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com

random: sshd: uninitialized urandom read (32 bytes read)
BTRFS: device fsid ecf6f2a2-2997-48ae-b81e-1b00920efd9a devid 0 transid 0  
/dev/loop0
print_req_error: I/O error, dev loop1, sector 128
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
CPU: 0 PID: 4540 Comm: syz-executor962 Not tainted 4.17.0+ #86
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:open_fs_devices+0x7e8/0xc60 fs/btrfs/volumes.c:1124
Code: 48 8b 85 e0 fe ff ff 41 c7 87 14 01 00 00 01 00 00 00 48 8d b8 a0 00  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 01 04 00 00 48 8b 85 e0 fe ff ff 49 8d 7f 50 48
RSP: 0018:ffff8801d06971d8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffffff82c386af
RDX: 0000000000000014 RSI: ffffffff82c386bd RDI: 00000000000000a0
RBP: ffff8801d0697348 R08: ffff8801ad4fc580 R09: ffff8801d0697240
R10: ffffed003a0d2e5c R11: ffff8801d06972e7 R12: ffff8801ad4f8158
R13: ffff8801ad4f80d8 R14: dffffc0000000000 R15: ffff8801ad4f8080
FS:  00000000017dd880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ede000 CR3: 00000001adaac000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  btrfs_open_devices+0xc0/0xd0 fs/btrfs/volumes.c:1155
  btrfs_mount_root+0x91f/0x1e70 fs/btrfs/super.c:1568
  mount_fs+0xae/0x328 fs/super.c:1277
  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
  vfs_kern_mount+0x40/0x60 fs/namespace.c:1027
  btrfs_mount+0x4a1/0x213e fs/btrfs/super.c:1661
  mount_fs+0xae/0x328 fs/super.c:1277
  vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
  vfs_kern_mount fs/namespace.c:1027 [inline]
  do_new_mount fs/namespace.c:2518 [inline]
  do_mount+0x564/0x30b0 fs/namespace.c:2848
  ksys_mount+0x12d/0x140 fs/namespace.c:3064
  __do_sys_mount fs/namespace.c:3078 [inline]
  __se_sys_mount fs/namespace.c:3075 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4431fa
Code: b8 08 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 fd e5 fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 da e5 fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffc2d953358 EFLAGS: 00000297 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004431fa
RDX: 0000000020000080 RSI: 0000000020000040 RDI: 00007ffc2d953370
RBP: 0000000000000004 R08: 00000000200000c0 R09: 000000000000000a
R10: 0000000000000000 R11: 0000000000000297 R12: 000000000000000d
R13: 0000000008100000 R14: 0030656c69662f2e R15: fe03f80fe03f80ff
Modules linked in:
Dumping ftrace buffer:
    (ftrace buffer empty)
---[ end trace d8b96c29a3ffd356 ]---
RIP: 0010:open_fs_devices+0x7e8/0xc60 fs/btrfs/volumes.c:1124
Code: 48 8b 85 e0 fe ff ff 41 c7 87 14 01 00 00 01 00 00 00 48 8d b8 a0 00  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 01 04 00 00 48 8b 85 e0 fe ff ff 49 8d 7f 50 48
RSP: 0018:ffff8801d06971d8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: ffffffff82c386af
RDX: 0000000000000014 RSI: ffffffff82c386bd RDI: 00000000000000a0
RBP: ffff8801d0697348 R08: ffff8801ad4fc580 R09: ffff8801d0697240
R10: ffffed003a0d2e5c R11: ffff8801d06972e7 R12: ffff8801ad4f8158
R13: ffff8801ad4f80d8 R14: dffffc0000000000 R15: ffff8801ad4f8080
FS:  00000000017dd880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ede000 CR3: 00000001adaac000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
