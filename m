From: Brian Sullivan <bexamous@gmail.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Thu, 18 Nov 2010 10:30:51 -0800
Message-ID: <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
 <m3r5ejyzz4.fsf@pullcord.laptop.org> <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
 <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Ball <cjb@laptop.org>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yep actually, with noatime,nodiratime ls is fine.  I didn't try ro but
I assume that'll work too.  So with noatime,nodiratime I can go around
in tree and ls works.  If I try to touch a new file, touch doesn't
return.  If I then ls in that same folder ls doesn't return either.
So yeah seems like soon as something has to write.

Also after I run touch, it doesn't return, I look at top, nothing is
spinning, everything is at 0% usage.  After a minute or so then touch
and flush-btrfs-1 jump to 50%sys each and sit there.

Think this was just before they went to 50% usage and were still sittin=
g at 0:
[  420.110021] touch         S ffff8803646c9a58     0  3337   3252 0x00=
000000
[  420.110021]  ffff8803416c9a28 0000000000000086 0000000000000000
ffff8803416c9fd8
[  420.110021]  00000000000139c0 00000000000139c0 ffff8803416c9fd8
ffff8803416c9fd8
[  420.110021]  00000000000139c0 ffff8803646c9a58 ffff8803646c9a60
ffff8803646c96c0
[  420.110021] Call Trace:
[  420.110021]  [<ffffffff815a0196>] schedule_timeout+0x156/0x2e0
[  420.110021]  [<ffffffff810733b0>] ? process_timeout+0x0/0x10
[  420.110021]  [<ffffffffa0dbe607>] shrink_delalloc+0x127/0x170 [btrfs=
]
[  420.110021]  [<ffffffffa0dbe727>] reserve_metadata_bytes+0xd7/0x1f0 =
[btrfs]
[  420.110021]  [<ffffffffa0dbe913>] btrfs_block_rsv_add+0x43/0x60 [btr=
fs]
[  420.110021]  [<ffffffffa0dbe98b>]
btrfs_trans_reserve_metadata+0x5b/0xa0 [btrfs]
[  420.110021]  [<ffffffffa0dd40be>] start_transaction+0xbe/0x210 [btrf=
s]
[  420.110021]  [<ffffffffa0dd4423>] btrfs_start_transaction+0x13/0x20 =
[btrfs]
[  420.110021]  [<ffffffffa0dda8a4>] btrfs_create+0x84/0x220 [btrfs]
[  420.110021]  [<ffffffff81168c94>] ? generic_permission+0x24/0xc0
[  420.110021]  [<ffffffff8116a7a8>] vfs_create+0xb8/0x110
[  420.110021]  [<ffffffff8116a870>] __open_namei_create+0x70/0x100
[  420.110021]  [<ffffffff8116b366>] do_last+0x486/0x4e0
[  420.110021]  [<ffffffff8116c27e>] do_filp_open+0x25e/0x620
[  420.110021]  [<ffffffff812d5e37>] ? __strncpy_from_user+0x27/0x60
[  420.110021]  [<ffffffff815a1bde>] ? _raw_spin_lock+0xe/0x20
[  420.110021]  [<ffffffff811786e6>] ? alloc_fd+0x116/0x140
[  420.110021]  [<ffffffff8115caaa>] do_sys_open+0x6a/0x110
[  420.110021]  [<ffffffff8115cb90>] sys_open+0x20/0x30
[  420.110021]  [<ffffffff8100c132>] system_call_fastpath+0x16/0x1b
[  420.110021] ls            D ffff8803655347d8     0  3355   3270 0x00=
000004
[  420.110021]  ffff880362b47e58 0000000000000086 ffff880362b47e38
ffff880362b47fd8
[  420.110021]  00000000000139c0 00000000000139c0 ffff880362b47fd8
ffff880362b47fd8
[  420.110021]  00000000000139c0 ffff8803655347d8 ffff8803655347e0
ffff880365534440
[  420.110021] Call Trace:
[  420.110021]  [<ffffffff815a0849>] __mutex_lock_killable_slowpath+0xf=
9/0x1b0
[  420.110021]  [<ffffffff8116fa80>] ? filldir+0x0/0xf0
[  420.110021]  [<ffffffff815a0948>] mutex_lock_killable+0x48/0x60
[  420.110021]  [<ffffffff8116f8e2>] vfs_readdir+0x82/0xd0
[  420.110021]  [<ffffffff8116f9ba>] sys_getdents+0x8a/0xe0
[  420.110021]  [<ffffffff815a2515>] ? page_fault+0x25/0x30
[  420.110021]  [<ffffffff8100c132>] system_call_fastpath+0x16/0x1b


On Thu, Nov 18, 2010 at 3:08 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On 18 November 2010 06:03, Brian Sullivan <bexamous@gmail.com> wrote:
>> Nothing shows up in dmesg.
>>
>> [ 8114.870020] ls =A0 =A0 =A0 =A0 =A0 =A0R =A0running task =A0 =A0 =A0=
 =A00 =A03438 =A0 3375 0x00000004
