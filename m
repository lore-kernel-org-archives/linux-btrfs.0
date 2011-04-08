From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: 2.6.29-rc2 oops and assertion failure...
Date: Fri, 8 Apr 2011 10:26:52 +0800
Message-ID: <BANLkTinm0eNdDWH42MB6VnYAdOOGi0P-bw@mail.gmail.com>
References: <BANLkTikJJFqEs0F_wPdTinct0k_4uLh1hQ@mail.gmail.com>
	<4D9DE4F2.1050909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9DE4F2.1050909@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef, Chris,

On 8 April 2011 00:23, Josef Bacik <josef@redhat.com> wrote:
> On 04/07/2011 03:21 AM, Daniel J Blueman wrote:
>>
>> When running a practical stress-test on 2.6.29-rc2 trying to reproduce
>> an older (extent refcounting) issue, I am consistently able to hit an
>> oops [] and an assertion failure [].
>
> Sorry about that, please apply the patch I just sent this morning
>
> [PATCH] Btrfs: deal with the case that we run out of space in the cache

Superb work - the btrfs_write_out_cache oops is addressed, so now we
(separately) hit a few other assertions at: volumes.c:2013 [1],
volumes.c:2063 [2] and volumes.c:2703 [3] with the previous
reproducer.

Let me know if adding any debugging or other testing may be useful.

Thanks,
  Daniel

--- [1]

kernel BUG at fs/btrfs/volumes.c:2013!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/block/ram7/removable
CPU 0
Modules linked in: ppp_generic slhc tun brd loop

Pid: 17040, comm: btrfs Tainted: G        W   2.6.39-rc2-350cd+ #3
Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff812c214b>]  [<ffffffff812c214b>] btrfs_balance+0x27b/0x280
RSP: 0018:ffff88015c923e08  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff880301d6e1b0 RCX: 0000000000000040
RDX: 00000000fffffffb RSI: 0000000000000000 RDI: ffffffff8112e425
RBP: ffff88015c923e88 R08: 0000000000000000 R09: ffff8802f8ee53f0
R10: 0000000000000012 R11: 0000000000000098 R12: ffff8802f909a490
R13: ffff8802f909bc38 R14: 0000000010000000 R15: 00007fffd1599ce0
FS:  00007f3c4b6f4740(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000f00098 CR3: 000000015c921000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 17040, threadinfo ffff88015c922000, task ffff88030b898000)
Stack:
 ffff880307cd5498 ffff880301d6c120 ffff88015c923e38 ffffffff81085b9e
 ffff880308a5d700 0000000000000008 ffff88015c923f48 ffffffff81031d5c
 ffffea000a9e7b40 ffff88015c923f58 ffff88030b898000 ffff88015c8aa300
Call Trace:
 [<ffffffff81085b9e>] ? up_read+0x1e/0x40
 [<ffffffff81031d5c>] ? do_page_fault+0x1cc/0x440
 [<ffffffff812c9ec0>] btrfs_ioctl+0x450/0x590
 [<ffffffff81152e8d>] do_vfs_ioctl+0x8d/0x330
 [<ffffffff81141444>] ? fget_light+0x274/0x3c0
 [<ffffffff81106cc0>] ? __do_fault+0x150/0x5d0
 [<ffffffff8115317a>] sys_ioctl+0x4a/0x80
 [<ffffffff8170a03b>] system_call_fastpath+0x16/0x1b
Code: 81 c7 d8 22 00 00 e8 05 4b 44 00 8b 45 80 e9 e7 fd ff ff 31 c0
eb d2 85 c0 74 a7 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f>
0b eb fe 90 55 48 89 e5 48 83 ec 40 8b 05 e2 62 72 00 4c 89
RIP  [<ffffffff812c214b>] btrfs_balance+0x27b/0x280
 RSP <ffff88015c923e08>

--- [2]

kernel BUG at fs/btrfs/volumes.c:2063!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/block/ram7/removable
CPU 0
Modules linked in: brd loop

