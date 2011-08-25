From: Diego Calleja <diegocg@gmail.com>
Subject: WARNING in -rc3-00023-g14c62e7
Date: Thu, 25 Aug 2011 21:17:03 +0200
Message-ID: <201108252117.04108.diegocg@gmail.com>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is what I got in my dmesg...I have lots of these warnings, didn't
notice it until now.

[  235.705766] ------------[ cut here ]------------
[  235.705772] WARNING: at fs/inode.c:1309 iput+0x1ed/0x210()
[  235.705773] Hardware name:         
[  235.705774] Modules linked in: ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables snd_hda_codec_hdmi snd_hda_codec_realtek wacom snd_hda_intel snd_hda_codec snd_pcm snd_timer snd soundcore e1000e i2c_i801 snd_page_alloc virtio_net virtio virtio_ring kvm_intel kvm [last unloaded: scsi_wait_scan]
[  235.705788] Pid: 3203, comm: btrfs-cleaner Not tainted 3.1.0-rc3-00023-g14c62e7 #4
[  235.705789] Call Trace:
[  235.705794]  [<ffffffff8104bbcf>] warn_slowpath_common+0x7f/0xc0
[  235.705796]  [<ffffffff8104bc2a>] warn_slowpath_null+0x1a/0x20
[  235.705797]  [<ffffffff8116922d>] iput+0x1ed/0x210
[  235.705800]  [<ffffffff8123b3ac>] btrfs_iget+0x1cc/0x460
[  235.705804]  [<ffffffff815dbc56>] ? _raw_spin_unlock+0x16/0x40
[  235.705807]  [<ffffffff8123f8ce>] btrfs_run_defrag_inodes+0x12e/0x210
[  235.705809]  [<ffffffff8122a09b>] cleaner_kthread+0x18b/0x1a0
[  235.705811]  [<ffffffff815dbe0a>] ? _raw_spin_unlock_irqrestore+0x2a/0x60
[  235.705813]  [<ffffffff81229f10>] ? transaction_kthread+0x290/0x290
[  235.705815]  [<ffffffff8106e42c>] kthread+0x8c/0xa0
[  235.705818]  [<ffffffff815e51f4>] kernel_thread_helper+0x4/0x10
[  235.705820]  [<ffffffff81037cde>] ? finish_task_switch+0x4e/0xe0
[  235.705822]  [<ffffffff815dbc9c>] ? _raw_spin_unlock_irq+0x1c/0x40
[  235.705824]  [<ffffffff815dc64e>] ? retint_restore_args+0xe/0xe
[  235.705826]  [<ffffffff8106e3a0>] ? kthread_worker_fn+0x190/0x190
[  235.705828]  [<ffffffff815e51f0>] ? gs_change+0xb/0xb
[  235.705829] ---[ end trace 522a9ae26c065662 ]---
