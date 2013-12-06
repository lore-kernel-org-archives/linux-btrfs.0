Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from infao0809.mpi-klsb.mpg.de ([139.19.1.49]:45205 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161499Ab3LFNBa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 08:01:30 -0500
Message-ID: <52A1CAA5.8090302@mpi-sws.org>
Date: Fri, 06 Dec 2013 14:01:25 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: Null pointer oops when deleting item in btrfs_find_all_root()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've encountered another null pointer bug in btrfs_find_all_root().

It may be releated to a bug I previously reported to the mailing list 
("Null pointer dereference bug in btrfs_find_all_root"). But this test 
ran on kernel version 3.12.2 and the oops was triggered when deleting an 
item from the list. The actual workload (i.e. FS operations) is similar 
though.

Pedro

> [  833.475696] btrfs: new size for /dev/loop0 is 305135616
> [  833.475696] btrfs: relocating block group 20971520 flags 1
> [  862.226474] BUG: unable to handle kernel NULL pointer dereference 
> at   (null)
> [  862.226474] IP: [<c1208b41>] __list_del_entry+0x4/0x71
> [  862.226474] *pde = 00000000
> [  862.226474] Oops: 0000 [#1] SMP
> [  862.226474] Modules linked in: btrfs zlib_deflate zlib_inflate loop 
> rtc_cmos freq_table tpm_tis pcspkr i2c_piix4
> [  862.226474] CPU: 3 PID: 2729 Comm: btrfs-endio-wri Not tainted 
> 3.12.2 #2
> [  862.226474] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  862.226474] task: df556370 ti: c4da4000 task.ti: c4da4000
> [  862.226474] EIP: 0060:[<c1208b41>] EFLAGS: 00000207 CPU: 3
> [  862.226474] EIP is at __list_del_entry+0x4/0x71
> [  862.226474] EAX: 00000000 EBX: 00000000 ECX: c4da5d18 EDX: d9ccc5e8
> [  862.226474] ESI: c4da5d10 EDI: 00000000 EBP: c4da5ca4 ESP: c4da5ca0
> [  862.226474]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  862.226474] CR0: 8005003b CR2: 00000000 CR3: 00014000 CR4: 00000690
> [  862.226474] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  862.226474] DR6: 00000000 DR7: 00000000
> [  862.226474] Stack:
> [  862.226474]  00000000 c4da5cb0 c1208bb9 00000000 c4da5d60 e1871573 
> dec488c0 00000286
> [  862.226474]  d9ccc5e8 c4da5cd8 00000286 d9ccc5e8 00000000 00bc5000 
> 000000b0 def33000
> [  862.226474]  d9d434c8 00000000 d9c9c2a8 dee94a00 00000490 d9ccc5e8 
> c4da5d18 00000000
> [  862.226474] Call Trace:
> [  862.226474]  [<c1208bb9>] list_del+0xb/0x1b
> [  862.226474]  [<e1871573>] find_parent_nodes+0xeff/0xf57 [btrfs]
> [  862.226474]  [<e1871645>] btrfs_find_all_roots+0x67/0xba [btrfs]
> [  862.226474]  [<e1871d21>] iterate_extent_inodes+0xfa/0x1b9 [btrfs]
> [  862.226474]  [<e1871e5d>] iterate_inodes_from_logical+0x7d/0x93 [btrfs]
> [  862.226474]  [<e182e7f2>] ? btrfs_clear_bit_hook+0x1f9/0x1f9 [btrfs]
> [  862.226474]  [<e182d355>] record_extent_backrefs+0x50/0x8a [btrfs]
> [  862.226474]  [<e182e7f2>] ? btrfs_clear_bit_hook+0x1f9/0x1f9 [btrfs]
> [  862.226474]  [<e1835778>] btrfs_finish_ordered_io+0x7af/0x8ad [btrfs]
> [  862.226474]  [<e1835881>] finish_ordered_fn+0xb/0xd [btrfs]
> [  862.226474]  [<e184fcf0>] worker_loop+0xf5/0x3d1 [btrfs]
> [  862.226474]  [<e184fbfb>] ? btrfs_queue_worker+0x1e4/0x1e4 [btrfs]
> [  862.226474]  [<c103e612>] kthread+0x6e/0x73
> [  862.226474]  [<c15d01d7>] ret_from_kernel_thread+0x1b/0x28
> [  862.226474]  [<c103e5a4>] ? __kthread_parkme+0x54/0x54
> [  862.226474] Code: 56 68 09 ed 82 c1 6a 5e 68 bd ec 82 c1 e8 c6 2b 
> e2 ff 83 c4 18 89 37 89 5f 04 89 3b 89 7e 04 8d 65 f4 5b 5e 5f 5d c3 
> 55 89 e5 53 <8b> 08 8b 50 04 81 f9 00 01 10 00 75 41 68 00 01 10 00 50 
> 68 5a
> [  862.226474] EIP: [<c1208b41>] __list_del_entry+0x4/0x71 SS:ESP 
> 0068:c4da5ca0
> [  862.226474] CR2: 0000000000000000
> [  862.226474] ---[ end trace e9a87cf6306682c8 ]---

