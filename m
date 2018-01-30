Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39813 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751727AbeA3N2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 08:28:24 -0500
Message-Id: <1517318903.701186.1253170144.3DCA79D6@webmail.messagingengine.com>
From: Christophe Yayon <cyayon-list@nbux.org>
To: Nikolay Borisov <nborisov@suse.com>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: Re: umount btrfs hang
In-Reply-To: <d34ea1e9-db3d-d82d-5a07-0067d576a401@suse.com>
References: <1517299408.578486.1252869768.3537850D@webmail.messagingengine.com>
 <d34ea1e9-db3d-d82d-5a07-0067d576a401@suse.com>
Date: Tue, 30 Jan 2018 14:28:23 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

is vanilla 4.14.13 without patch.

thanks for the tips.

-- 
  Christophe Yayon
  cyayon-list@nbux.org

On Tue, Jan 30, 2018, at 14:07, Nikolay Borisov wrote:
> 
> 
> On 30.01.2018 10:03, Christophe Yayon wrote:
> > Hi all,
> > 
> > While trying umount a single btrfs volume i get stuck and get a call kernel trace.
> > My kernel is 4.14.13 (archlinux).
> 
> Is this upstream 4.14.13 or 4.14 with some Arch patches?
> 
> > 
> > Unable to umount, tried to killed command, no way...
> > 
> > what should i do ? Thanks.
> 
> When this occurs the next time provide the output of
> echo w > /proc/sysrq-trigger. Without it it's impossible to reason what
> might have caused the lock up.
> 
> > 
> > # btrfs fi df /mnt/vol3
> > Data, single: total=25.97GiB, used=6.84GiB
> > System, DUP: total=8.00MiB, used=4.00KiB
> > System, single: total=4.00MiB, used=0.00B
> > Metadata, DUP: total=1.00GiB, used=111.44MiB
> > Metadata, single: total=8.00MiB, used=0.00B
> > GlobalReserve, single: total=16.00MiB, used=0.00B
> > 
> > -------------
> > Jan 30 08:57:58 daneel.nbux.org kernel: INFO: task kworker/u16:5:4967 blocked for more than 120 seconds.
> > Jan 30 08:57:58 daneel.nbux.org kernel:       Tainted: G         C      4.14.13-1-ARCH #1
> > Jan 30 08:57:58 daneel.nbux.org kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jan 30 08:57:58 daneel.nbux.org kernel: kworker/u16:5   D    0  4967      2 0x80000000
> > Jan 30 08:57:58 daneel.nbux.org kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel: Call Trace:
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? __schedule+0x290/0x890
> > Jan 30 08:57:58 daneel.nbux.org kernel:  schedule+0x2f/0x90
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? wait_woken+0x80/0x80
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_search_slot+0x703/0x9f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? kmem_cache_alloc+0x153/0x1a0
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_iget+0x10e/0x6f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  __lookup_free_space_inode+0x106/0x160 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  lookup_free_space_inode+0x63/0xe0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  load_free_space_cache+0x66/0x180 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? kmem_cache_alloc_trace+0x161/0x1b0
> > Jan 30 08:57:58 daneel.nbux.org kernel:  cache_block_group+0x1c6/0x3e0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? wait_woken+0x80/0x80
> > Jan 30 08:57:58 daneel.nbux.org kernel:  find_free_extent+0x63e/0xfb0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_reserve_extent+0x9b/0x180 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_alloc_tree_block+0x123/0x4c0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  __btrfs_cow_block+0x121/0x5b0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_cow_block+0xca/0x1c0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_search_slot+0x321/0x9f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_del_csums+0x107/0x3c0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  __btrfs_free_extent.isra.61+0x49b/0xd60 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  __btrfs_run_delayed_refs+0x725/0x12f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_run_delayed_refs+0x68/0x240 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  delayed_ref_async_start+0x8d/0xa0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_worker_helper+0x70/0x330 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  process_one_work+0x1db/0x410
> > Jan 30 08:57:58 daneel.nbux.org kernel:  worker_thread+0x2b/0x3d0
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? process_one_work+0x410/0x410
> > Jan 30 08:57:58 daneel.nbux.org kernel:  kthread+0x118/0x130
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? kthread_create_on_node+0x70/0x70
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? SyS_exit+0x13/0x20
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ret_from_fork+0x1f/0x30
> > Jan 30 08:57:58 daneel.nbux.org kernel: INFO: task kworker/u16:11:13568 blocked for more than 120 seconds.
> > Jan 30 08:57:58 daneel.nbux.org kernel:       Tainted: G         C      4.14.13-1-ARCH #1
> > Jan 30 08:57:58 daneel.nbux.org kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jan 30 08:57:58 daneel.nbux.org kernel: kworker/u16:11  D    0 13568      2 0x80000000
> > Jan 30 08:57:58 daneel.nbux.org kernel: Workqueue: btrfs-freespace-write btrfs_freespace_write_helper [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel: Call Trace:
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? __schedule+0x290/0x890
> > Jan 30 08:57:58 daneel.nbux.org kernel:  schedule+0x2f/0x90
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_tree_lock+0xd1/0x1f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? wait_woken+0x80/0x80
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_search_slot+0x6e7/0x9f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_mark_extent_written+0xb1/0xbb0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? lock_extent_bits+0x54/0x1b0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? join_transaction+0x10c/0x3f0 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? start_transaction+0x9e/0x410 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_finish_ordered_io+0x591/0x810 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? pick_next_task_fair+0x171/0x560
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? __switch_to+0xa2/0x4e0
> > Jan 30 08:57:58 daneel.nbux.org kernel:  btrfs_worker_helper+0x70/0x330 [btrfs]
> > Jan 30 08:57:58 daneel.nbux.org kernel:  process_one_work+0x1db/0x410
> > Jan 30 08:57:58 daneel.nbux.org kernel:  worker_thread+0x2b/0x3d0
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? process_one_work+0x410/0x410
> > Jan 30 08:57:58 daneel.nbux.org kernel:  kthread+0x118/0x130
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? kthread_create_on_node+0x70/0x70
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ? SyS_exit+0x13/0x20
> > Jan 30 08:57:58 daneel.nbux.org kernel:  ret_from_fork+0x1f/0x30
> > -------------
> > 
