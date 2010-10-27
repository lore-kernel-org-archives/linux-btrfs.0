From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs hang (deadlock?) when trying to create a ext4 filesystem
 in KVM guest
Date: Wed, 27 Oct 2010 18:55:41 -0400
Message-ID: <20101027225541.GT27796@think>
References: <4CC82942.1020101@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC82942.1020101@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 27, 2010 at 03:29:38PM +0200, Tomasz Chmielewski wrote:
> There are a couple of problems when running KVM guests with images stored on btrfs filesystem.
> 
> One of them is inability to create a filesystem (i.e. ext4) in the guest:
> 
> - btrfs filesystem on the host was mounted with noatime,compress-force
> - guest was using a 50 GB sparse file,
> - attempt to create a ext4 filesystem within the guest does not succeed (hangs); host prints below messages in dmesg - some deadlock in btrfs?
> 
> kernel: 2.6.36
> qemu-kvm: 0.13.0

Is this the full dmesg output?  I think there are other messages hiding
in there.

Is this a single disk btrfs?

-chris

> 
> 
> [22748.830644] INFO: task qemu-system-x86:5186 blocked for more than 120 seconds.
> [22748.830649] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [22748.830653] qemu-system-x D ffff880001e34cc0     0  5186   4768 0x00000004
> [22748.830660]  ffff8801ed3f9b38 0000000000000086 ffff8801ed3f9fd8 0000000000014cc0
> [22748.830666]  0000000000014cc0 ffff8801ed3f9fd8 0000000000014cc0 ffff8801ed3f9fd8
> [22748.830672]  0000000000014cc0 ffff88002dc43158 ffff88002dc43160 ffff88002dc42dc0
> [22748.830678] Call Trace:
> [22748.830712]  [<ffffffffa024252c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
> [22748.830723]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
> [22748.830744]  [<ffffffffa02431c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
> [22748.830762]  [<ffffffffa0236059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
> [22748.830767]  [<ffffffff8105ca94>] ? try_to_wake_up+0xf4/0x3f0
> [22748.830773]  [<ffffffff81168119>] ? __pollwake+0x49/0x50
> [22748.830776]  [<ffffffff8105cd90>] ? default_wake_function+0x0/0x20
> [22748.830780]  [<ffffffff8116813b>] ? pollwake+0x1b/0x20
> [22748.830795]  [<ffffffffa0235df0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
> [22748.830799]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
> [22748.830804]  [<ffffffff81076736>] ? send_signal+0x56/0xa0
> [22748.830808]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
> [22748.830813]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
> [22748.830817]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
> [22748.830821]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
> [22748.830824]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> [22748.830828]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [22748.830832] INFO: task qemu-system-x86:5187 blocked for more than 120 seconds.
> [22748.830834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [22748.830837] qemu-system-x D ffff880001ed4cc0     0  5187   4768 0x00000004
> [22748.830841]  ffff8801b264db38 0000000000000086 ffff8801b264dfd8 0000000000014cc0
> [22748.830846]  0000000000014cc0 ffff8801b264dfd8 0000000000014cc0 ffff8801b264dfd8
> [22748.830850]  0000000000014cc0 ffff88002dc45f18 ffff88002dc45f20 ffff88002dc45b80
> [22748.830854] Call Trace:
> [22748.830869]  [<ffffffffa024252c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
> [22748.830874]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
> [22748.830889]  [<ffffffffa02431c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
> [22748.830904]  [<ffffffffa0236059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
> [22748.830910]  [<ffffffff81044221>] ? gup_pud_range+0xb1/0x100
> [22748.830915]  [<ffffffff812c5590>] ? vsnprintf+0x390/0x530
> [22748.830930]  [<ffffffffa0235df0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
> [22748.830934]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
> [22748.830938]  [<ffffffff8115753d>] ? rw_copy_check_uvector+0x7d/0x150
> [22748.830942]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
> [22748.830946]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
> [22748.830949]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
> [22748.830953]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
> [22748.830956]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> [22748.830960]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [22748.830963] INFO: task qemu-system-x86:5188 blocked for more than 120 seconds.
> [22748.830965] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [22748.830968] qemu-system-x D ffff880001e34cc0     0  5188   4768 0x00000004
> [22748.830972]  ffff880134911b38 0000000000000086 ffff880134911fd8 0000000000014cc0
> [22748.830976]  0000000000014cc0 ffff880134911fd8 0000000000014cc0 ffff880134911fd8
> [22748.830980]  0000000000014cc0 ffff88002dc41a78 ffff88002dc41a80 ffff88002dc416e0
> [22748.830984] Call Trace:
> [22748.830999]  [<ffffffffa024252c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
> [22748.831004]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
> [22748.831019]  [<ffffffffa02431c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
> [22748.831034]  [<ffffffffa0236059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
> [22748.831038]  [<ffffffff8105b564>] ? find_busiest_group+0x544/0xa70
> [22748.831054]  [<ffffffffa0235df0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
> [22748.831058]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
> [22748.831063]  [<ffffffff8104dd56>] ? update_shares+0x16/0x60
> [22748.831067]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
> [22748.831071]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
> [22748.831074]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
> [22748.831079]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
> [22748.831082]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> [22748.831085]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> [22748.831088] INFO: task qemu-system-x86:5189 blocked for more than 120 seconds.
> [22748.831090] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [22748.831093] qemu-system-x D ffff880001ef4cc0     0  5189   4768 0x00000004
> [22748.831097]  ffff88012e711b38 0000000000000086 ffff88012e711fd8 0000000000014cc0
> [22748.831101]  0000000000014cc0 ffff88012e711fd8 0000000000014cc0 ffff88012e711fd8
> [22748.831105]  0000000000014cc0 ffff88002dc44838 ffff88002dc44840 ffff88002dc444a0
> [22748.831109] Call Trace:
> [22748.831124]  [<ffffffffa024252c>] btrfs_start_ordered_extent+0x6c/0xb0 [btrfs]
> [22748.831129]  [<ffffffff81083200>] ? autoremove_wake_function+0x0/0x40
> [22748.831144]  [<ffffffffa02431c2>] btrfs_wait_ordered_range+0xd2/0x160 [btrfs]
> [22748.831159]  [<ffffffffa0236059>] btrfs_file_aio_write+0x269/0x990 [btrfs]
> [22748.831163]  [<ffffffff8105b564>] ? find_busiest_group+0x544/0xa70
> [22748.831179]  [<ffffffffa0235df0>] ? btrfs_file_aio_write+0x0/0x990 [btrfs]
> [22748.831183]  [<ffffffff8115664b>] do_sync_readv_writev+0xcb/0x110
> [22748.831187]  [<ffffffff8105d2f9>] ? load_balance+0x99/0x390
> [22748.831191]  [<ffffffff81294d98>] ? apparmor_file_permission+0x18/0x20
> [22748.831195]  [<ffffffff8126356e>] ? security_file_permission+0x1e/0x80
> [22748.831198]  [<ffffffff811576e0>] do_readv_writev+0xd0/0x1d0
> [22748.831202]  [<ffffffff8115781e>] vfs_writev+0x3e/0x60
> [22748.831205]  [<ffffffff811578e7>] sys_pwritev+0xa7/0xc0
> [22748.831209]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> 
> 
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
