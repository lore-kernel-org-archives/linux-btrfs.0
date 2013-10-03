Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40268 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3JCD2c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Oct 2013 23:28:32 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 27313354740
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Oct 2013 05:28:29 +0200 (CEST)
Received: from [10.3.0.10] (srv1.virtall.com [78.46.87.16])
	by mail.virtall.com (Postfix) with ESMTPSA id 30E5535473F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Oct 2013 05:28:27 +0200 (CEST)
Message-ID: <524CE458.2040807@wpkg.org>
Date: Thu, 03 Oct 2013 12:28:24 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: WARNING at fs/btrfs/extent_io.c:211, kernel BUG at fs/btrfs/extent_io.c:509!
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this rather lengthy trace with 3.12-rc3.

Full output at http://wpkg.org/btrfs.txt (14 MB):

Oct  2 22:34:57 bkp010 kernel: [38059.449633] BTRFS debug (device sdb5): truncated 1 orphans
Oct  3 00:15:21 bkp010 kernel: [44080.512456] ------------[ cut here ]------------
Oct  3 00:15:21 bkp010 kernel: [44080.512484] WARNING: CPU: 2 PID: 796 at fs/btrfs/extent_io.c:211 free_extent_state.part.35+0x21/0x34 [btrfs]()
Oct  3 00:15:21 bkp010 kernel: [44080.512498] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd i2c_i801 acpi_cpufreq pcspkr freq_table video lpc_ich mfd_core button i2c_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
Oct  3 00:15:21 bkp010 kernel: [44080.512592] CPU: 2 PID: 796 Comm: rsync Not tainted 3.12.0-rc3 #2
Oct  3 00:15:21 bkp010 kernel: [44080.512602] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Oct  3 00:15:21 bkp010 kernel: [44080.512616]  0000000000000009 ffff880124349958 ffffffff8138156b 0000000000000006
Oct  3 00:15:21 bkp010 kernel: [44080.512708]  0000000000000000 ffff880124349998 ffffffff810366c1 ffff8801243499d8
Oct  3 00:15:21 bkp010 kernel: [44080.512800]  ffffffffa02ad67c ffff88027d966c60 0000000000001000 0000000000000000
Oct  3 00:15:21 bkp010 kernel: [44080.512893] Call Trace:
Oct  3 00:15:21 bkp010 kernel: [44080.512941]  [<ffffffff8138156b>] dump_stack+0x46/0x58
Oct  3 00:15:21 bkp010 kernel: [44080.512991]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
Oct  3 00:15:21 bkp010 kernel: [44080.513050]  [<ffffffffa02ad67c>] ? free_extent_state.part.35+0x21/0x34 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513140]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
Oct  3 00:15:21 bkp010 kernel: [44080.513199]  [<ffffffffa02ad67c>] free_extent_state.part.35+0x21/0x34 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513258]  [<ffffffffa02adbc9>] free_extent_state+0x19/0x1b [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513315]  [<ffffffffa02af37c>] find_lock_delalloc_range.constprop.45+0x8d/0x1a5 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513414]  [<ffffffffa02b0c39>] __extent_writepage+0x17e/0x5b6 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513473]  [<ffffffffa02e09c8>] ? __resolve_indirect_refs+0x457/0x47c [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513564]  [<ffffffff810ac5ac>] ? find_get_pages_tag+0xe9/0x123
Oct  3 00:15:21 bkp010 kernel: [44080.513621]  [<ffffffffa02b1227>] extent_write_cache_pages.isra.31.constprop.49+0x1b6/0x2fa [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513715]  [<ffffffff810ae47f>] ? find_get_pages+0xda/0xfb
Oct  3 00:15:21 bkp010 kernel: [44080.513774]  [<ffffffffa02a22c8>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513825]  [<ffffffff811a1e73>] ? radix_tree_lookup_slot+0xe/0x10
Oct  3 00:15:21 bkp010 kernel: [44080.513883]  [<ffffffffa02b15f9>] extent_writepages+0x46/0x57 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513940]  [<ffffffffa029b434>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.513996]  [<ffffffffa029a615>] btrfs_writepages+0x23/0x25 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.514047]  [<ffffffff810b5678>] do_writepages+0x19/0x27
Oct  3 00:15:21 bkp010 kernel: [44080.514096]  [<ffffffff810ad361>] __filemap_fdatawrite_range+0x4e/0x50
Oct  3 00:15:21 bkp010 kernel: [44080.514145]  [<ffffffff810adeb8>] filemap_fdatawrite_range+0xe/0x10
Oct  3 00:15:21 bkp010 kernel: [44080.514202]  [<ffffffffa02aca81>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.514260]  [<ffffffffa029feb9>] btrfs_truncate+0x46/0x21b [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.514315]  [<ffffffffa02a08ee>] btrfs_setattr+0x196/0x281 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.514366]  [<ffffffff81107e9d>] notify_change+0x1d5/0x2bf
Oct  3 00:15:21 bkp010 kernel: [44080.514415]  [<ffffffff81121b55>] ? fsnotify+0x259/0x2ae
Oct  3 00:15:21 bkp010 kernel: [44080.514466]  [<ffffffff810f075b>] do_truncate+0x60/0x85
Oct  3 00:15:21 bkp010 kernel: [44080.514514]  [<ffffffff810f0a75>] do_sys_ftruncate.constprop.15+0x119/0x12d
Oct  3 00:15:21 bkp010 kernel: [44080.514565]  [<ffffffff810f0aab>] SyS_ftruncate+0x9/0xb
Oct  3 00:15:21 bkp010 kernel: [44080.514613]  [<ffffffff813863a2>] system_call_fastpath+0x16/0x1b
Oct  3 00:15:21 bkp010 kernel: [44080.514662] ---[ end trace 00035cab7b970764 ]---
Oct  3 00:15:21 bkp010 kernel: [44080.514709] ------------[ cut here ]------------
Oct  3 00:15:21 bkp010 kernel: [44080.514763] WARNING: CPU: 2 PID: 796 at fs/btrfs/extent_io.c:211 free_extent_state.part.35+0x21/0x34 [btrfs]()
Oct  3 00:15:21 bkp010 kernel: [44080.514855] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd i2c_i801 acpi_cpufreq pcspkr freq_table video lpc_ich mfd_core button i2c_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
Oct  3 00:15:21 bkp010 kernel: [44080.515181] CPU: 2 PID: 796 Comm: rsync Tainted: G        W    3.12.0-rc3 #2
Oct  3 00:15:21 bkp010 kernel: [44080.515230] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Oct  3 00:15:21 bkp010 kernel: [44080.515322]  0000000000000009 ffff880124349958 ffffffff8138156b 0000000000000006
Oct  3 00:15:21 bkp010 kernel: [44080.515415]  0000000000000000 ffff880124349998 ffffffff810366c1 ffff8801243499d8
Oct  3 00:15:21 bkp010 kernel: [44080.515506]  ffffffffa02ad67c ffff88027d966c60 0000000008000000 0000000000000001
Oct  3 00:15:21 bkp010 kernel: [44080.515598] Call Trace:
Oct  3 00:15:21 bkp010 kernel: [44080.515645]  [<ffffffff8138156b>] dump_stack+0x46/0x58
Oct  3 00:15:21 bkp010 kernel: [44080.515693]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
Oct  3 00:15:21 bkp010 kernel: [44080.515751]  [<ffffffffa02ad67c>] ? free_extent_state.part.35+0x21/0x34 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.515841]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
Oct  3 00:15:21 bkp010 kernel: [44080.515899]  [<ffffffffa02ad67c>] free_extent_state.part.35+0x21/0x34 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.515957]  [<ffffffffa02adbc9>] free_extent_state+0x19/0x1b [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516014]  [<ffffffffa02af3c9>] find_lock_delalloc_range.constprop.45+0xda/0x1a5 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516112]  [<ffffffffa02b0c39>] __extent_writepage+0x17e/0x5b6 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516171]  [<ffffffffa02e09c8>] ? __resolve_indirect_refs+0x457/0x47c [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516262]  [<ffffffff810ac5ac>] ? find_get_pages_tag+0xe9/0x123
Oct  3 00:15:21 bkp010 kernel: [44080.516319]  [<ffffffffa02b1227>] extent_write_cache_pages.isra.31.constprop.49+0x1b6/0x2fa [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516411]  [<ffffffff810ae47f>] ? find_get_pages+0xda/0xfb
Oct  3 00:15:21 bkp010 kernel: [44080.516469]  [<ffffffffa02a22c8>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516520]  [<ffffffff811a1e73>] ? radix_tree_lookup_slot+0xe/0x10
Oct  3 00:15:21 bkp010 kernel: [44080.516577]  [<ffffffffa02b15f9>] extent_writepages+0x46/0x57 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516634]  [<ffffffffa029b434>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516689]  [<ffffffffa029a615>] btrfs_writepages+0x23/0x25 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516740]  [<ffffffff810b5678>] do_writepages+0x19/0x27
Oct  3 00:15:21 bkp010 kernel: [44080.516788]  [<ffffffff810ad361>] __filemap_fdatawrite_range+0x4e/0x50
Oct  3 00:15:21 bkp010 kernel: [44080.516838]  [<ffffffff810adeb8>] filemap_fdatawrite_range+0xe/0x10
Oct  3 00:15:21 bkp010 kernel: [44080.516895]  [<ffffffffa02aca81>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.516953]  [<ffffffffa029feb9>] btrfs_truncate+0x46/0x21b [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.517009]  [<ffffffffa02a08ee>] btrfs_setattr+0x196/0x281 [btrfs]
Oct  3 00:15:21 bkp010 kernel: [44080.517059]  [<ffffffff81107e9d>] notify_change+0x1d5/0x2bf
Oct  3 00:15:21 bkp010 kernel: [44080.517107]  [<ffffffff81121b55>] ? fsnotify+0x259/0x2ae
Oct  3 00:15:21 bkp010 kernel: [44080.517156]  [<ffffffff810f075b>] do_truncate+0x60/0x85
Oct  3 00:15:21 bkp010 kernel: [44080.517205]  [<ffffffff810f0a75>] do_sys_ftruncate.constprop.15+0x119/0x12d
Oct  3 00:15:21 bkp010 kernel: [44080.517255]  [<ffffffff810f0aab>] SyS_ftruncate+0x9/0xb
Oct  3 00:15:21 bkp010 kernel: [44080.517303]  [<ffffffff813863a2>] system_call_fastpath+0x16/0x1b
Oct  3 00:15:21 bkp010 kernel: [44080.517351] ---[ end trace 00035cab7b970765 ]---


-- 
Tomasz Chmielewski
http://wpkg.org
