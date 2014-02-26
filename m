Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35758 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBZUUb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 15:20:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WIkxw-0001Vv-MS
	for linux-btrfs@vger.kernel.org; Wed, 26 Feb 2014 21:20:28 +0100
Received: from 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de ([84.19.169.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 21:20:28 +0100
Received: from jannis_achstetter by 131-028-005-185.ip-addr.ew-goldbach-hoesbach.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 21:20:28 +0100
To: linux-btrfs@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: [RFC PATCH v8 00/14] Online(inband) data deduplication
Date: Wed, 26 Feb 2014 20:20:01 +0000 (UTC)
Message-ID: <loom.20140226T211746-43@post.gmane.org>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com> <loom.20140225T201641-262@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jannis Achstetter <jannis_achstetter <at> web.de> writes: 
> I tried yout btrfs deduplication patches today (on top of 3.13.2-gentoo) and
> it seems that the deduplication works great (when copying the same or
> similar data to the file system, the used size reported by df -h grows less
> than the data that is copied to it on the second time).
> However, there are disturbing messages in the kernel log:

Me again :)

Today (PC rebooted), there are other messages in the log with traces like:
[  253.971188] BUG: scheduling while atomic: btrfs-transacti/5985/0x00000003
[  253.971194] Modules linked in: snd_aloop vboxnetflt(O) vboxnetadp(O)
vboxdrv(O) microcode
[  253.971208] CPU: 2 PID: 5985 Comm: btrfs-transacti Tainted: G        W  O
3.13.2-gentoo #4
[  253.971212] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS
V1.12 10/06/2011
[  253.971215]  ffff88022cf3b8a8 ffffffff81920b14 ffff880237c92b40
ffffffff8191c304
[  253.971221]  ffffffff81924bd5 ffff88022df7d750 ffff88022cf3bfd8
0000000000012b40
[  253.971227]  0000000000012b40 ffff88022df7d750 ffff8800c2ff7aa8
0000000000000020
[  253.971233] Call Trace:
[  253.971243]  [<ffffffff81920b14>] ? dump_stack+0x49/0x6a
[  253.971251]  [<ffffffff8191c304>] ? __schedule_bug+0x3e/0x4b
[  253.971258]  [<ffffffff81924bd5>] ? __schedule+0x7f5/0x8e0
[  253.971266]  [<ffffffff813d16c0>] ? submit_bio+0x60/0x130
[  253.971273]  [<ffffffff813497d3>] ? btrfs_map_bio+0x2d3/0x540
[  253.971280]  [<ffffffff810e6c8d>] ? ktime_get_ts+0x3d/0xd0
[  253.971287]  [<ffffffff81116c14>] ? delayacct_end+0x84/0xa0
[  253.971293]  [<ffffffff81140700>] ? filemap_fdatawait+0x20/0x20
[  253.971299]  [<ffffffff81924f43>] ? io_schedule+0x83/0xd0
[  253.971305]  [<ffffffff81140705>] ? sleep_on_page+0x5/0x10
[  253.971312]  [<ffffffff819252d4>] ? __wait_on_bit+0x54/0x80
[  253.971319]  [<ffffffff8114051f>] ? wait_on_page_bit+0x7f/0x90
[  253.971321]  [<ffffffff810d01b0>] ? autoremove_wake_function+0x30/0x30
[  253.971323]  [<ffffffff81341172>] ? read_extent_buffer_pages+0x2a2/0x2d0
[  253.971325]  [<ffffffff813172a0>] ? free_root_pointers+0x60/0x60
[  253.971327]  [<ffffffff81318e29>] ?
btree_read_extent_buffer_pages.constprop.53+0xa9/0x110
[  253.971330]  [<ffffffff813193ca>] ? read_tree_block+0x4a/0x80
[  253.971332]  [<ffffffff812fa657>] ? read_block_for_search.isra.32+0x177/0x3a0
[  253.971334]  [<ffffffff812f527a>] ? unlock_up+0x13a/0x160
[  253.971336]  [<ffffffff812fc980>] ? btrfs_search_slot+0x400/0x970
[  253.971338]  [<ffffffff8131531a>] ? btrfs_free_dedup_extent+0x7a/0x1c0
[  253.971340]  [<ffffffff813035e9>] ? extent_data_ref_offset.isra.30+0x79/0x110
[  253.971342]  [<ffffffff813061fc>] ? __btrfs_free_extent+0xa1c/0xc70
[  253.971344]  [<ffffffff8130aa3c>] ? run_clustered_refs+0x47c/0x1110
[  253.971347]  [<ffffffff813645ed>] ? find_ref_head+0x5d/0x90
[  253.971348]  [<ffffffff8130f388>] ? btrfs_run_delayed_refs+0xc8/0x510
[  253.971351]  [<ffffffff8131fe15>] ? btrfs_commit_transaction+0x55/0x990
[  253.971353]  [<ffffffff813207da>] ? start_transaction+0x8a/0x560
[  253.971355]  [<ffffffff8131bead>] ? transaction_kthread+0x19d/0x230
[  253.971357]  [<ffffffff8131bd10>] ? btrfs_cleanup_transaction+0x540/0x540
[  253.971360]  [<ffffffff810b4481>] ? kthread+0xc1/0xe0
[  253.971362]  [<ffffffff810b43c0>] ? kthread_create_on_node+0x190/0x190
[  253.971364]  [<ffffffff819286bc>] ? ret_from_fork+0x7c/0xb0
[  253.971366]  [<ffffffff810b43c0>] ? kthread_create_on_node+0x190/0x190

(More of them at http://bpaste.net/show/183075/ )

One more question: Do I have to run "btrfs dedup on -b 128k /mnt/steamdir"
after every mount or is that info stored across mounts?

Best regards,
     Jannis

