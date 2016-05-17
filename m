Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:49749 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbcEQPPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 11:15:03 -0400
Date: Tue, 17 May 2016 17:14:51 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, dsj@fb.com,
        Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] Btrfs: fix handling of faults from btrfs_copy_from_user
Message-ID: <20160517151451.GA3882@angband.pl>
References: <20160516210655.sfsjtj5oleeksaxq@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160516210655.sfsjtj5oleeksaxq@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 05:06:55PM -0400, Chris Mason wrote:
> Hi everyone,
> 
> I've tried to cc most of the recent reports of this warning.  It was
> pretty hard to track down, but I've got a test program for it now.  My
> goal is to change xfs_io to add the madvise loop under
> --do-horrible-things, instead of adding yet another special doio.c
> function to xfstests.
[...]
> And now for the patch:
[...]


I've applied the patch and hammered it with real workloads (mostly sbuild).
They used to trigger the warning nearly immediately, with the patch all
seemed ok -- so there is an improvement.

I then tried your test case, and alas:
[13603.998647] ------------[ cut here ]------------
[13603.998668] WARNING: CPU: 0 PID: 11291 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0x63/0x80
[13603.998673] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia(PO) [last unloaded: vboxdrv]
[13603.998692] CPU: 0 PID: 11291 Comm: kworker/u12:15 Tainted: P           O    4.6.0+ #1
[13603.998697] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[13603.998706] Workqueue: btrfs-delalloc btrfs_delalloc_helper
[13603.998715]  0000000000000000 ffffffff813817a0 0000000000000000 0000000000000000
[13603.998722]  ffffffff8108ce82 000000000000b000 ffff8802226e2e00 000000000000afff
[13603.998728]  ffff88022b42501c 000000000000b000 ffff8802224b5000 ffffffff81286fb3
[13603.998734] Call Trace:
[13603.998745]  [<ffffffff813817a0>] ? dump_stack+0x46/0x66
[13603.998753]  [<ffffffff8108ce82>] ? __warn+0xe2/0x100
[13603.998762]  [<ffffffff81286fb3>] ? btrfs_free_reserved_data_space_noquota+0x63/0x80
[13603.998770]  [<ffffffff812a2350>] ? btrfs_clear_bit_hook+0x2d0/0x330
[13603.998776]  [<ffffffff812be660>] ? clear_state_bit+0x60/0x1e0
[13603.998782]  [<ffffffff812be90f>] ? __clear_extent_bit+0x12f/0x390
[13603.998788]  [<ffffffff812bf6dd>] ? extent_clear_unlock_delalloc+0x5d/0x220
[13603.998795]  [<ffffffff8118cea7>] ? cache_grow+0x147/0x220
[13603.998800]  [<ffffffff8118d98c>] ? kmem_cache_alloc+0x12c/0x3e0
[13603.998808]  [<ffffffff811c22d0>] ? igrab+0x10/0x40
[13603.998815]  [<ffffffff812baf57>] ? __btrfs_add_ordered_extent+0x1c7/0x2d0
[13603.998822]  [<ffffffff812a8e8f>] ? submit_compressed_extents+0x41f/0x4e0
[13603.998830]  [<ffffffff812d1c86>] ? btrfs_scrubparity_helper+0x136/0x1c0
[13603.998837]  [<ffffffff810a2bad>] ? process_one_work+0x1bd/0x400
[13603.998843]  [<ffffffff810a2e32>] ? worker_thread+0x42/0x4b0
[13603.998850]  [<ffffffff810a2df0>] ? process_one_work+0x400/0x400
[13603.998856]  [<ffffffff810a8268>] ? kthread+0xb8/0xd0
[13603.998863]  [<ffffffff81747d02>] ? ret_from_fork+0x22/0x40
[13603.998868]  [<ffffffff810a81b0>] ? kthread_worker_fn+0x160/0x160
[13603.998873] ---[ end trace 359dcd25d6847cee ]---
[13603.999155] ------------[ cut here ]------------
[13603.999167] WARNING: CPU: 0 PID: 11291 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0x63/0x80
[13603.999170] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia(PO) [last unloaded: vboxdrv]
[13603.999183] CPU: 0 PID: 11291 Comm: kworker/u12:15 Tainted: P        W  O    4.6.0+ #1
[13603.999186] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[13603.999193] Workqueue: btrfs-delalloc btrfs_delalloc_helper
[13603.999196]  0000000000000000 ffffffff813817a0 0000000000000000 0000000000000000
[13603.999202]  ffffffff8108ce82 0000000000005000 ffff8802226e2e00 0000000000004fff
[13603.999208]  ffff88022b42501c 0000000000005000 ffff8802224b5000 ffffffff81286fb3
[13603.999214] Call Trace:
[13603.999220]  [<ffffffff813817a0>] ? dump_stack+0x46/0x66
[13603.999226]  [<ffffffff8108ce82>] ? __warn+0xe2/0x100
[13603.999234]  [<ffffffff81286fb3>] ? btrfs_free_reserved_data_space_noquota+0x63/0x80
[13603.999241]  [<ffffffff812a2350>] ? btrfs_clear_bit_hook+0x2d0/0x330
[13603.999247]  [<ffffffff812be660>] ? clear_state_bit+0x60/0x1e0
[13603.999252]  [<ffffffff812be90f>] ? __clear_extent_bit+0x12f/0x390
[13603.999258]  [<ffffffff812bf6dd>] ? extent_clear_unlock_delalloc+0x5d/0x220
[13603.999264]  [<ffffffff8118d98c>] ? kmem_cache_alloc+0x12c/0x3e0
[13603.999271]  [<ffffffff811c22d0>] ? igrab+0x10/0x40
[13603.999278]  [<ffffffff812baf57>] ? __btrfs_add_ordered_extent+0x1c7/0x2d0
[13603.999284]  [<ffffffff812a8e8f>] ? submit_compressed_extents+0x41f/0x4e0
[13603.999292]  [<ffffffff812d1c86>] ? btrfs_scrubparity_helper+0x136/0x1c0
[13603.999299]  [<ffffffff810a2bad>] ? process_one_work+0x1bd/0x400
[13603.999305]  [<ffffffff810a2e32>] ? worker_thread+0x42/0x4b0
[13603.999312]  [<ffffffff810a2df0>] ? process_one_work+0x400/0x400
[13603.999317]  [<ffffffff810a8268>] ? kthread+0xb8/0xd0
[13603.999323]  [<ffffffff81747d02>] ? ret_from_fork+0x22/0x40
[13603.999329]  [<ffffffff810a81b0>] ? kthread_worker_fn+0x160/0x160
[13603.999333] ---[ end trace 359dcd25d6847cef ]---
[13634.053259] ------------[ cut here ]------------
[13634.053280] WARNING: CPU: 3 PID: 11291 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0x63/0x80
[13634.053285] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia(PO) [last unloaded: vboxdrv]
[13634.053303] CPU: 3 PID: 11291 Comm: kworker/u12:15 Tainted: P        W  O    4.6.0+ #1
[13634.053308] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[13634.053317] Workqueue: btrfs-delalloc btrfs_delalloc_helper
[13634.053321]  0000000000000000 ffffffff813817a0 0000000000000000 0000000000000000
[13634.053329]  ffffffff8108ce82 0000000000003000 ffff8802226e2e00 0000000000002fff
[13634.053335]  ffff88022ecda41c 0000000000003000 ffff880227035800 ffffffff81286fb3
[13634.053341] Call Trace:
[13634.053351]  [<ffffffff813817a0>] ? dump_stack+0x46/0x66
[13634.053359]  [<ffffffff8108ce82>] ? __warn+0xe2/0x100
[13634.053368]  [<ffffffff81286fb3>] ? btrfs_free_reserved_data_space_noquota+0x63/0x80
[13634.053376]  [<ffffffff812a2350>] ? btrfs_clear_bit_hook+0x2d0/0x330
[13634.053382]  [<ffffffff812be660>] ? clear_state_bit+0x60/0x1e0
[13634.053388]  [<ffffffff812be90f>] ? __clear_extent_bit+0x12f/0x390
[13634.053394]  [<ffffffff812bf6dd>] ? extent_clear_unlock_delalloc+0x5d/0x220
[13634.053401]  [<ffffffff8118d98c>] ? kmem_cache_alloc+0x12c/0x3e0
[13634.053408]  [<ffffffff811c22d0>] ? igrab+0x10/0x40
[13634.053416]  [<ffffffff812baf57>] ? __btrfs_add_ordered_extent+0x1c7/0x2d0
[13634.053422]  [<ffffffff812a8e8f>] ? submit_compressed_extents+0x41f/0x4e0
[13634.053430]  [<ffffffff812d1c86>] ? btrfs_scrubparity_helper+0x136/0x1c0
[13634.053437]  [<ffffffff810a2bad>] ? process_one_work+0x1bd/0x400
[13634.053444]  [<ffffffff810a2e32>] ? worker_thread+0x42/0x4b0
[13634.053450]  [<ffffffff810a2df0>] ? process_one_work+0x400/0x400
[13634.053456]  [<ffffffff810a8268>] ? kthread+0xb8/0xd0
[13634.053464]  [<ffffffff81747d02>] ? ret_from_fork+0x22/0x40
[13634.053470]  [<ffffffff810a81b0>] ? kthread_worker_fn+0x160/0x160
[13634.053474] ---[ end trace 359dcd25d6847cf0 ]---
[13646.118422] BTRFS info (device sda1): btrfs_destroy_inode: leftover csum_bytes

