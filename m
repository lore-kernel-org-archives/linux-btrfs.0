Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:40992 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3CRTvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 15:51:23 -0400
Message-ID: <51476EA7.9060607@profihost.ag>
Date: Mon, 18 Mar 2013 20:44:39 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: vanilla 3.8.3: btrfs: block rsv returned -28
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

while testing btrfs with 3.8.3 i'm seeing this one several times. Is it 
known?

WARNING: at fs/btrfs/extent-tree.c:6337 use_block_rsv+0x19d/0x1a0 [btrfs]()
Hardware name: X9SCI/X9SCA
btrfs: block rsv returned -28
Modules linked in: btrfs zlib_deflate lzo_compress tun sha256_generic 
cpufreq_ondemand dm_crypt usbhid acpi_cpufreq mperf kvm_intel kvm 
ehci_pci ehci_hcd usbcore microcode usb_common button nls_utf8 coretemp 
loop ext4 mbcache jbd2 crc16 dm_mod sd_mod ahci ghash_clmulni_intel 
libahci fan e1000e aacraid
Pid: 21942, comm: sync Tainted: G        W    3.8.3+3-ph #1
Call Trace:
  [<ffffffff8104c5da>] warn_slowpath_common+0x7a/0xb0
  [<ffffffff8104c6b1>] warn_slowpath_fmt+0x41/0x50
  [<ffffffffa03a378d>] use_block_rsv+0x19d/0x1a0 [btrfs]
  [<ffffffffa03a7a28>] btrfs_alloc_free_block+0x38/0x220 [btrfs]
  [<ffffffffa03f9d90>] ? add_delayed_ref_head+0xd0/0x140 [btrfs]
  [<ffffffff8112f32e>] ? kmem_cache_free+0x2e/0x140
  [<ffffffffa03cc47f>] ? btrfs_get_token_64+0x5f/0xf0 [btrfs]
  [<ffffffffa03cfb83>] ? read_extent_buffer+0xb3/0x110 [btrfs]
  [<ffffffffa0391ead>] __btrfs_cow_block+0x11d/0x510 [btrfs]
  [<ffffffffa0392911>] btrfs_cow_block+0x121/0x1d0 [btrfs]
  [<ffffffffa0397462>] btrfs_search_slot+0x372/0x800 [btrfs]
  [<ffffffffa03ab569>] btrfs_del_csums+0x249/0x330 [btrfs]
  [<ffffffffa03d1537>] ? free_extent_buffer+0x37/0x90 [btrfs]
  [<ffffffffa03a5a04>] __btrfs_free_extent+0x5b4/0x850 [btrfs]
  [<ffffffff81084b10>] ? set_next_entity+0x90/0xa0
  [<ffffffffa03a5f51>] run_delayed_data_ref+0x151/0x160 [btrfs]
  [<ffffffffa03a6016>] run_one_delayed_ref+0xb6/0xc0 [btrfs]
  [<ffffffffa03f99d9>] ? btrfs_check_delayed_seq+0x29/0xa0 [btrfs]
  [<ffffffffa03a612e>] run_clustered_refs+0x10e/0x3b0 [btrfs]
  [<ffffffffa03a6498>] btrfs_run_delayed_refs+0xc8/0x2f0 [btrfs]
  [<ffffffffa03b74a3>] btrfs_commit_transaction+0x93/0xa00 [btrfs]
  [<ffffffff81080ba0>] ? try_to_wake_up+0x2a0/0x2a0
  [<ffffffffa03b8294>] ? start_transaction+0xa4/0x460 [btrfs]
  [<ffffffff8106f500>] ? wake_up_bit+0x40/0x40
  [<ffffffffa038c84d>] btrfs_sync_fs+0x5d/0xd0 [btrfs]
  [<ffffffff8116a8c0>] ? sys_vmsplice+0xf0/0xf0
  [<ffffffff8116a8db>] sync_fs_one_sb+0x1b/0x20
  [<ffffffff8114128b>] iterate_supers+0xab/0xf0
  [<ffffffff8116ad30>] sys_sync+0x50/0x90
  [<ffffffff81507669>] system_call_fastpath+0x16/0x1b
---[ end trace dc6aa83c5fc7b36a ]---
use_block_rsv: 174 callbacks suppressed
------------[ cut here ]------------


Stefan
