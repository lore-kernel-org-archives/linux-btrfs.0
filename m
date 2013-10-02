Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33246 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3JBIA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Oct 2013 04:00:29 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id F34FB351800
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Oct 2013 10:00:25 +0200 (CEST)
Received: from localhost (e0109-106-188-225-124.uqwimax.jp [106.188.225.124])
	by mail.virtall.com (Postfix) with ESMTPSA id E4B8F34E206
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Oct 2013 10:00:23 +0200 (CEST)
Date: Wed, 2 Oct 2013 17:00:14 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at mm/page-writeback.c:2317!
Message-ID: <20131002170014.60dac0d9@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just seen this on a server running 3.12.0-rc3 and btrfs.

Process writing to btrfs filesystem is stuck.


[39455.402308] ------------[ cut here ]------------
[39455.402328] kernel BUG at mm/page-writeback.c:2317!
[39455.402341] invalid opcode: 0000 [#1] SMP 
[39455.402354] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.402505] CPU: 0 PID: 23908 Comm: btrfs-delalloc- Not tainted 3.12.0-rc3 #1
[39455.402570] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.402687] task: ffff8801c7c49710 ti: ffff880577e62000 task.ti: ffff880577e62000
[39455.402800] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.402924] RSP: 0018:ffff880577e63ca8  EFLAGS: 00010246
[39455.402985] RAX: 020000000000083c RBX: ffffea0015fdf080 RCX: 00000000fffffffa
[39455.403049] RDX: 0000000000000000 RSI: ffff88046a486c78 RDI: ffffea0015fdf080
[39455.403114] RBP: ffff880577e63cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.403177] R10: dead000000200200 R11: 0000000000100000 R12: ffff880035b46be8
[39455.403242] R13: ffffea0015fdf080 R14: ffff880035b46aa0 R15: ffff880102e1d9c0
[39455.403307] FS:  0000000000000000(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
[39455.403421] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.403483] CR2: 00007f0c75aa6000 CR3: 000000000160b000 CR4: 00000000001407f0
[39455.403546] Stack:
[39455.403600]  0000000000000101 000000000000017f ffff880577e63ce8 ffffffffa0294d96
[39455.403719]  0000000000100000 ffff880035b46aa0 ffff880389dc7900 0000000000000020
[39455.403837]  ffff880577e63de8 ffffffffa0284f1a ffff880577e63d28 ffffffff8103ed81
[39455.403955] Call Trace:
[39455.404036]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.404169]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.404237]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.404316]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.404397]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.404475]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.404543]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.404606]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.404672]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.404736]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.404799] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.405069] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405137]  RSP <ffff880577e63ca8>
[39455.405487] ---[ end trace 642db3f753caed07 ]---
[39455.405489] ------------[ cut here ]------------
[39455.405492] kernel BUG at mm/page-writeback.c:2317!
[39455.405496] invalid opcode: 0000 [#2] SMP 
[39455.405526] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.405529] CPU: 5 PID: 23895 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.405531] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.405533] task: ffff8804cd85ae20 ti: ffff8803aad5c000 task.ti: ffff8803aad5c000
[39455.405541] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405543] RSP: 0018:ffff8803aad5dca8  EFLAGS: 00010246
[39455.405544] RAX: 020000000000083c RBX: ffffea0011c3ebc0 RCX: 00000000fffffffa
[39455.405546] RDX: 0000000000000000 RSI: ffff88047bb01ab8 RDI: ffffea0011c3ebc0
[39455.405547] RBP: ffff8803aad5dcb8 R08: 0000000000000003 R09: 0000000000000002
[39455.405548] R10: dead000000200200 R11: 0000000000600000 R12: ffff880035b46be8
[39455.405550] R13: ffffea0011c3ebc0 R14: ffff880035b46aa0 R15: ffff880032734060
[39455.405552] FS:  0000000000000000(0000) GS:ffff88081fb40000(0000) knlGS:0000000000000000
[39455.405554] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.405555] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.405556] Stack:
[39455.405560]  0000000000000601 000000000000067f ffff8803aad5dce8 ffffffffa0294d96
[39455.405563]  0000000000600000 ffff880035b46aa0 ffff8807e6043c00 0000000000000020
[39455.405567]  ffff8803aad5dde8 ffffffffa0284f1a ffff8803aad5dd28 ffffffff8103ed81
[39455.405568] Call Trace:
[39455.405594]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.405615]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.405621]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.405638]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.405658]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.405675]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.405680]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.405684]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.405687]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.405693]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.405725] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.405730] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405730]  RSP <ffff8803aad5dca8>
[39455.405733] ---[ end trace 642db3f753caed08 ]---
[39455.405734] ------------[ cut here ]------------
[39455.405736] kernel BUG at mm/page-writeback.c:2317!
[39455.405738] invalid opcode: 0000 [#3] SMP 
[39455.405763] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.405765] CPU: 4 PID: 23896 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.405766] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.405768] task: ffff8804cd859710 ti: ffff8803aad5e000 task.ti: ffff8803aad5e000
[39455.405772] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405774] RSP: 0018:ffff8803aad5fca8  EFLAGS: 00010246
[39455.405775] RAX: 010000000000083c RBX: ffffea000179cdc0 RCX: 00000000fffffffa
[39455.405776] RDX: 0000000000000000 RSI: ffff8807033c9ab8 RDI: ffffea000179cdc0
[39455.405777] RBP: ffff8803aad5fcb8 R08: 0000000000000003 R09: 0000000000000002
[39455.405778] R10: dead000000200200 R11: 0000000000300000 R12: ffff880035b46be8
[39455.405779] R13: ffffea000179cdc0 R14: ffff880035b46aa0 R15: ffff880249575900
[39455.405781] FS:  0000000000000000(0000) GS:ffff88081fb00000(0000) knlGS:0000000000000000
[39455.405783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.405785] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.405786] Stack:
[39455.405790]  0000000000000301 000000000000037f ffff8803aad5fce8 ffffffffa0294d96
[39455.405793]  0000000000300000 ffff880035b46aa0 ffff8807ec0cd100 0000000000000020
[39455.405795]  ffff8803aad5fde8 ffffffffa0284f1a ffff8803aad5fd28 ffffffff8103ed81
[39455.405796] Call Trace:
[39455.405815]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.405832]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.405836]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.405852]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.405869]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.405883]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.405889]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.405892]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.405895]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.405898]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.405926] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.405930] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405930]  RSP <ffff8803aad5fca8>
[39455.405932] ---[ end trace 642db3f753caed09 ]---
[39455.405934] ------------[ cut here ]------------
[39455.405936] kernel BUG at mm/page-writeback.c:2317!
[39455.405939] invalid opcode: 0000 [#4] SMP 
[39455.405967] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.405971] CPU: 6 PID: 23204 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.405972] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.405975] task: ffff8807f42eae20 ti: ffff8806fd1f0000 task.ti: ffff8806fd1f0000
[39455.405981] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.405983] RSP: 0018:ffff8806fd1f1ca8  EFLAGS: 00010246
[39455.405984] RAX: 020000000000083c RBX: ffffea000b478bc0 RCX: 00000000fffffffa
[39455.405986] RDX: 0000000000000000 RSI: ffff88044fee79c8 RDI: ffffea000b478bc0
[39455.405987] RBP: ffff8806fd1f1cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.405988] R10: dead000000200200 R11: 0000000000000000 R12: ffff880035b46be8
[39455.405990] R13: ffffea000b478bc0 R14: ffff880035b46aa0 R15: ffff880171df2c60
[39455.405992] FS:  0000000000000000(0000) GS:ffff88081fb80000(0000) knlGS:0000000000000000
[39455.405994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.405995] CR2: 00007fd4559c1000 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.405996] Stack:
[39455.406000]  0000000000000001 000000000000007f ffff8806fd1f1ce8 ffffffffa0294d96
[39455.406004]  0000000000000000 ffff880035b46aa0 ffff8807e82e4700 0000000000000020
[39455.406007]  ffff8806fd1f1de8 ffffffffa0284f1a ffff8806fd1f1d28 ffffffff8103ed81
[39455.406008] Call Trace:
[39455.406031]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.406050]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.406054]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.406071]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.406090]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.406107]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.406111]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.406116]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406119]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.406123]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406157] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.406161] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406162]  RSP <ffff8806fd1f1ca8>
[39455.406164] ---[ end trace 642db3f753caed0a ]---
[39455.406165] ------------[ cut here ]------------
[39455.406167] kernel BUG at mm/page-writeback.c:2317!
[39455.406169] invalid opcode: 0000 [#5] SMP 
[39455.406194] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.406197] CPU: 2 PID: 23910 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.406199] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.406200] task: ffff8801c7c4dc40 ti: ffff88054cb02000 task.ti: ffff88054cb02000
[39455.406206] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406207] RSP: 0018:ffff88054cb03ca8  EFLAGS: 00010246
[39455.406209] RAX: 020000000000083c RBX: ffffea0017c83440 RCX: 00000000fffffffa
[39455.406210] RDX: 0000000000000000 RSI: ffff8807033cb558 RDI: ffffea0017c83440
[39455.406212] RBP: ffff88054cb03cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.406213] R10: dead000000200200 R11: 0000000000200000 R12: ffff880035b46be8
[39455.406214] R13: ffffea0017c83440 R14: ffff880035b46aa0 R15: ffff880102e1dea0
[39455.406217] FS:  0000000000000000(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
[39455.406218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.406220] CR2: 00007f0c75226323 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.406220] Stack:
[39455.406224]  0000000000000201 000000000000027f ffff88054cb03ce8 ffffffffa0294d96
[39455.406227]  0000000000200000 ffff880035b46aa0 ffff8807e8fa6800 0000000000000020
[39455.406230]  ffff88054cb03de8 ffffffffa0284f1a ffff88054cb03d28 ffffffff8103ed81
[39455.406230] Call Trace:
[39455.406247]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.406260]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.406263]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.406276]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.406290]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.406304]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.406307]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.406310]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406312]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.406315]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406335] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.406338] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406339]  RSP <ffff88054cb03ca8>
[39455.406340] ---[ end trace 642db3f753caed0b ]---
[39455.406341] ------------[ cut here ]------------
[39455.406344] kernel BUG at mm/page-writeback.c:2317!
[39455.406347] invalid opcode: 0000 [#6] SMP 
[39455.406375] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.406378] CPU: 7 PID: 23894 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.406380] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.406382] task: ffff8804cd85c530 ti: ffff8800075b8000 task.ti: ffff8800075b8000
[39455.406388] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406390] RSP: 0018:ffff8800075b9ca8  EFLAGS: 00010246
[39455.406392] RAX: 020000000000083c RBX: ffffea00088ae740 RCX: 00000000fffffffa
[39455.406393] RDX: 0000000000000000 RSI: ffff88047bb01880 RDI: ffffea00088ae740
[39455.406394] RBP: ffff8800075b9cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.406396] R10: dead000000200200 R11: 0000000000700000 R12: ffff880035b46be8
[39455.406397] R13: ffffea00088ae740 R14: ffff880035b46aa0 R15: ffff88038e34b240
[39455.406399] FS:  0000000000000000(0000) GS:ffff88081fbc0000(0000) knlGS:0000000000000000
[39455.406401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.406403] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.406403] Stack:
[39455.406408]  0000000000000701 000000000000077f ffff8800075b9ce8 ffffffffa0294d96
[39455.406411]  0000000000700000 ffff880035b46aa0 ffff8807f127f900 0000000000000020
[39455.406415]  ffff8800075b9de8 ffffffffa0284f1a ffff8800075b9d28 ffffffff8103ed81
[39455.406415] Call Trace:
[39455.406438]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.406457]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.406462]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.406478]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.406497]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.406514]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.406517]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.406522]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406525]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.406529]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406563] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60 
[39455.406567] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406568]  RSP <ffff8800075b9ca8>
[39455.406570] ---[ end trace 642db3f753caed0c ]---
[39455.406571] ------------[ cut here ]------------
[39455.406573] kernel BUG at mm/page-writeback.c:2317!
[39455.406575] invalid opcode: 0000 [#7] SMP 
[39455.406603] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.406606] CPU: 3 PID: 23909 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.406607] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.406609] task: ffff8801c7c4c530 ti: ffff880353420000 task.ti: ffff880353420000
[39455.406614] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406616] RSP: 0018:ffff880353421ca8  EFLAGS: 00010246
[39455.406617] RAX: 020000000000083c RBX: ffffea001512c980 RCX: 00000000fffffffa
[39455.406619] RDX: 0000000000000000 RSI: ffff88021cdcd1d8 RDI: ffffea001512c980
[39455.406620] RBP: ffff880353421cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.406622] R10: dead000000200200 R11: 0000000000400000 R12: ffff880035b46be8
[39455.406623] R13: ffffea001512c980 R14: ffff880035b46aa0 R15: ffff880102e1db40
[39455.406625] FS:  0000000000000000(0000) GS:ffff88081fac0000(0000) knlGS:0000000000000000
[39455.406627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.406628] CR2: 00007f4af7d03000 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.406629] Stack:
[39455.406633]  0000000000000401 000000000000047f ffff880353421ce8 ffffffffa0294d96
[39455.406636]  0000000000400000 ffff880035b46aa0 ffff8807e9133a00 0000000000000020
[39455.406639]  ffff880353421de8 ffffffffa0284f1a ffff880353421d28 ffffffff8103ed81
[39455.406640] Call Trace:
[39455.406659]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.406674]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.406678]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.406692]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.406709]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.406724]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.406728]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.406733]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406736]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.406740]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406773] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60
[39455.406777] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406778]  RSP <ffff880353421ca8>
[39455.406780] ---[ end trace 642db3f753caed0d ]---
[39455.406781] ------------[ cut here ]------------
[39455.406782] kernel BUG at mm/page-writeback.c:2317!
[39455.406784] invalid opcode: 0000 [#8] SMP
[39455.406808] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 video i2c_core lpc_ich acpi_cpufreq freq_table mfd_core button ehci_pci ehci_hcd pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[39455.406811] CPU: 7 PID: 23907 Comm: btrfs-delalloc- Tainted: G      D      3.12.0-rc3 #1
[39455.406811] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[39455.406813] task: ffff880004ad0000 ti: ffff88053a6d0000 task.ti: ffff88053a6d0000
[39455.406816] RIP: 0010:[<ffffffff810b408b>]  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406817] RSP: 0018:ffff88053a6d1ca8  EFLAGS: 00010246
[39455.406818] RAX: 020000000000083c RBX: ffffea000ea99200 RCX: 00000000fffffffa
[39455.406819] RDX: 0000000000000000 RSI: ffff88021cdccfa0 RDI: ffffea000ea99200
[39455.406820] RBP: ffff88053a6d1cb8 R08: 0000000000000003 R09: 0000000000000002
[39455.406821] R10: dead000000200200 R11: 0000000000500000 R12: ffff880035b46be8
[39455.406822] R13: ffffea000ea99200 R14: ffff880035b46aa0 R15: ffff880102e1d900
[39455.406823] FS:  0000000000000000(0000) GS:ffff88081fbc0000(0000) knlGS:0000000000000000
[39455.406824] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39455.406825] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[39455.406826] Stack:
[39455.406828]  0000000000000501 000000000000057f ffff88053a6d1ce8 ffffffffa0294d96
[39455.406830]  0000000000500000 ffff880035b46aa0 ffff8807f127ff00 0000000000000020
[39455.406832]  ffff88053a6d1de8 ffffffffa0284f1a ffff88053a6d1d28 ffffffff8103ed81
[39455.406833] Call Trace:
[39455.406847]  [<ffffffffa0294d96>] extent_range_clear_dirty_for_io+0x3f/0x57 [btrfs]
[39455.406859]  [<ffffffffa0284f1a>] compress_file_range+0x1db/0x527 [btrfs]
[39455.406863]  [<ffffffff8103ed81>] ? lock_timer_base.isra.25+0x26/0x4a
[39455.406874]  [<ffffffffa0285296>] async_cow_start+0x30/0x4e [btrfs]
[39455.406888]  [<ffffffffa02a32e4>] worker_loop+0x15e/0x48e [btrfs]
[39455.406901]  [<ffffffffa02a3186>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[39455.406903]  [<ffffffff8104e686>] kthread+0xb5/0xbd
[39455.406907]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406908]  [<ffffffff813862fc>] ret_from_fork+0x7c/0xb0
[39455.406911]  [<ffffffff8104e5d1>] ? kthread_freezable_should_stop+0x43/0x43
[39455.406931] Code: ba 2b 04 19 c0 85 c0 0f 94 c0 0f b6 c0 41 5b 5b 5d c3 55 48 89 e5 41 54 53 48 89 fb e8 15 b3 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 6e 49 8b 84 24 80 00 00 00 f6 40 20 01 75 60
[39455.406935] RIP  [<ffffffff810b408b>] clear_page_dirty_for_io+0x19/0x9c
[39455.406936]  RSP <ffff88053a6d1ca8>
[39455.406953] ---[ end trace 642db3f753caed0e ]---


-- 
Tomasz Chmielewski
http://www.ptraveler.com

