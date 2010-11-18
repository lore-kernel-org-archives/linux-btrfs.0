From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Thu, 18 Nov 2010 11:08:53 +0000
Message-ID: <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
	<m3r5ejyzz4.fsf@pullcord.laptop.org>
	<AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Ball <cjb@laptop.org>, linux-btrfs@vger.kernel.org
To: Brian Sullivan <bexamous@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18 November 2010 06:03, Brian Sullivan <bexamous@gmail.com> wrote:
> Nothing shows up in dmesg.
>
> [ 8114.870020] ls =A0 =A0 =A0 =A0 =A0 =A0R =A0running task =A0 =A0 =A0=
 =A00 =A03438 =A0 3375 0x00000004
> [ 8114.870020] =A0ffff88036339dab8 0000000000000086 ffff88036339da60
> ffff88036339dfd8
> [ 8114.870020] =A000000000000139c0 0000000000000000 ffff88036339dfd8
> ffff88036339dfd8
> [ 8114.870020] =A000000000000139c0 ffff88034f670398 ffff88034f6703a0
> ffff88034f670000
> [ 8114.870020] Call Trace:
> [ 8114.870020] =A0[<ffffffff8159f7b4>] ? schedule+0x224/0x660
> [ 8114.870020] =A0[<ffffffff815a01de>] schedule_timeout+0x19e/0x2e0
> [ 8114.870020] =A0[<ffffffff81057690>] enqueue_task_fair+0x50/0x60
> [ 8114.870020] =A0[<ffffffff8105d550>] enqueue_task+0x70/0xd0
> [ 8114.870020] =A0[<ffffffff8105e9be>] ? try_to_wake_up+0x18e/0x3f0
> [ 8114.870020] =A0[<ffffffff8105ec20>] ? default_wake_function+0x0/0x=
20
> [ 8114.870020] =A0[<ffffffff815a0196>] ? schedule_timeout+0x156/0x2e0
> [ 8114.870020] =A0[<ffffffff81181399>] ? writeback_inodes_sb_nr_if_id=
le+0x49/0x70
> [ 8114.870020] =A0[<ffffffffa0e84607>] ? shrink_delalloc+0x127/0x170 =
[btrfs]
> [ 8114.870020] =A0[<ffffffffa0e84727>] ? reserve_metadata_bytes+0xd7/=
0x1f0 [btrfs]
> [ 8114.870020] =A0[<ffffffffa0e84913>] ? btrfs_block_rsv_add+0x43/0x6=
0 [btrfs]
> [ 8114.870020] =A0[<ffffffff81085e00>] ? autoremove_wake_function+0x0=
/0x40
> [ 8114.870020] =A0[<ffffffffa0e8498b>] ?
> btrfs_trans_reserve_metadata+0x5b/0xa0 [btrfs]
> [ 8114.870020] =A0[<ffffffffa0e9a0be>] ? start_transaction+0xbe/0x210=
 [btrfs]
> [ 8114.870020] =A0[<ffffffff8116fa80>] ? filldir+0x0/0xf0
> [ 8114.870020] =A0[<ffffffffa0e9a423>] ? btrfs_start_transaction+0x13=
/0x20 [btrfs]
> [ 8114.870020] =A0[<ffffffffa0e9d3e8>] ? btrfs_dirty_inode+0x98/0x120=
 [btrfs]
> [ 8114.870020] =A0[<ffffffff8116fa80>] ? filldir+0x0/0xf0
> [ 8114.870020] =A0[<ffffffff81182d9a>] ? __mark_inode_dirty+0x3a/0x20=
0
> [ 8114.870020] =A0[<ffffffff811754f4>] ? touch_atime+0xf4/0x100
> [ 8114.870020] =A0[<ffffffff8116f92c>] ? vfs_readdir+0xcc/0xd0
> [ 8114.870020] =A0[<ffffffff8116f9ba>] ? sys_getdents+0x8a/0xe0
> [ 8114.870020] =A0[<ffffffff815a2515>] ? page_fault+0x25/0x30
> [ 8114.870020] =A0[<ffffffff8100c132>] ? system_call_fastpath+0x16/0x=
1b
> [ 8114.870020] flush-btrfs-1 R =A0running task =A0 =A0 =A0 =A00 =A034=
39 =A0 =A0 =A02 0x00000000
> [ 8114.870020] =A0ffff8803631c5e60 0000000000000046 ffff8803631c5e00
> 0000000000000000
> [ 8114.870020] =A0ffff8803631c5e20 00000000000139c0 ffff8803631c5fd8
> ffff8803631c5fd8
> [ 8114.870020] =A000000000000139c0 ffff8803507fd9b0 ffff8803631c5e60
> ffff880362205b00
> [ 8114.870020] Call Trace:
> [ 8114.870020] =A0[<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x2=
60
> [ 8114.870020] =A0[<ffffffff81182bb3>] bdi_writeback_thread+0xb3/0x26=
0
> [ 8114.870020] =A0[<ffffffff81182b00>] ? bdi_writeback_thread+0x0/0x2=
60
> [ 8114.870020] =A0[<ffffffff81085727>] kthread+0x97/0xa0
> [ 8114.870020] =A0[<ffffffff8100cf24>] kernel_thread_helper+0x4/0x10
> [ 8114.870020] =A0[<ffffffff81085690>] ? kthread+0x0/0xa0
> [ 8114.870020] =A0[<ffffffff8100cf20>] ? kernel_thread_helper+0x0/0x1=
0

Interesting. If you mount the filesystem with 'noatime,nodiratime' or
'ro', does it allow ls to return?

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
