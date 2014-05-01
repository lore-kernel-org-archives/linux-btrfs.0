Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37844 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaEAEsW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 00:48:22 -0400
Received: by mail-ig0-f169.google.com with SMTP id h18so173923igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 21:48:22 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 May 2014 00:48:22 -0400
Message-ID: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
Subject: Unable to rebuild a 3 drive raid1 - blocked for more than 120 seconds.
From: Saran Neti <sarannmr@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had 3 x 3 TB drives in an almost full btrfs raid1 setup containing
only large (~20 GB) files linearly written and not modified after.
Then one of the drives got busted. Mounting the fs in degraded mode
and adding a new fresh drive to rebuild raid1, generated several
"...blocked for more than 120 seconds." messages. I left it running
for a couple of days, but "btrfs device add..." command wouldn't
return. I did a hard reboot, and after a degraded mount, am unable to
unmount, or add a drive or delete missing without getting stuck with
the same error. iostat shows no disk activity. When attempting an
unmount, both "umount" and "[btrfs-transacti]" processes become
defunct. Tried -o skip_balance as well to no avail.

Described in https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30017.html
are two possible causes, fragmentation due to COW and hardlinks, both
of which I think are unlikely in this case. I can mount in degraded
mode and read files, but that's about it. Is there something I'm
missing? Any debugging tips would be appreciated. Please let me know
if I can provide more information.

--- Info ---
# uname -a
Linux localhost 3.14.1-1-ARCH #1 SMP PREEMPT Mon Apr 14 20:40:47 CEST
2014 x86_64 GNU/Linux

# btrfs --version
Btrfs v3.14

# btrfs fi show
Label: 'cohenraid1'  uuid: 288723c3-2e98-4a6c-87d3-058451d87d26
        Total devices 3 FS bytes used 3.44TiB
        devid    1 size 2.73TiB used 2.19TiB path /dev/sdg1
        devid    2 size 2.73TiB used 2.46TiB path /dev/sdf1
        *** Some devices missing

# btrfs fi df /mnt/cohenraid1
Data, RAID1: total=3.54TiB, used=3.43TiB
System, RAID1: total=32.00MiB, used=528.00KiB
Metadata, RAID1: total=6.00GiB, used=3.57GiB

(Originally, there were two 2.19 TiB filled drives and one 2.46 TiB
filled drive. All drives incl. the new one I'm unable to add are
SMART-longtest good.)

Kernel messages:

Apr 30 09:49:34 localhost kernel: INFO: task btrfs-transacti:4080
blocked for more than 120 seconds.
Apr 30 09:49:34 localhost kernel:       Not tainted 3.14.1-1-ARCH #1
Apr 30 09:49:34 localhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 09:49:34 localhost kernel: btrfs-transacti D ffff8804fe89eb40
  0  4080      2 0x00000000
Apr 30 09:49:34 localhost kernel:  ffff8804b0bdbdc0 0000000000000046
ffff8804cb3193a0 ffff8804b0bdbfd8
Apr 30 09:49:34 localhost kernel:  00000000000142c0 00000000000142c0
ffff8804cb3193a0 00000000000142c0
Apr 30 09:49:34 localhost kernel:  ffff8804cb3193a0 0000000000000000
0000000200000000 0000000000000009
Apr 30 09:49:34 localhost kernel: Call Trace:
Apr 30 09:49:34 localhost kernel:  [<ffffffffa076a7f8>] ?
start_transaction+0x138/0x5a0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff8109c648>] ?
__enqueue_entity+0x78/0x80
Apr 30 09:49:34 localhost kernel:  [<ffffffff8109580e>] ?
set_task_cpu+0x6e/0x1d0
Apr 30 09:49:34 localhost kernel:  [<ffffffff8107279b>] ?
lock_timer_base.isra.35+0x2b/0x50
Apr 30 09:49:34 localhost kernel:  [<ffffffff814d7eb9>] schedule+0x29/0x70
Apr 30 09:49:34 localhost kernel:  [<ffffffffa076934f>]
wait_current_trans.isra.19+0x9f/0x100 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff810aa350>] ?
__wake_up_sync+0x20/0x20
Apr 30 09:49:34 localhost kernel:  [<ffffffffa076a978>]
start_transaction+0x2b8/0x5a0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa076ad17>]
btrfs_attach_transaction+0x17/0x20 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa0765acb>]
transaction_kthread+0x16b/0x240 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa0765960>] ?
btrfs_cleanup_transaction+0x570/0x570 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff810872a2>] kthread+0xd2/0xf0
Apr 30 09:49:34 localhost kernel:  [<ffffffff810871d0>] ?
kthread_create_on_node+0x180/0x180
Apr 30 09:49:34 localhost kernel:  [<ffffffff814e2ffc>] ret_from_fork+0x7c/0xb0
Apr 30 09:49:34 localhost kernel:  [<ffffffff810871d0>] ?
kthread_create_on_node+0x180/0x180
Apr 30 09:49:34 localhost kernel: INFO: task umount:4298 blocked for
more than 120 seconds.
Apr 30 09:49:34 localhost kernel:       Not tainted 3.14.1-1-ARCH #1
Apr 30 09:49:34 localhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 09:49:34 localhost kernel: umount          D ffff8804ab5f99f0
  0  4298   4296 0x00000004
