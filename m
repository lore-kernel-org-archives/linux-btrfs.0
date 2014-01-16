Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:56441 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaAPPEG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 10:04:06 -0500
Received: by mail-qe0-f42.google.com with SMTP id b4so2649600qen.29
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 07:04:04 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 16:04:04 +0100
Message-ID: <CAF1_xX3eGrN-eF1oOuWK-FX1EKEK1xnNhhdGVphdGoX1Rrm2Lg@mail.gmail.com>
Subject: [v3.13-rc8] WARNING @ at fs/btrfs/inode.c:847 cow_file_range+0x57d/0x590()
From: Ronald <ronald645@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filesystem apparently got corrupted due to memory failures.

Full dmesg is here: http://pastebin.com/x8Z0P5xG

There are errors like:
[  188.667338] btrfs: corrupt leaf, bad key order:
block=79691776,root=1, slot=50


Warning:
[  441.746649] ------------[ cut here ]------------
[  441.746672] WARNING: CPU: 0 PID: 316 at fs/btrfs/inode.c:847
cow_file_range+0x57d/0x590()
[  441.746681] CPU: 0 PID: 316 Comm: btrfs-transacti Not tainted
3.13.0-rc8-00006-g87bee30 #1
[  441.746686] Hardware name: MSI MS-6712/MS-6712, BIOS Version 07.00T 04/02/01
[  441.746690]  00000000 00000000 f4cd395c c14e8407 f4cd398c c1024c51
c15ad1b0 00000000
[  441.746700]  0000013c c15b6169 0000034f c119602d c119602d 00000000
00001000 00000101
[  441.746707]  f4cd399c c1024d1d 00000009 00000000 f4cd3a10 c119602d
4778b000 00000000
[  441.746714] Call Trace:
[  441.746732]  [<c14e8407>] dump_stack+0x16/0x18
[  441.746743]  [<c1024c51>] warn_slowpath_common+0x71/0x90
[  441.746749]  [<c119602d>] ? cow_file_range+0x57d/0x590
[  441.746754]  [<c119602d>] ? cow_file_range+0x57d/0x590
[  441.746760]  [<c1024d1d>] warn_slowpath_null+0x1d/0x20
[  441.746765]  [<c119602d>] cow_file_range+0x57d/0x590
[  441.746774]  [<c1169ecb>] ? btrfs_free_path+0x1b/0x20
[  441.746780]  [<c14e6b81>] ? csum_exist_in_range.isra.58+0x3d/0x80
[  441.746792]  [<c11b12ec>] ? free_extent_buffer+0x3c/0x90
[  441.746797]  [<c119626e>] run_delalloc_nocow+0x22e/0xbd0
[  441.746802]  [<c1196f70>] run_delalloc_range+0x360/0x3c0
[  441.746809]  [<c11aeee1>] __extent_writepage+0x2f1/0x8d0
[  441.746816]  [<c11b088c>] extent_writepages+0x21c/0x340
[  441.746829]  [<c1193a30>] ? uncompress_inline.isra.60+0x180/0x180
[  441.746835]  [<c11aa68a>] ? free_extent_state.part.48+0x1a/0x30
[  441.746841]  [<c119126f>] btrfs_writepages+0x1f/0x30
[  441.746854]  [<c1086925>] do_writepages+0x15/0x40
[  441.746860]  [<c107d978>] __filemap_fdatawrite_range+0x68/0x80
[  441.746866]  [<c107d9e6>] filemap_fdatawrite_range+0x26/0x30
[  441.746872]  [<c11a8aba>] btrfs_wait_ordered_range+0x5a/0x420
[  441.746884]  [<c11cff7b>] __btrfs_write_out_cache+0x62b/0x890
[  441.746891]  [<c11d0be6>] btrfs_write_out_cache+0x76/0xa0
[  441.746897]  [<c1180696>] btrfs_write_dirty_block_groups+0x566/0x660
[  441.746903]  [<c14e6a84>] commit_cowonly_roots+0x139/0x1f9
[  441.746910]  [<c118ef82>] btrfs_commit_transaction+0x502/0x9e0
[  441.746915]  [<c118f4d1>] ? start_transaction+0x71/0x4f0
[  441.746921]  [<c14e92a6>] ? schedule_timeout+0xa6/0x110
[  441.746927]  [<c118b665>] transaction_kthread+0x145/0x1d0
[  441.746933]  [<c118b520>] ? btrfs_cleanup_transaction+0x320/0x320
[  441.746941]  [<c103a21a>] kthread+0x9a/0xb0
[  441.746951]  [<c14ebbb7>] ret_from_kernel_thread+0x1b/0x28
[  441.746956]  [<c103a180>] ? __kthread_parkme+0x60/0x60
[  441.746960] ---[ end trace 8af17939ae4129e6 ]---
