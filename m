Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:45527 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3AKV51 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 16:57:27 -0500
Received: by mail-vc0-f181.google.com with SMTP id gb30so1869949vcb.26
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 13:57:26 -0800 (PST)
MIME-Version: 1.0
Reply-To: chris.r.carlin@gmail.com
In-Reply-To: <20130111185449.GU19051@carfax.org.uk>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
 <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com> <20130111185449.GU19051@carfax.org.uk>
From: Chris Carlin <chrisrcarlin@gmail.com>
Date: Fri, 11 Jan 2013 16:57:06 -0500
Message-ID: <CAHX0HSby06a7x9iDgvRwtMJbcysQGkFYxeQf0XTM35rRHp=m2w@mail.gmail.com>
Subject: Re: Errors not found by btrfsck or scrub
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the response, Hugo!

This hard drive is not production, so I can afford to tinker with it
if it helps you guys track down anything interesting. Of course, I'd
prefer to restore it rather than wipe it...

The initial balance operation was run on kernel 3.2.0 with Ubuntu's
older version of btrfs-tools without any parameters/filters IIRC. Like
I said, the balance (falsely?) reported success. It was back in 3.2.0
where the filesystem started misbehaving, Mitch, so I don't think
older versions are getting me the metadata space, unless there's an
operation I'm missing.

Now I upgraded to kernel 3.7.2 (I'll never get used to the new
numbering scheme), but as with kernel 3.5.7, balance hangs without
backgrounding, and there's an error in dmesg. I ran balance with the
suggested -dusage=5.

The dmesg spiel is below.

~Chris