Pid: 13460, comm: btrfs Tainted: G        W   2.6.39-rc2-350cd+ #3
Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff812c213b>]  [<ffffffff812c213b>] btrfs_balance+0x26b/0x280
RSP: 0018:ffff8800b1827e08  EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff88030934d168 RCX: 0000000000000006
RDX: 00000000fffffffb RSI: ffff880308fc06f0 RDI: ffff880308fc0000
RBP: ffff8800b1827e88 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802ff5455e8
R13: ffff8800b1827e38 R14: 000000010d560000 R15: ffff8800b1827e18
FS:  00007fce737e5740(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002371688 CR3: 00000000b1ff8000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 13460, threadinfo ffff8800b1826000, task ffff880308fc0000)
Stack:
 0000000000000100 ffff88030934e1b0 0000000000000100 0000010d560000e4
 ffff880308837a00 0000000000000008 0000000000000100 00000113bbffffe4
 ffff880308fc0600 ffff8800b1827f58 ffff880308fc0000 ffff8801f8c56c00
Call Trace:
 [<ffffffff812c9ec0>] btrfs_ioctl+0x450/0x590
 [<ffffffff81152e8d>] do_vfs_ioctl+0x8d/0x330
 [<ffffffff8114148f>] ? fget_light+0x2bf/0x3c0
 [<ffffffff8109629d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8115317a>] sys_ioctl+0x4a/0x80
 [<ffffffff8170a03b>] system_call_fastpath+0x16/0x1b
Code: 7c 90 fb ff 48 8b 55 88 48 8b ba 58 01 00 00 48 81 c7 d8 22 00
00 e8 05 4b 44 00 8b 45 80 e9 e7 fd ff ff 31 c0 eb d2 85 c0 74 a7 <0f>
0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 90
RIP  [<ffffffff812c213b>] btrfs_balance+0x26b/0x280
 RSP <ffff8800b1827e08>

--- [3]

kernel BUG at fs/btrfs/volumes.c:2703!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uevent
CPU 0
Modules linked in: brd loop

Pid: 14333, comm: btrfs-delalloc- Tainted: G        W
2.6.39-rc2-350cd+ #3 Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff812c08c2>]  [<ffffffff812c08c2>]
__finish_chunk_alloc+0x212/0x220
RSP: 0018:ffff8803007e7af0  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff88024e54e000 RCX: 0000000000000040
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8112e425
RBP: ffff8803007e7b70 R08: 0000000000000000 R09: ffff8803072fe168
R10: 0000000000000012 R11: 0000000000000098 R12: ffff880303c192a8
R13: ffff88020a461e70 R14: ffff8801c2632090 R15: 00000000000000b0
FS:  0000000000000000(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002953c98 CR3: 00000002fdfd3000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-delalloc- (pid: 14333, threadinfo ffff8803007e6000, task
ffff880308ccc020)
Stack:
 00000002007e7b70 0000000000000003 00000000006e0000 000000007ffc0000
 ffff8801c2634120 0000000000370000 0000000000000100 0000007ffc0000e4
 0000000000370000 ffff88024e54e000 0000000000000246 ffff8801c2632090
Call Trace:
 [<ffffffff812c3d0e>] btrfs_alloc_chunk+0x8e/0xa0
 [<ffffffff81281ed6>] do_chunk_alloc+0x1b6/0x280
 [<ffffffff812844e4>] btrfs_reserve_extent+0xb4/0x170
 [<ffffffff81706c39>] ? mutex_unlock+0x9/0x10
 [<ffffffff812980c7>] ? start_transaction+0x247/0x2b0
 [<ffffffff8129db9e>] submit_compressed_extents+0xfe/0x460
 [<ffffffff810506b1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8129df7f>] async_cow_submit+0x7f/0x90
 [<ffffffff812c452b>] run_ordered_completions+0x7b/0xc0
 [<ffffffff812c4f9c>] worker_loop+0x16c/0x3c0
 [<ffffffff812c4e30>] ? check_pending_worker_creates+0xd0/0xd0
 [<ffffffff81080596>] kthread+0xb6/0xc0
 [<ffffffff8170b194>] kernel_thread_helper+0x4/0x10
 [<ffffffff81055718>] ? finish_task_switch+0x78/0x110
 [<ffffffff817098c4>] ? retint_restore_args+0xe/0xe
 [<ffffffff810804e0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8170b190>] ? gs_change+0xb/0xb
Code: 1d 07 00 44 89 a3 58 07 00 00 4c 89 ef e8 c7 ef e6 ff 31 c0 48
83 c4 58 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 0b eb fe 0f 0b eb fe <0f>
0b eb fe eb 08 90 90 90 90 90 90 90 90 55 49 89 ca 48 89 e5
RIP  [<ffffffff812c08c2>] __finish_chunk_alloc+0x212/0x220
 RSP <ffff8803007e7af0>
-- 
Daniel J Blueman
