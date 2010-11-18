From: Brian Sullivan <bexamous@gmail.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Wed, 17 Nov 2010 22:03:03 -0800
Message-ID: <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com> <m3r5ejyzz4.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3r5ejyzz4.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Nothing shows up in dmesg.

[ 8114.870020] ls            R  running task        0  3438   3375 0x00=
000004
[ 8114.870020]  ffff88036339dab8 0000000000000086 ffff88036339da60
ffff88036339dfd8
[ 8114.870020]  00000000000139c0 0000000000000000 ffff88036339dfd8
ffff88036339dfd8
[ 8114.870020]  00000000000139c0 ffff88034f670398 ffff88034f6703a0
ffff88034f670000
[ 8114.870020] Call Trace:
[ 8114.870020]  [<ffffffff8159f7b4>] ? schedule+0x224/0x660
[ 8114.870020]  [<ffffffff815a01de>] schedule_timeout+0x19e/0x2e0
[ 8114.870020]  [<ffffffff81057690>] enqueue_task_fair+0x50/0x60
[ 8114.870020]  [<ffffffff8105d550>] enqueue_task+0x70/0xd0
[ 8114.870020]  [<ffffffff8105e9be>] ? try_to_wake_up+0x18e/0x3f0
[ 8114.870020]  [<ffffffff8105ec20>] ? default_wake_function+0x0/0x20
[ 8114.870020]  [<ffffffff815a0196>] ? schedule_timeout+0x156/0x2e0
[ 8114.870020]  [<ffffffff81181399>] ? writeback_inodes_sb_nr_if_idle+0=
x49/0x70
[ 8114.870020]  [<ffffffffa0e84607>] ? shrink_delalloc+0x127/0x170 [btr=
fs]
[ 8114.870020]  [<ffffffffa0e84727>] ? reserve_metadata_bytes+0xd7/0x1f=
0 [btrfs]
[ 8114.870020]  [<ffffffffa0e84913>] ? btrfs_block_rsv_add+0x43/0x60 [b=
trfs]
[ 8114.870020]  [<ffffffff81085e00>] ? autoremove_wake_function+0x0/0x4=
0
[ 8114.870020]  [<ffffffffa0e8498b>] ?
btrfs_trans_reserve_metadata+0x5b/0xa0 [btrfs]
[ 8114.870020]  [<ffffffffa0e9a0be>] ? start_transaction+0xbe/0x210 [bt=
rfs]
[ 8114.870020]  [<ffffffff8116fa80>] ? filldir+0x0/0xf0
[ 8114.870020]  [<ffffffffa0e9a423>] ? btrfs_start_transaction+0x13/0x2=
0 [btrfs]
[ 8114.870020]  [<ffffffffa0e9d3e8>] ? btrfs_dirty_inode+0x98/0x120 [bt=
rfs]
[ 8114.870020]  [<ffffffff8116fa80>] ? filldir+0x0/0xf0
[ 8114.870020]  [<ffffffff81182d9a>] ? __mark_inode_dirty+0x3a/0x200
[ 8114.870020]  [<ffffffff811754f4>] ? touch_atime+0xf4/0x100
[ 8114.870020]  [<ffffffff8116f92c>] ? vfs_readdir+0xcc/0xd0
[ 8114.870020]  [<ffffffff8116f9ba>] ? sys_getdents+0x8a/0xe0
[ 8114.870020]  [<ffffffff815a2515>] ? page_fault+0x25/0x30
[ 8114.870020]  [<ffffffff8100c132>] ? system_call_fastpath+0x16/0x1b
[ 8114.870020] flush-btrfs-1 R  running task        0  3439      2 0x00=
000000
[ 8114.870020]  ffff8803631c5e60 0000000000000046 ffff8803631c5e00
0000000000000000
[ 8114.870020]  ffff8803631c5e20 00000000000139c0 ffff8803631c5fd8
ffff8803631c5fd8
[ 8114.870020]  00000000000139c0 ffff8803507fd9b0 ffff8803631c5e60
ffff880362205b00
[ 8114.870020] Call Trace:
[ 8114.870020]  [<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x260
[ 8114.870020]  [<ffffffff81182bb3>] bdi_writeback_thread+0xb3/0x260
[ 8114.870020]  [<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x260
[ 8114.870020]  [<ffffffff81085727>] kthread+0x97/0xa0
[ 8114.870020]  [<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
[ 8114.870020]  [<ffffffff81085690>] ? kthread+0x0/0xa0
[ 8114.870020]  [<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x10


On Wed, Nov 17, 2010 at 9:15 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =A0 > Is doesn't return, I check top and both ls and flush-btrfs-1 ar=
e
> =A0 > sitting at ~50% sys usage each.
>
> Does anything new appear in dmesg when the hang happens? =A0Can you r=
un
> alt-sysrq-t (show tasks) and send us the output for the ls process?
>
> - Chris.
> --
> Chris Ball =A0 <cjb@laptop.org>
> One Laptop Per Child
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
