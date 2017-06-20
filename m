Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39823 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdFTOj0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 10:39:26 -0400
Date: Tue, 20 Jun 2017 07:39:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170620143916.GA22987@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My filesystem got remounted read only, and yet after a lengthy
btrfs check --repair, it ran clean.

Any idea what went wrong?
[846332.992285] WARNING: CPU: 4 PID: 4095 at fs/btrfs/free-space-cache.c:1476 tree_insert_offset+0x78/0xb1
[846333.744721] BTRFS critical (device dm-1): unable to add free space :-17
[847312.529660] BTRFS: Transaction aborted (error -17)
[847313.218391] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:2961: errno=-17 Object already exists
[847313.247668] BTRFS info (device dm-1): forced readonly

gargamel:~# btrfs check --repair /dev/mapper/dshelf2
enabling repair mode
Checking filesystem on /dev/mapper/dshelf2
UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 5544539336704 bytes used, no error found
total csum bytes: 5344305964
total tree bytes: 70455754752
total fs tree bytes: 58427670528
total extent tree bytes: 5372461056
btree space waste bytes: 10620592981
file data blocks allocated: 7735818444800
 referenced 6155805896704


this is how it went read only:
[846332.977964] ------------[ cut here ]------------
[846332.992285] WARNING: CPU: 4 PID: 4095 at fs/btrfs/free-space-cache.c:1476 tree_insert_offset+0x78/0xb1
[846333.402648] CPU: 4 PID: 4095 Comm: btrfs-transacti Tainted: G     U          4.11.3-amd64-preempt-sysrq-20170406 #5
[846333.434917] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[846333.463597] Call Trace:
[846333.469942] usb 2-1-port4: device 2-1.4 not suspended yet
[846333.489639]  dump_stack+0x61/0x7d
[846333.500480]  __warn+0xc2/0xdd
[846333.510956]  warn_slowpath_null+0x1d/0x1f
[846333.524103]  tree_insert_offset+0x78/0xb1
[846333.537337]  link_free_space+0x2c/0x41
[846333.549991]  __btrfs_add_free_space+0x89/0x3aa
[846333.564236]  ? kmem_cache_free+0x3d/0x92
[846333.577702]  btrfs_add_free_space+0x1d/0x1f
[846333.591179]  unpin_extent_range+0xf3/0x2b0
[846333.605220]  btrfs_finish_extent_commit+0xda/0x1d4
[846333.621324]  btrfs_commit_transaction+0x629/0x79a
[846333.637205]  ? add_wait_queue+0x44/0x44
[846333.649680]  transaction_kthread+0xe2/0x178
[846333.663201]  ? btrfs_cleanup_transaction+0x3e8/0x3e8
[846333.679033]  kthread+0xfb/0x100
[846333.690261]  ? init_completion+0x24/0x24
[846333.703239]  ? do_fast_syscall_32+0xb7/0xfe
[846333.717649]  ret_from_fork+0x2c/0x40
[846333.729656] ---[ end trace 27aa532d1886e536 ]---
[846333.744721] BTRFS critical (device dm-1): unable to add free space :-17

[847312.529660] BTRFS: Transaction aborted (error -17)
[847312.912784] CPU: 6 PID: 4094 Comm: btrfs-cleaner Tainted: G     U  W       4.11.3-amd64-preempt-sysrq-20170406 #5
[847312.913132] usb 2-1-port4: device 2-1.4 not suspended yet
[847312.962394] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[847312.990936] Call Trace:
[847312.999347]  dump_stack+0x61/0x7d
[847313.010383]  __warn+0xc2/0xdd
[847313.020351]  warn_slowpath_fmt+0x5a/0x76
[847313.033274]  btrfs_run_delayed_refs+0xb1/0x1cc
[847313.047655]  btrfs_should_end_transaction+0x50/0x57
[847313.063910]  btrfs_drop_snapshot+0x38a/0x6c4
[847313.078619]  ? btrfs_kill_all_delayed_nodes+0x5f/0xd7
[847313.094916]  ? _raw_spin_lock+0x15/0x17
[847313.108325]  btrfs_clean_one_deleted_snapshot+0xce/0xdc
[847313.125493]  cleaner_kthread+0x91/0x14b
[847313.138228]  ? btrfs_destroy_pinned_extent+0xd2/0xd2
[847313.154308]  kthread+0xfb/0x100
[847313.164900]  ? init_completion+0x24/0x24
[847313.177781]  ? do_fast_syscall_32+0xb7/0xfe
[847313.191490]  ret_from_fork+0x2c/0x40
[847313.203432] ---[ end trace 27aa532d1886e537 ]---
[847313.218391] BTRFS: error (device dm-1) in btrfs_run_delayed_refs:2961: errno=-17 Object already exists
[847313.247668] BTRFS info (device dm-1): forced readonly

[849789.173126] BTRFS error (device dm-1): parent transid verify failed on 1935589703680 wanted 37959 found 3229
[849789.218675] BTRFS error (device dm-1): parent transid verify failed on 1935589703680 wanted 37959 found 3229

[863279.783590] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.827526] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.857797] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.888096] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.918393] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.948740] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863279.979033] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863280.009362] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863280.040438] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634
[863280.070966] BTRFS error (device dm-1): parent transid verify failed on 1932065177600 wanted 37959 found 3634

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