>> [ 8114.870020] =A0ffff88036339dab8 0000000000000086 ffff88036339da60
>> ffff88036339dfd8
>> [ 8114.870020] =A000000000000139c0 0000000000000000 ffff88036339dfd8
>> ffff88036339dfd8
>> [ 8114.870020] =A000000000000139c0 ffff88034f670398 ffff88034f6703a0
>> ffff88034f670000
>> [ 8114.870020] Call Trace:
>> [ 8114.870020] =A0[<ffffffff8159f7b4>] ? schedule+0x224/0x660
>> [ 8114.870020] =A0[<ffffffff815a01de>] schedule_timeout+0x19e/0x2e0
>> [ 8114.870020] =A0[<ffffffff81057690>] enqueue_task_fair+0x50/0x60
>> [ 8114.870020] =A0[<ffffffff8105d550>] enqueue_task+0x70/0xd0
>> [ 8114.870020] =A0[<ffffffff8105e9be>] ? try_to_wake_up+0x18e/0x3f0
>> [ 8114.870020] =A0[<ffffffff8105ec20>] ? default_wake_function+0x0/0=
x20
>> [ 8114.870020] =A0[<ffffffff815a0196>] ? schedule_timeout+0x156/0x2e=
0
>> [ 8114.870020] =A0[<ffffffff81181399>] ? writeback_inodes_sb_nr_if_i=
dle+0x49/0x70
>> [ 8114.870020] =A0[<ffffffffa0e84607>] ? shrink_delalloc+0x127/0x170=
 [btrfs]
>> [ 8114.870020] =A0[<ffffffffa0e84727>] ? reserve_metadata_bytes+0xd7=
/0x1f0 [btrfs]
>> [ 8114.870020] =A0[<ffffffffa0e84913>] ? btrfs_block_rsv_add+0x43/0x=
60 [btrfs]
>> [ 8114.870020] =A0[<ffffffff81085e00>] ? autoremove_wake_function+0x=
0/0x40
>> [ 8114.870020] =A0[<ffffffffa0e8498b>] ?
>> btrfs_trans_reserve_metadata+0x5b/0xa0 [btrfs]
>> [ 8114.870020] =A0[<ffffffffa0e9a0be>] ? start_transaction+0xbe/0x21=
0 [btrfs]
>> [ 8114.870020] =A0[<ffffffff8116fa80>] ? filldir+0x0/0xf0
>> [ 8114.870020] =A0[<ffffffffa0e9a423>] ? btrfs_start_transaction+0x1=
3/0x20 [btrfs]
>> [ 8114.870020] =A0[<ffffffffa0e9d3e8>] ? btrfs_dirty_inode+0x98/0x12=
0 [btrfs]
>> [ 8114.870020] =A0[<ffffffff8116fa80>] ? filldir+0x0/0xf0
>> [ 8114.870020] =A0[<ffffffff81182d9a>] ? __mark_inode_dirty+0x3a/0x2=
00
>> [ 8114.870020] =A0[<ffffffff811754f4>] ? touch_atime+0xf4/0x100
>> [ 8114.870020] =A0[<ffffffff8116f92c>] ? vfs_readdir+0xcc/0xd0
>> [ 8114.870020] =A0[<ffffffff8116f9ba>] ? sys_getdents+0x8a/0xe0
>> [ 8114.870020] =A0[<ffffffff815a2515>] ? page_fault+0x25/0x30
>> [ 8114.870020] =A0[<ffffffff8100c132>] ? system_call_fastpath+0x16/0=
x1b
>> [ 8114.870020] flush-btrfs-1 R =A0running task =A0 =A0 =A0 =A00 =A03=
439 =A0 =A0 =A02 0x00000000
>> [ 8114.870020] =A0ffff8803631c5e60 0000000000000046 ffff8803631c5e00
>> 0000000000000000
>> [ 8114.870020] =A0ffff8803631c5e20 00000000000139c0 ffff8803631c5fd8
>> ffff8803631c5fd8
>> [ 8114.870020] =A000000000000139c0 ffff8803507fd9b0 ffff8803631c5e60
>> ffff880362205b00
>> [ 8114.870020] Call Trace:
>> [ 8114.870020] =A0[<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x=
260
>> [ 8114.870020] =A0[<ffffffff81182bb3>] bdi_writeback_thread+0xb3/0x2=
60
>> [ 8114.870020] =A0[<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x=
260
>> [ 8114.870020] =A0[<ffffffff81085727>] kthread+0x97/0xa0
>> [ 8114.870020] =A0[<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
>> [ 8114.870020] =A0[<ffffffff81085690>] ? kthread+0x0/0xa0
>> [ 8114.870020] =A0[<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x=
10
>
> Interesting. If you mount the filesystem with 'noatime,nodiratime' or
> 'ro', does it allow ls to return?
>
> Daniel
> --
> Daniel J Blueman
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
