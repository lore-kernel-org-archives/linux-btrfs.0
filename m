Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43692 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2EWI40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 04:56:26 -0400
Received: by bkcji2 with SMTP id ji2so5732521bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 01:56:24 -0700 (PDT)
Date: Wed, 23 May 2012 12:56:21 +0400
From: Tomash Brechko <tomash.brechko@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [BUG] kernel crash when storage goes offline
Message-ID: <20120523085556.GA13850@sora.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

We are using external SAS storage via LSI MegaRAID SAS 9280-8e
controller.  When storage suddenly goes offline (cable unplug or
expander glitch) the kernel (Fedora 3.3.5-2 64bit) outputs to log lots
of

  kernel: [111163.509223] sd 4:2:2:0: rejecting I/O to offline device

but later crashes with

  ------------[ cut here ]------------
  WARNING: at fs/btrfs/extent-tree.c:4927 __btrfs_free_extent+0x628/0x6d0 [btrfs]()
  Hardware name: S5500WBV
  Modules linked in: binfmt_misc mpt2sas scsi_transport_sas raid_class mptctl mptbase ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c iTCO_wdt i7core_edac igb edac_core i2c_i801 iTCO_vendor_support ioatdma dca joydev i2c_core ses enclosure megaraid_sas [last unloaded: scsi_wait_scan]
  Pid: 1749, comm: btrfs-transacti Not tainted 3.3.5-2.fc16.x86_64 #1
  Call Trace:
   [<ffffffff81057abf>] warn_slowpath_common+0x7f/0xc0
   [<ffffffff81057b1a>] warn_slowpath_null+0x1a/0x20
   [<ffffffffa00e1328>] __btrfs_free_extent+0x628/0x6d0 [btrfs]
   [<ffffffffa00e53a4>] run_clustered_refs+0x424/0x8f0 [btrfs]
   [<ffffffff810902e1>] ? update_curr+0x141/0x1f0
   [<ffffffffa013372b>] ? find_ref_head+0xab/0xe0 [btrfs]
   [<ffffffffa00e59ee>] btrfs_run_delayed_refs+0x17e/0x4a0 [btrfs]
   [<ffffffffa0110590>] ? btrfs_run_ordered_operations+0x1c0/0x1e0 [btrfs]
   [<ffffffffa00f63f4>] btrfs_commit_transaction+0x94/0x820 [btrfs]
   [<ffffffff8107a7d0>] ? remove_wait_queue+0x50/0x50
   [<ffffffffa00f05ad>] transaction_kthread+0x23d/0x2a0 [btrfs]
  sd 4:2:2:0: rejecting I/O to offline device
  sd 4:2:2:0: rejecting I/O to offline device
   [<ffffffffa00f0370>] ? write_dev_supers+0x270/0x270 [btrfs]
   [<ffffffff81079d83>] kthread+0x93/0xa0
   [<ffffffff815fd6a4>] kernel_thread_helper+0x4/0x10
   [<ffffffff81079cf0>] ? kthread_freezable_should_stop+0x70/0x70
   [<ffffffff815fd6a0>] ? gs_change+0x13/0x13
  ---[ end trace 4fd999c522cb517f ]---
  btrfs unable to find ref byte nr 1241473052672 parent 0 root 7  owner 0 offset 0
  BUG: unable to handle kernel NULL pointer dereference at           (null)
  IP: [<ffffffffa01173e2>] map_private_extent_buffer+0x12/0x150 [btrfs]
  PGD 0
  Oops: 0000 [#1] SMP
  CPU 12
  Modules linked in: binfmt_misc mpt2sas scsi_transport_sas raid_class mptctl mptbase ip6t_REJECT nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables btrfs zlib_deflate libcrc32c iTCO_wdt i7core_edac igb edac_core i2c_i801 iTCO_vendor_support ioatdma dca joydev i2c_core ses enclosure megaraid_sas [last unloaded: scsi_wait_scan]
  
  Pid: 1749, comm: btrfs-transacti Tainted: G        W    3.3.5-2.fc16.x86_64 #1 Intel Corporation S5500WBV/S5500WB
  RIP: 0010:[<ffffffffa01173e2>]  [<ffffffffa01173e2>] map_private_extent_buffer+0x12/0x150 [btrfs]
  RSP: 0018:ffff88024cf4daa0  EFLAGS: 00010286
  RAX: 0000000000000000 RBX: 0000000000000065 RCX: ffff88024cf4dad0
  RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
  RBP: ffff88024cf4dac0 R08: ffff88024cf4dad8 R09: ffff88024cf4dae0
  R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000007a
  R13: 0000000000000000 R14: 00000000fffffffb R15: 0000000000001000
  FS:  0000000000000000(0000) GS:ffff880267cc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000000000 CR3: 0000000001c05000 CR4: 00000000000006e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process btrfs-transacti (pid: 1749, threadinfo ffff88024cf4c000, task ffff8802588e5cc0)
  Stack:
   00000000fffffffb 0000000000000065 000000000000007a 0000000000000000
   ffff88024cf4db10 ffffffffa010caac ffff88024cf4db20 ffff88024cf4dae0
   0000000000000007 000001210d8f7000 0000000000000000 ffff88044f00fab0
  Call Trace:
   [<ffffffffa010caac>] btrfs_item_size+0x3c/0x90 [btrfs]
   [<ffffffffa00e0f32>] __btrfs_free_extent+0x232/0x6d0 [btrfs]
   [<ffffffffa00e53a4>] run_clustered_refs+0x424/0x8f0 [btrfs]
   [<ffffffff810902e1>] ? update_curr+0x141/0x1f0
   [<ffffffffa013372b>] ? find_ref_head+0xab/0xe0 [btrfs]
   [<ffffffffa00e59ee>] btrfs_run_delayed_refs+0x17e/0x4a0 [btrfs]
   [<ffffffffa00f63f4>] btrfs_commit_transaction+0x94/0x820 [btrfs]
   [<ffffffff8107a7d0>] ? remove_wait_queue+0x50/0x50
   [<ffffffffa00f05ad>] transaction_kthread+0x23d/0x2a0 [btrfs]
   [<ffffffffa00f0370>] ? write_dev_supers+0x270/0x270 [btrfs]
   [<ffffffff81079d83>] kthread+0x93/0xa0
   [<ffffffff815fd6a4>] kernel_thread_helper+0x4/0x10
  sd 4:2:2:0: rejecting I/O to offline device
   [<ffffffff81079cf0>] ? kthread_freezable_should_stop+0x70/0x70
   [<ffffffff815fd6a0>] ? gs_change+0x13/0x13
  Code: 83 c0 01 48 89 85 78 ff ff ff e9 c0 fc ff ff 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 <4c> 8b 27 4d 89 cd 48 89 cb 41 81 e4 ff 0f 00 00 4a 8d 04 26 4c
  RIP  [<ffffffffa01173e2>] map_private_extent_buffer+0x12/0x150 [btrfs]
   RSP <ffff88024cf4daa0>
  CR2: 0000000000000000
  ---[ end trace 4fd999c522cb5180 ]---


I hope this will be useful.

Regards,

-- 
   Tomash Brechko
