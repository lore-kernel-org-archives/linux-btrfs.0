Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:59119 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3LQGEG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 01:04:06 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id B20DA3A6374
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 06:55:53 +0100 (CET)
Received: from localhost (em1-115-198-76.pool.e-mobile.ne.jp [1.115.198.76])
	by mail.virtall.com (Postfix) with ESMTPSA id 28AA23A636C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 06:55:51 +0100 (CET)
Date: Tue, 17 Dec 2013 14:55:43 +0900
From: Tomasz Chmielewski <tch@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34
 [btrfs]()
Message-ID: <20131217145543.7cfd90b5@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting these quite easily after upgrading to 3.13-rc4.

The server is no longer responsive and needs to be hard rebooted:

[  822.391224] ------------[ cut here ]------------
[  822.391282] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.391327] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.392976] CPU: 1 PID: 8115 Comm: rsync Not tainted 3.12.0-rc4 #1
[  822.393055] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.393178]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.393425]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.393673]  ffffffffa0263674 ffff8807361cdea0 0000000000001000 0000000000000000
[  822.393919] Call Trace:
[  822.393998]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.394089]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.394180]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.394301]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.394390]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.394481]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.394571]  [<ffffffffa0265374>] find_lock_delalloc_range.constprop.46+0x8d/0x1a5 [btrfs]
[  822.394703]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.394837]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.394919]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.395008]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.395133]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.395220]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.395303]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.395392]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.395482]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.395571]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.395653]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.395733]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.395815]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.395903]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.395994]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.396083]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.396165]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.396245]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.396325]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.396406]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.396487]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.396569]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.396649] ---[ end trace f5a9ac7b520da966 ]---
[  822.396726] ------------[ cut here ]------------
[  822.396814] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.396938] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.398793] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.398874] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.398996]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.399245]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.399493]  ffffffffa0263674 ffff8807361cdea0 0000000008000000 0000000000000001
[  822.399741] Call Trace:
[  822.399818]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.399898]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.399988]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.400110]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.400199]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.400289]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.400378]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.400509]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.400640]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.400722]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.400811]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.400935]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.401023]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.401105]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.401194]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.401283]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.401371]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.401453]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.401533]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.401614]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.401703]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.401793]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.401885]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.401966]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.402048]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.402128]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.402208]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.402289]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.402369]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.402449] ---[ end trace f5a9ac7b520da967 ]---
[  822.402527] ------------[ cut here ]------------
[  822.402614] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.402737] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.404596] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.404677] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.404800]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 00000000000000cf
[  822.405048]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.405296]  ffffffffa0263674 ffff8807361cdea0 0000000000001000 0000000000000001
[  822.405544] Call Trace:
[  822.405621]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.405701]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.405791]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.405913]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.406003]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.406093]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.406182]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.406313]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.406443]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.406525]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.406614]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.406738]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.406827]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.406909]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.406999]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.407087]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.407174]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.407256]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.407336]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.407417]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.407507]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.407596]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.407685]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.407766]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.407846]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.407927]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.408007]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.408088]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.408168]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.408247] ---[ end trace f5a9ac7b520da968 ]---
[  822.408325] ------------[ cut here ]------------
[  822.408413] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.409655] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.411508] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.411590] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.411712]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.411960]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.412208]  ffffffffa0263674 ffff8807361cdea0 0000000008000000 0000000000000001
[  822.412456] Call Trace:
[  822.412533]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.412613]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.412703]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.412825]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.412914]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.413004]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.413094]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.413224]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.413356]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.413438]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.413527]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.413651]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.413739]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.413821]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.413910]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.414006]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.414094]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.414175]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.414255]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.414337]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.414427]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.414516]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.414605]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.414691]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.414775]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.414856]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.414936]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.415018]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.415098]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.415178] ---[ end trace f5a9ac7b520da969 ]---
[  822.415256] ------------[ cut here ]------------
[  822.415343] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.415465] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.417298] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.417379] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.417501]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.417748]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.417995]  ffffffffa0263674 ffff8807361cdea0 0000000000001000 0000000000000001
[  822.418241] Call Trace:
[  822.418318]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.418398]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.418488]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.418610]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.418701]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.418792]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.418881]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.419011]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.419142]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.419224]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.419313]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.419437]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.419524]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.419606]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.419695]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.419785]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.419872]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.419954]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.420033]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.420115]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.420204]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.420293]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.420381]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.420463]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.420543]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.420623]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.420703]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.420785]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.420864]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.420944] ---[ end trace f5a9ac7b520da96a ]---
[  822.421022] ------------[ cut here ]------------
[  822.421110] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.421233] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.423084] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.423165] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.423287]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.423536]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.423784]  ffffffffa0263674 ffff8807361cdea0 0000000008000000 0000000000000001
[  822.424039] Call Trace:
[  822.424116]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.424197]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.424287]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.424409]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.424498]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.424588]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.424679]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.424810]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.424941]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.425023]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.425112]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.425236]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.425323]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.425406]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.425495]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.425584]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.425672]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.425754]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.425834]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.425915]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.426005]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.426094]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.426183]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.426265]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.426345]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.426425]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.426505]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.426586]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.426666]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.426745] ---[ end trace f5a9ac7b520da96b ]---
[  822.426823] ------------[ cut here ]------------
[  822.426910] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.427033] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.428884] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.428965] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.429088]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.429336]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.429585]  ffffffffa0263674 ffff8807361cdea0 0000000000001000 0000000000000001
[  822.429833] Call Trace:
[  822.429910]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.429991]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.430080]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.431325]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.431414]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.431505]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.431595]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.431725]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.431857]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.431939]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.432029]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.432153]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.432242]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.432324]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.432413]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.432502]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.432590]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.432671]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.432751]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.432832]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.432922]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.433011]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.433099]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.433181]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.433262]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.433342]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.433422]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.433504]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.433584]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.433663] ---[ end trace f5a9ac7b520da96c ]---
[  822.433742] ------------[ cut here ]------------
[  822.433830] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.433953] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.435816] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.435897] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.436020]  0000000000000009 ffff88075ebb3958 ffffffff8138176b ffff88081fa4d958
[  822.436268]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.436516]  ffffffffa0263674 ffff8807361cdea0 0000000008000000 0000000000000001
[  822.436764] Call Trace:
[  822.436840]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.436920]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.437010]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.437132]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.437220]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.437311]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.437400]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.437531]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.437662]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.437744]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.437834]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.437957]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.438045]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.438127]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.438216]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.438305]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.438392]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.438474]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.438553]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.438635]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.438725]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.438814]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.438903]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.438985]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.439065]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.439145]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.439225]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.439307]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.439387]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.439466] ---[ end trace f5a9ac7b520da96d ]---
[  822.439544] ------------[ cut here ]------------
[  822.439631] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.439754] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.441605] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.441686] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.441808]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.442056]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.442304]  ffffffffa0263674 ffff8807361cdea0 0000000000001000 0000000000000001
[  822.442553] Call Trace:
[  822.442630]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.442711]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.442800]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.442922]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.443012]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.443103]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.443192]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.443323]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.443454]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.443535]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.443625]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.443749]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.443836]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.443918]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.444014]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.444103]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.444190]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.444272]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.444352]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.444434]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.444522]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.444612]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.444701]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.444782]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.444862]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.444943]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.445023]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.445105]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.445184]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.445264] ---[ end trace f5a9ac7b520da96e ]---
[  822.445342] ------------[ cut here ]------------
[  822.445429] WARNING: CPU: 1 PID: 8115 at fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
[  822.445552] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  822.447404] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  822.447485] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  822.447607]  0000000000000009 ffff88075ebb3958 ffffffff8138176b 0000000000000006
[  822.447855]  0000000000000000 ffff88075ebb3998 ffffffff810366c1 ffff88075ebb39d8
[  822.448103]  ffffffffa0263674 ffff8807361cdea0 0000000008000000 0000000000000001
[  822.448351] Call Trace:
[  822.448428]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[  822.448508]  [<ffffffff810366c1>] warn_slowpath_common+0x77/0x91
[  822.448597]  [<ffffffffa0263674>] ? free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.448721]  [<ffffffff810366f0>] warn_slowpath_null+0x15/0x17
[  822.448810]  [<ffffffffa0263674>] free_extent_state.part.36+0x21/0x34 [btrfs]
[  822.448898]  [<ffffffffa0263bc1>] free_extent_state+0x19/0x1b [btrfs]
[  822.448986]  [<ffffffffa02653c1>] find_lock_delalloc_range.constprop.46+0xda/0x1a5 [btrfs]
[  822.449117]  [<ffffffffa026548a>] ? find_lock_delalloc_range.constprop.46+0x1a3/0x1a5 [btrfs]
[  822.449248]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  822.449332]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  822.449420]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  822.449544]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  822.449631]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  822.449716]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  822.449805]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  822.449893]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  822.449981]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  822.450062]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  822.450144]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  822.450225]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  822.450313]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  822.451531]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  822.451620]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  822.451703]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  822.451785]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  822.451865]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  822.451944]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  822.452026]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  822.452106]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  822.452186] ---[ end trace f5a9ac7b520da96f ]---
[  847.709074] BUG: soft lockup - CPU#7 stuck for 22s! [kworker/u16:1:6022]
[  847.709076] BUG: soft lockup - CPU#1 stuck for 22s! [rsync:8115]
[  847.709092] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  847.709093] CPU: 1 PID: 8115 Comm: rsync Tainted: G        W    3.12.0-rc4 #1
[  847.709094] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  847.709095] task: ffff88077c83ae20 ti: ffff88075ebb2000 task.ti: ffff88075ebb2000
[  847.709099] RIP: 0010:[<ffffffff81385b2a>]  [<ffffffff81385b2a>] _raw_spin_lock+0x17/0x21
[  847.709099] RSP: 0018:ffff88075ebb3968  EFLAGS: 00000297
[  847.709100] RAX: 000000000000abab RBX: 0000000000000000 RCX: 0000000000001000
[  847.709100] RDX: 00000000000000ab RSI: ffff88075ebb3a10 RDI: ffff880735f8a4b4
[  847.709101] RBP: ffff88075ebb3968 R08: ffff88075ebb3a20 R09: ffffea001cd87340
[  847.709110] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  847.709110] R13: 0000000000008001 R14: 000ffff8807361cd R15: 0000000000000000
[  847.709111] FS:  00007ff26b455700(0000) GS:ffff88081fa40000(0000) knlGS:0000000000000000
[  847.709111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  847.709112] CR2: 00007fd2aa393f30 CR3: 000000075bd25000 CR4: 00000000001407e0
[  847.709112] Stack:
[  847.709113]  ffff88075ebb39d8 ffffffffa026396e 0000000000000000 ffff88075ebb3a20
[  847.709114]  0000000000001000 0000000013554000 0000000000000000 ffff8807361cdeb0
[  847.709115]  ffff8807361cdea0 ffff88075ebb3b20 0000000000001000 0000000000000001
[  847.709115] Call Trace:
[  847.709126]  [<ffffffffa026396e>] find_delalloc_range+0x2e/0x12a [btrfs]
[  847.709133]  [<ffffffffa026534d>] find_lock_delalloc_range.constprop.46+0x66/0x1a5 [btrfs]
[  847.709138]  [<ffffffffa0265488>] ? find_lock_delalloc_range.constprop.46+0x1a1/0x1a5 [btrfs]
[  847.709144]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  847.709146]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  847.709151]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  847.709152]  [<ffffffff810ae4cf>] ? find_get_pages+0xda/0xfb
[  847.709158]  [<ffffffffa02582c0>] ? btrfs_invalidatepage+0x4e/0x1c0 [btrfs]
[  847.709160]  [<ffffffff811a1e5f>] ? radix_tree_lookup_slot+0xe/0x10
[  847.709165]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  847.709171]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  847.709176]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  847.709178]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  847.709179]  [<ffffffff810ad3b1>] __filemap_fdatawrite_range+0x4e/0x50
[  847.709180]  [<ffffffff810adf08>] filemap_fdatawrite_range+0xe/0x10
[  847.709185]  [<ffffffffa0262a79>] btrfs_wait_ordered_range+0x47/0xd7 [btrfs]
[  847.709191]  [<ffffffffa0255eb1>] btrfs_truncate+0x46/0x21b [btrfs]
[  847.709196]  [<ffffffffa02568e6>] btrfs_setattr+0x196/0x281 [btrfs]
[  847.709198]  [<ffffffff81107f85>] notify_change+0x1d5/0x2bf
[  847.709199]  [<ffffffff81121c3d>] ? fsnotify+0x259/0x2ae
[  847.709201]  [<ffffffff810f0827>] do_truncate+0x60/0x85
[  847.709202]  [<ffffffff810f0b41>] do_sys_ftruncate.constprop.15+0x119/0x12d
[  847.709204]  [<ffffffff810f0b77>] SyS_ftruncate+0x9/0xb
[  847.709205]  [<ffffffff813865a2>] system_call_fastpath+0x16/0x1b
[  847.709213] Code: 48 8b 7d f8 f0 81 2f 00 00 10 00 74 05 e8 bf 2e e2 ff c9 c3 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 74 0a 8a 07 <38> d0 74 04 f3 90 eb f6 5d c3 55 48 89 e5 9c 58 fa ba 00 01 00 
[  847.713379] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video i2c_i801 i2c_core acpi_cpufreq freq_table lpc_ich mfd_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[  847.715190] CPU: 7 PID: 6022 Comm: kworker/u16:1 Tainted: G        W    3.12.0-rc4 #1
[  847.715309] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  847.715431] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[  847.715572] task: ffff8807dd069710 ti: ffff88078137e000 task.ti: ffff88078137e000
[  847.715690] RIP: 0010:[<ffffffffa0263a58>]  [<ffffffffa0263a58>] find_delalloc_range+0x118/0x12a [btrfs]
[  847.715849] RSP: 0018:ffff88078137f858  EFLAGS: 00000282
[  847.715926] RAX: ffff88073e1cde9f RBX: ffffffffa026351d RCX: 0000000008000000
[  847.716005] RDX: 000077f8dd386160 RSI: 0000000011f40000 RDI: ffff8807361cdeb0
[  847.716084] RBP: ffff88078137f8b8 R08: ffff88078137f900 R09: 0000000013553637
[  847.716163] R10: 0000000013553637 R11: 0000000000000000 R12: 0000000000000000
[  847.716242] R13: ffff880735f8a618 R14: 0000000000000001 R15: 0000000000000002
[  847.716322] FS:  0000000000000000(0000) GS:ffff88081fbc0000(0000) knlGS:0000000000000000
[  847.716440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  847.716518] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[  847.716596] Stack:
[  847.716669]  0000000000000000 ffff88078137f900 0000000008000000 0000000013554000
[  847.716911]  0000000000000000 ffff8807361cdeb0 ffff8807361cdea0 ffff88078137fa00
[  847.717153]  0000000008000000 0000000000000000 0000000000000000 ffff88078137fa08
[  847.717395] Call Trace:
[  847.717476]  [<ffffffffa026534d>] find_lock_delalloc_range.constprop.46+0x66/0x1a5 [btrfs]
[  847.717600]  [<ffffffffa02652e8>] ? find_lock_delalloc_range.constprop.46+0x1/0x1a5 [btrfs]
[  847.717724]  [<ffffffffa0266c31>] __extent_writepage+0x17e/0x5b6 [btrfs]
[  847.717804]  [<ffffffff8109df22>] ? __delayacct_blkio_end+0x39/0x3b
[  847.717883]  [<ffffffff81384a07>] ? io_schedule+0xa5/0xc8
[  847.717961]  [<ffffffff810ac5fc>] ? find_get_pages_tag+0xe9/0x123
[  847.718043]  [<ffffffffa026721f>] extent_write_cache_pages.isra.32.constprop.50+0x1b6/0x2fa [btrfs]
[  847.718168]  [<ffffffffa02675f1>] extent_writepages+0x46/0x57 [btrfs]
[  847.718252]  [<ffffffffa025142c>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  847.718335]  [<ffffffffa025060d>] btrfs_writepages+0x23/0x25 [btrfs]
[  847.718414]  [<ffffffff810b56c8>] do_writepages+0x19/0x27
[  847.718491]  [<ffffffff8111078c>] __writeback_single_inode+0x3a/0xe4
[  847.718570]  [<ffffffff811115aa>] writeback_sb_inodes+0x1b2/0x2cc
[  847.718648]  [<ffffffff81111733>] __writeback_inodes_wb+0x6f/0xb4
[  847.718727]  [<ffffffff81111879>] wb_writeback+0x101/0x190
[  847.718805]  [<ffffffff811068d7>] ? get_nr_inodes+0x3a/0x50
[  847.718883]  [<ffffffff81111b25>] bdi_writeback_workfn+0x14f/0x29f
[  847.718962]  [<ffffffff810492bb>] process_one_work+0x1c7/0x2eb
[  847.719040]  [<ffffffff81049842>] worker_thread+0x1cd/0x2c4
[  847.719136]  [<ffffffff81049675>] ? rescuer_thread+0x26c/0x26c
[  847.719215]  [<ffffffff8104e6d6>] kthread+0xb5/0xbd
[  847.719292]  [<ffffffff8104e621>] ? kthread_freezable_should_stop+0x43/0x43
[  847.719371]  [<ffffffff813864fc>] ret_from_fork+0x7c/0xb0
[  847.719449]  [<ffffffff8104e621>] ? kthread_freezable_should_stop+0x43/0x43
[  847.719528] Code: 2b 4b f0 48 01 ca 48 3b 55 b0 72 11 49 8b 06 48 8b 4d b0 48 8d 44 01 ff 49 89 07 eb 09 48 85 c0 0f 85 56 ff ff ff 41 80 45 2c 01 <48> 83 c4 38 4c 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89


-- 
Tomasz Chmielewski
http://wpkg.org



-- 
Tomasz Chmielewski

