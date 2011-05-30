From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [3.0-rc1] delayed insertion allocation failing...
Date: Mon, 30 May 2011 22:24:08 +0800
Message-ID: <BANLkTinv0GDkGy6mhC2DVrt6wW7ZGQPPrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

When booting 3.0-rc1 with an existing BTRFS filesystem with a normal
desktop use pattern, we see btrfs_batch_insert_item() sometimes
attempt an overly-large kmalloc (>= order 11) [1], which is
subsequently failed.

Thanks,
  Daniel

--- [1]

WARNING: at mm/page_alloc.c:2074 __alloc_pages_nodemask+0x206/0x800()
Hardware name: Latitude E5420
Modules linked in: kvm_intel kvm microcode arc4 uvcvideo videodev
v4l2_compat_ioctl32 iwlagn mac80211 sdhci_pci sdhci mmc_core i915
drm_kms_helper drm mei(C) i2c_algo_bit video
Pid: 188, comm: btrfs-delayed-m Tainted: G         C  3.0.0-rc1-100debug+ #1
Call Trace:
 [<ffffffff8105ceaa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8105cef5>] warn_slowpath_null+0x15/0x20
 [<ffffffff810f0df6>] __alloc_pages_nodemask+0x206/0x800
 [<ffffffff812bfa53>] ? map_extent_buffer+0xd3/0xe0
 [<ffffffff812b3db4>] ? btrfs_item_offset+0xe4/0xf0
 [<ffffffff81122bd0>] alloc_pages_current+0xa0/0x110
 [<ffffffff810ec43f>] __get_free_pages+0xf/0x50
 [<ffffffff8112e71a>] __kmalloc+0x13a/0x160
 [<ffffffff8171ac00>] ? _raw_spin_unlock+0x30/0x60
 [<ffffffff812e6050>] btrfs_batch_insert_items+0x110/0x290
 [<ffffffff812e6326>] btrfs_insert_delayed_items+0x156/0x170
 [<ffffffff812e674d>] btrfs_async_run_delayed_node_done+0x6d/0x1f0
 [<ffffffff812c80f6>] worker_loop+0x86/0x2b0
 [<ffffffff812c8070>] ? check_pending_worker_creates.clone.4+0xe0/0xe0
 [<ffffffff8107dea6>] kthread+0xb6/0xc0
 [<ffffffff8109882d>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8171c894>] kernel_thread_helper+0x4/0x10
 [<ffffffff81048a47>] ? finish_task_switch+0x77/0x100
 [<ffffffff8171afc4>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107ddf0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8171c890>] ? gs_change+0xb/0xb
-- 
Daniel J Blueman
