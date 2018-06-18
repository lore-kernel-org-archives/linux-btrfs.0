Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58583 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966182AbeFRI0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:26:33 -0400
Subject: Re: general protection fault in find_device
From: Nikolay Borisov <nborisov@suse.com>
To: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e5da7e056ee43449@google.com>
 <45200a61-58c3-b7f0-d8e4-5108f8369ac5@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>
Message-ID: <98e49a53-3e8b-e38e-0cc8-0091a1689d15@suse.com>
Date: Mon, 18 Jun 2018 11:26:30 +0300
MIME-Version: 1.0
In-Reply-To: <45200a61-58c3-b7f0-d8e4-5108f8369ac5@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Actually adding Anand to CC, Anand see my analysis of the issue below
from previous email]

On 18.06.2018 10:03, Nikolay Borisov wrote:
> [Adding Anand to CC list since he's been doing devices-related work]
> 
> On 18.06.2018 08:55, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    ce397d215ccd Linux 4.18-rc1
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14e765f8400000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f390986c4f7cd566
>> dashboard link:
>> https://syzkaller.appspot.com/bug?extid=923aa93978c7ad27a9b1
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+923aa93978c7ad27a9b1@syzkaller.appspotmail.com
>>
>> kasan: CONFIG_KASAN_INLINE enabled
>> kasan: GPF could be caused by NULL-ptr deref or user memory access
>> general protection fault: 0000 [#1] SMP KASAN
>> CPU: 0 PID: 14460 Comm: syz-executor5 Not tainted 4.18.0-rc1+ #107
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> RIP: 0010:find_device+0x94/0x130 fs/btrfs/volumes.c:366
>> Code: 42 80 3c 28 00 0f 85 9d 00 00 00 48 8b 1b 4c 39 f3 0f 84 86 00 00
>> 00 e8 6a 79 b1 fe 48 8d bb c0 00 00 00 48 89 f8 48 c1 e8 03 <42> 80 3c
>> 28 00 75 70 4c 8b bb c0 00 00 00 4c 89 e6 4c 89 ff e8 f3
>> RSP: 0018:ffff8801d880ee70 EFLAGS: 00010206
>> RAX: 0000000000000018 RBX: 0000000000000000 RCX: ffffc9000d8a5000
>> RDX: 0000000000002d14 RSI: ffffffff82ca3136 RDI: 00000000000000c0
>> RBP: ffff8801d880eea8 R08: ffff8801abee0240 R09: fffffbfff123dea8
>> R10: ffff8801d880f178 R11: ffffffff891ef547 R12: 231f7dc339e55e1c
>> R13: dffffc0000000000 R14: ffff8801d7a65b98 R15: 0000000000000000
>> FS:  00007faa9dcb2700(0000) GS:ffff8801dae00000(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000000093002d CR3: 00000001bd208000 CR4: 00000000001406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  device_list_add+0x230/0x1530 fs/btrfs/volumes.c:771
>>  btrfs_scan_one_device+0x474/0xb00 fs/btrfs/volumes.c:1247
>>  btrfs_mount_root+0x3ae/0x1e90 fs/btrfs/super.c:1542
>>  mount_fs+0xae/0x328 fs/super.c:1277
>>  vfs_kern_mount.part.34+0xdc/0x4e0 fs/namespace.c:1037
>>  vfs_kern_mount+0x40/0x60 fs/namespace.c:1027
>>  btrfs_mount+0x4a9/0x215e fs/btrfs/super.c:1661
>>  mount_fs+0xae/0x328 fs/super.c:1277
>>  vfs_kern_mount.part.34+0xdc/0x4e0 fs/namespace.c:1037
>>  vfs_kern_mount fs/namespace.c:1027 [inline]
>>  do_new_mount fs/namespace.c:2518 [inline]
>>  do_mount+0x581/0x30e0 fs/namespace.c:2848
>>  ksys_mount+0x12d/0x140 fs/namespace.c:3064
>>  __do_sys_mount fs/namespace.c:3078 [inline]
>>  __se_sys_mount fs/namespace.c:3075 [inline]
>>  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3075
>>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x45855a
>> Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 dd 8f fb ff c3 66 2e
>> 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01
>> f0 ff ff 0f 83 ba 8f fb ff c3 66 0f 1f 84 00 00 00 00 00
>> RSP: 002b:00007faa9dcb1a88 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
>> RAX: ffffffffffffffda RBX: 0000000020000428 RCX: 000000000045855a
>> RDX: 00007faa9dcb1ad0 RSI: 00000000200000c0 RDI: 00007faa9dcb1af0
>> RBP: 0000000000000001 R08: 00007faa9dcb1b30 R09: 00007faa9dcb1ad0
>> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000013
>> R13: 0000000000000001 R14: 00000000004d2d78 R15: 0000000000000000
> 
> 
> So this suggests some inconsistency on fs_devices->devices list. On a
> quick look indeed it doesn't seem clear what the locking rules for this
> list are. In device_list_add in the !device case a device is added with
> fs_devices->device_list_Mutex held and using list_add_rcu. In the same
> function if we want to read the list ie invoke find_devices (because we
> have found an fsid) we are using plain list_for_each_entry (ie not the
> _rcu version and i don't see device_list_mutex being held while
> iterating the list). Additionally in btrfs_free_extra_devids the
> fs_devices->devices list is iterated with uuid_mutex being held and not
> device_list_mutex. In open_fs_devices we don't get any protection
> whatsoever while reading the list. Same thing in
> btrfs_find_next_active_device. If the list is supposed to be
> RCU-protected then the rules are:
> 
> 1. There needs to be an out of band (ie not RCU) mutual exclusion of
> modifiers
> 2. Iterating the list should use _rcu list primitives.
> 
> Currently I don't see those 2 invariants being enforced in every code path.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