Here's another run on an untainted kernel built with frame pointers etc:

./dammitdave foo
[  236.500257] ------------[ cut here ]------------
[  236.500280] WARNING: CPU: 3 PID: 2940 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xdd/0x160
[  236.500285] Modules linked in:
[  236.500295] CPU: 3 PID: 2940 Comm: dammit Not tainted 4.6.0debug+ #1
[  236.500301] Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
[  236.500306]  0000000000000000 0000000042ec2fb0 ffff88022d5ffbd8 ffffffff816b1920
[  236.500315]  ffffffff81f86e3f 0000000042ec2fb0 0000000000000000 0000000000000000
[  236.500322]  ffff88022d5ffc20 ffffffff81118c2c ffff88022dfd4000 0000108900000000
[  236.500330] Call Trace:
[  236.500342]  [<ffffffff816b1920>] dump_stack+0x60/0xa0
[  236.500352]  [<ffffffff81118c2c>] __warn+0x10c/0x150
[  236.500360]  [<ffffffff81118d78>] warn_slowpath_null+0x18/0x20
[  236.500368]  [<ffffffff814e389d>] btrfs_free_reserved_data_space_noquota+0xdd/0x160
[  236.500376]  [<ffffffff814e3942>] btrfs_free_reserved_data_space+0x22/0x40
[  236.500385]  [<ffffffff8152eb78>] __btrfs_buffered_write+0x748/0xa20
[  236.500394]  [<ffffffff81624bdc>] ? security_inode_need_killpriv+0x3c/0x60
[  236.500401]  [<ffffffff815345ef>] btrfs_file_write_iter+0x4ff/0xb90
[  236.500410]  [<ffffffff81341847>] __vfs_write+0x117/0x1d0
[  236.500417]  [<ffffffff8134317d>] vfs_write+0xdd/0x290
[  236.500425]  [<ffffffff813748bd>] ? __fget_light+0x4d/0x120
[  236.500432]  [<ffffffff813453ee>] SyS_pwrite64+0x9e/0xc0
[  236.500441]  [<ffffffff81db989f>] entry_SYSCALL_64_fastpath+0x17/0x93
[  236.500446] ---[ end trace 7df747a6a0962ae6 ]---
rm foo
[  323.851851] BTRFS info (device sda1): btrfs_destroy_inode: leftover csum_bytes

-- 
A tit a day keeps the vet away.