Apr 30 09:49:34 localhost kernel:  ffff8804ab5f9960 0000000000000082
ffff8804d72ff5c0 ffff8804ab5f9fd8
Apr 30 09:49:34 localhost kernel:  00000000000142c0 00000000000142c0
ffff8804d72ff5c0 ffff880509cd26a8
Apr 30 09:49:34 localhost kernel:  0000000000000080 ffff8804ab5f98f8
ffffffff81251ea8 ffff8804e7f34260
Apr 30 09:49:34 localhost kernel: Call Trace:
Apr 30 09:49:34 localhost kernel:  [<ffffffff81251ea8>] ? submit_bio+0x78/0x160
Apr 30 09:49:34 localhost kernel:  [<ffffffffa0793841>] ?
btrfs_map_bio+0x2a1/0x550 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff8101d3c9>] ? read_tsc+0x9/0x20
Apr 30 09:49:34 localhost kernel:  [<ffffffff81133760>] ?
filemap_fdatawait+0x30/0x30
Apr 30 09:49:34 localhost kernel:  [<ffffffff814d7eb9>] schedule+0x29/0x70
Apr 30 09:49:34 localhost kernel:  [<ffffffff814d815f>] io_schedule+0x8f/0xe0
Apr 30 09:49:34 localhost kernel:  [<ffffffff8113376e>] sleep_on_page+0xe/0x20
Apr 30 09:49:34 localhost kernel:  [<ffffffff814d84d2>] __wait_on_bit+0x62/0x90
Apr 30 09:49:34 localhost kernel:  [<ffffffff8113352f>]
wait_on_page_bit+0x7f/0x90
Apr 30 09:49:34 localhost kernel:  [<ffffffff810aa390>] ?
autoremove_wake_function+0x40/0x40
Apr 30 09:49:34 localhost kernel:  [<ffffffff81141471>] ?
pagevec_lookup_tag+0x21/0x30
Apr 30 09:49:34 localhost kernel:  [<ffffffff811336aa>]
filemap_fdatawait_range+0x10a/0x190
Apr 30 09:49:34 localhost kernel:  [<ffffffffa078333f>]
btrfs_wait_ordered_range+0x6f/0x140 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa07a9c30>]
__btrfs_write_out_cache+0x6d0/0x8e0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa07aaf1d>]
btrfs_write_out_cache+0x8d/0xe0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa075a393>]
btrfs_write_dirty_block_groups+0x593/0x680 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa0768023>]
commit_cowonly_roots+0x163/0x230 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa076a118>]
btrfs_commit_transaction+0x428/0x9d0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa07641ff>]
btrfs_commit_super+0x8f/0xa0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffffa0765e10>]
close_ctree+0x270/0x2a0 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff811bee6c>] ?
evict_inodes+0x11c/0x130
Apr 30 09:49:34 localhost kernel:  [<ffffffffa073d049>]
btrfs_put_super+0x19/0x20 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff811a66b2>]
generic_shutdown_super+0x72/0xf0
Apr 30 09:49:34 localhost kernel:  [<ffffffff811a68f2>]
kill_anon_super+0x12/0x20
Apr 30 09:49:34 localhost kernel:  [<ffffffffa073cdd6>]
btrfs_kill_super+0x16/0x90 [btrfs]
Apr 30 09:49:34 localhost kernel:  [<ffffffff811a6c4d>]
deactivate_locked_super+0x3d/0x60
Apr 30 09:49:34 localhost kernel:  [<ffffffff811a7206>]
deactivate_super+0x46/0x60
Apr 30 09:49:34 localhost kernel:  [<ffffffff811c25c5>]
mntput_no_expire+0xe5/0x170
Apr 30 09:49:34 localhost kernel:  [<ffffffff811c3890>] SyS_umount+0x90/0x3c0
Apr 30 09:49:34 localhost kernel:  [<ffffffff814e30a9>]
system_call_fastpath+0x16/0x1b

-- 
Saran