[  176.204750] btrfs: block rsv returned -28
[  176.204762] ------------[ cut here ]------------
[  176.204861] WARNING: at
/home/apw/COD/linux/fs/btrfs/extent-tree.c:6297
use_block_rsv+0x193/0x1a0 [btrfs]()
[  176.204865] Hardware name: KT600-8237
[  176.204868] Modules linked in: matrox_w1 wire i2c_viapro shpchp
serio_raw mac_hid w83627hf hwmon_vid lp parport hid_generic btrfs
usbhid zlib_deflate libcrc32c hid r8169 sata_via sata_sil
[  176.204896] Pid: 1703, comm: btrfs Not tainted 3.7.2-030702-generic
#201301111424
[  176.204900] Call Trace:
[  176.204916]  [<c104b0e2>] warn_slowpath_common+0x72/0xa0
[  176.204941]  [<e097ebe3>] ? use_block_rsv+0x193/0x1a0 [btrfs]
[  176.204964]  [<e097ebe3>] ? use_block_rsv+0x193/0x1a0 [btrfs]
[  176.204970]  [<c104b132>] warn_slowpath_null+0x22/0x30
[  176.204994]  [<e097ebe3>] use_block_rsv+0x193/0x1a0 [btrfs]
[  176.205020]  [<e098227b>] btrfs_alloc_free_block+0x3b/0x2b0 [btrfs]
[  176.205027]  [<c1116fee>] ? __set_page_dirty_nobuffers+0x1e/0x20
[  176.205053]  [<e098b164>] ? btree_set_page_dirty+0x34/0x40 [btrfs]
[  176.205058]  [<c1116295>] ? set_page_dirty+0x55/0x60
[  176.205095]  [<e09b3a61>] ? set_extent_buffer_dirty+0x71/0xb0 [btrfs]
[  176.205107]  [<c1607d2d>] ? _raw_spin_lock+0xd/0x10
[  176.205136]  [<e09b411c>] ? read_extent_buffer+0x9c/0x100 [btrfs]
[  176.205159]  [<e096dfc4>] __btrfs_cow_block+0x144/0x590 [btrfs]
[  176.205184]  [<e098caa4>] ?
btree_read_extent_buffer_pages.constprop.120+0xf4/0x140 [btrfs]
[  176.205207]  [<e096e54e>] btrfs_cow_block+0xde/0x230 [btrfs]
[  176.205230]  [<e097121f>] push_leaf_right+0xef/0x160 [btrfs]
[  176.205252]  [<e09718a7>] split_leaf+0x547/0x680 [btrfs]
[  176.205276]  [<e09704ff>] ? btrfs_leaf_free_space+0x3f/0x90 [btrfs]
[  176.205298]  [<e096fa65>] ? bin_search+0x75/0x90 [btrfs]
[  176.205321]  [<e097226e>] btrfs_search_slot+0x60e/0x660 [btrfs]
[  176.205344]  [<e097348d>] btrfs_insert_empty_items+0x5d/0xb0 [btrfs]
[  176.205367]  [<e097af9c>] alloc_reserved_tree_block+0x6c/0x270 [btrfs]
[  176.205391]  [<e097bae7>] run_delayed_tree_ref+0xd7/0x220 [btrfs]
[  176.205415]  [<e0980e64>] run_one_delayed_ref+0x134/0x150 [btrfs]
[  176.205439]  [<e0980f87>] run_clustered_refs+0x107/0x330 [btrfs]
[  176.205463]  [<e0983c3e>] btrfs_run_delayed_refs+0xae/0x2b0 [btrfs]
[  176.205490]  [<e09933ca>] btrfs_commit_transaction+0x40a/0x950 [btrfs]
[  176.205519]  [<e09b3a61>] ? set_extent_buffer_dirty+0x71/0xb0 [btrfs]
[  176.205527]  [<c106cd70>] ? add_wait_queue+0x50/0x50
[  176.205550]  [<e096d440>] ? btrfs_free_path+0x20/0x30 [btrfs]
[  176.205579]  [<e09b7b3b>] insert_balance_item+0x49b/0x590 [btrfs]
[  176.205609]  [<e09bc3a5>] btrfs_balance+0x335/0x5d0 [btrfs]
[  176.205619]  [<c115f8e0>] ? __sb_start_write+0x50/0xf0
[  176.205625]  [<c114da51>] ? kmem_cache_alloc_trace+0x111/0x140
[  176.205657]  [<e09c49bd>] btrfs_ioctl_balance+0xed/0x380 [btrfs]
[  176.205686]  [<e09c6591>] btrfs_ioctl+0x561/0x890 [btrfs]
[  176.205695]  [<c160b73f>] ? __do_page_fault+0x25f/0x4d0
[  176.205724]  [<e09c6030>] ? update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
[  176.205734]  [<c116d76f>] do_vfs_ioctl+0x7f/0x2f0
[  176.205740]  [<c116da50>] sys_ioctl+0x70/0x80
[  176.205749]  [<c160f40d>] sysenter_do_call+0x12/0x28
[  176.205753] ---[ end trace 7da78ca4ff782519 ]---
[  176.205783] btrfs: run_one_delayed_ref returned -28
[  176.205788] ------------[ cut here ]------------
[  176.205811] WARNING: at /home/apw/COD/linux/fs/btrfs/super.c:246
__btrfs_abort_transaction+0xde/0x100 [btrfs]()
[  176.205814] Hardware name: KT600-8237
[  176.205817] btrfs: Transaction aborted
[  176.205819] Modules linked in: matrox_w1 wire i2c_viapro shpchp
serio_raw mac_hid w83627hf hwmon_vid lp parport hid_generic btrfs
usbhid zlib_deflate libcrc32c hid r8169 sata_via sata_sil
[  176.205841] Pid: 1703, comm: btrfs Tainted: G        W
3.7.2-030702-generic #201301111424
[  176.205843] Call Trace:
[  176.205849]  [<c104b0e2>] warn_slowpath_common+0x72/0xa0
[  176.205872]  [<e096a1be>] ? __btrfs_abort_transaction+0xde/0x100 [btrfs]
[  176.205895]  [<e096a1be>] ? __btrfs_abort_transaction+0xde/0x100 [btrfs]
[  176.205900]  [<c104b1b3>] warn_slowpath_fmt+0x33/0x40
[  176.205923]  [<e096a1be>] __btrfs_abort_transaction+0xde/0x100 [btrfs]
[  176.205948]  [<e0983dbe>] btrfs_run_delayed_refs+0x22e/0x2b0 [btrfs]
[  176.205975]  [<e09933ca>] btrfs_commit_transaction+0x40a/0x950 [btrfs]
[  176.206003]  [<e09b3a61>] ? set_extent_buffer_dirty+0x71/0xb0 [btrfs]
[  176.206009]  [<c106cd70>] ? add_wait_queue+0x50/0x50
[  176.206032]  [<e096d440>] ? btrfs_free_path+0x20/0x30 [btrfs]
[  176.206060]  [<e09b7b3b>] insert_balance_item+0x49b/0x590 [btrfs]
[  176.206091]  [<e09bc3a5>] btrfs_balance+0x335/0x5d0 [btrfs]
[  176.206096]  [<c115f8e0>] ? __sb_start_write+0x50/0xf0
[  176.206102]  [<c114da51>] ? kmem_cache_alloc_trace+0x111/0x140
[  176.206131]  [<e09c49bd>] btrfs_ioctl_balance+0xed/0x380 [btrfs]
[  176.206160]  [<e09c6591>] btrfs_ioctl+0x561/0x890 [btrfs]
[  176.206166]  [<c160b73f>] ? __do_page_fault+0x25f/0x4d0
[  176.206196]  [<e09c6030>] ? update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
[  176.206202]  [<c116d76f>] do_vfs_ioctl+0x7f/0x2f0
[  176.206208]  [<c116da50>] sys_ioctl+0x70/0x80
[  176.206214]  [<c160f40d>] sysenter_do_call+0x12/0x28
[  176.206218] ---[ end trace 7da78ca4ff78251a ]---
[  176.206224] BTRFS error (device sdc1) in
btrfs_run_delayed_refs:2514: error 28
[  176.206235] btrfs is forced readonly
[  176.206241] BTRFS warning (device sdc1): Skipping commit of aborted
transaction.
[  176.206245] BTRFS error (device sdc1) in cleanup_transaction:1378: error 28
