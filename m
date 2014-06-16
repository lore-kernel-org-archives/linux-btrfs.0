Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail4.fujitsu.co.jp ([164.71.1.141]:41520 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaFPGlS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 02:41:18 -0400
Received: from fgwmail.fujitsu.co.jp (fgwmail.fujitsu.co.jp [164.71.1.133])
	by fgwmail4.fujitsu.co.jp (Postfix) with ESMTP id 6FA1C178AAB5
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 15:36:15 +0900 (JST)
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 5007C3EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 15:35:55 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 628E2AC03E7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 15:35:54 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 09DD51DB8032
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 15:35:54 +0900 (JST)
Message-ID: <539E9026.1020406@jp.fujitsu.com>
Date: Mon, 16 Jun 2014 15:35:18 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.

================

[ 1121.983975] BTRFS: device fsid 8cc641f9-563a-4d62-9157-9503156ce62c devid 1 transid 4 /dev/sdc5
[ 1121.987994] BTRFS info (device sdc5): disk space caching is enabled
[ 1121.987999] BTRFS: flagging fs with big metadata feature
[ 1121.996312] BTRFS: creating UUID tree
[ 1122.050762] BTRFS info (device sdc5): qgroup scan completed
[ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
[ 1147.949658] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables btrfs coretemp kvm_intel kvm xor raid6_pq crc32_pclmul crc32c_intel ghash_clmulni_intel nfsd igb microcode ptp pps_core dca iTCO_wdt shpchp auth_rpcgss iTCO_vendor_support i7core_edac pcspkr edac_core i2c_i801 lpc_ich mfd_core ipmi_si tpm_infineon ipmi_msghandler tpm_tis nfs_acl tpm acpi_power_meter lockd acpi_cpufreq sunrpc usb_storage mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm ata_generic pata_acpi drm megaraid_sas i2c_core ata_piix
[ 1147.949695] CPU: 0 PID: 5189 Comm: kworker/u25:4 Not tainted 3.16.0-rc1 #1
[ 1147.949696] Hardware name: FUJITSU-SV                       PRIMERGY                      /D2619, BIOS 6.00 Rev. 1.03.2619.N1           04/06/2010
[ 1147.949717] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[ 1147.949718] task: ffff88007408b840 ti: ffff8800740e4000 task.ti: ffff8800740e4000
[ 1147.949720] RIP: 0010:[<ffffffff810ba858>]  [<ffffffff810ba858>] queue_read_lock_slowpath+0x68/0x90
[ 1147.949725] RSP: 0018:ffff8800740e7b08  EFLAGS: 00000202
[ 1147.949726] RAX: 00000000000000ee RBX: 0000000000000012 RCX: 0000000000000001
[ 1147.949727] RDX: 00000000000000ef RSI: 0000000000000004 RDI: ffff88003db221b0
[ 1147.949728] RBP: ffff8800740e7b08 R08: 0000000000000001 R09: ffff880071486b58
[ 1147.949729] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800715d1900
[ 1147.949730] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000002
[ 1147.949732] FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[ 1147.949733] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1147.949734] CR2: 00000036c97b9490 CR3: 0000000001c0e000 CR4: 00000000000007f0
[ 1147.949735] Stack:
[ 1147.949736]  ffff8800740e7b18 ffffffff8166bcbc ffff8800740e7b38 ffffffffa070ffe4
[ 1147.949738]  0000000000000001 ffffffffffffffe8 ffff8800740e7b58 ffffffffa06b0c2a
[ 1147.949740]  ffff8800719de360 0000000000000000 ffff8800740e7bf8 ffffffffa06b5e32
[ 1147.949742] Call Trace:
[ 1147.949748]  [<ffffffff8166bcbc>] _raw_read_lock+0x1c/0x30
[ 1147.949760]  [<ffffffffa070ffe4>] btrfs_clear_lock_blocking_rw+0x44/0x150 [btrfs]
[ 1147.949767]  [<ffffffffa06b0c2a>] btrfs_clear_path_blocking+0x3a/0x80 [btrfs]
[ 1147.949774]  [<ffffffffa06b5e32>] btrfs_search_slot+0x702/0xa10 [btrfs]
[ 1147.949783]  [<ffffffffa06cbe2e>] btrfs_lookup_csum+0x5e/0x180 [btrfs]
[ 1147.949792]  [<ffffffffa06cd19c>] btrfs_csum_file_blocks+0xbc/0x680 [btrfs]
[ 1147.949798]  [<ffffffffa06b0d46>] ? btrfs_free_path+0x26/0x30 [btrfs]
[ 1147.949809]  [<ffffffffa06db1e0>] add_pending_csums.isra.42+0x50/0x80 [btrfs]
[ 1147.949819]  [<ffffffffa06e1410>] btrfs_finish_ordered_io+0x470/0x570 [btrfs]
[ 1147.949830]  [<ffffffffa06e1785>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1147.949841]  [<ffffffffa0706b3c>] normal_work_helper+0xbc/0x290 [btrfs]
[ 1147.949844]  [<ffffffff8108ab95>] process_one_work+0x175/0x430
[ 1147.949846]  [<ffffffff8108b23b>] worker_thread+0x11b/0x520
[ 1147.949848]  [<ffffffff8108b120>] ? rescuer_thread+0x2d0/0x2d0
[ 1147.949851]  [<ffffffff81091712>] kthread+0xd2/0xf0
[ 1147.949853]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.949855]  [<ffffffff8166c23c>] ret_from_fork+0x7c/0xb0
[ 1147.949857]  [<ffffffff81091640>] ? insert_kthread_work+0x40/0x40
[ 1147.949858] Code: 00 00 00 f3 90 8b 07 84 c0 75 f8 b8 00 01 00 00 f0 0f c1 07 3c ff 75 0b 0f 1f 00 f3 90 8b 07 3c ff 74 f8 80 47 04 01 5d c3 f3 90 <0f> b6 47 04 38 c2 75 f6 eb bf 8b 07 3c ff 75 ec f3 90 8b 07 3c

