Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53529 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3GEDXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 23:23:22 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DE3D33EE0C1
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id CB7CD45DEB7
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id AC8B645DEB5
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9F32CE08003
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 498371DB8038
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id 258A561828
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:20 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.102.91])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id EA7446164F
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:23:19 +0900 (JST)
Message-ID: <51D63C1A.6050306@jp.fujitsu.com>
Date: Fri, 05 Jul 2013 12:23:06 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/inode.c:3004!
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I encountered following BUG_ON. (I think that -28(ENOSPC) returned from
btrfs_orphan_reserve_metadata maybe.)
When this happened, I was running my stress test.  But, I cannot reproduce
this problem yet though the test was executed again several times.

- Tsutomu


[ 4823.473913] btrfs: found 4154 extents
[ 4839.909241] btrfs: found 24776 extents
[ 4846.960116] btrfs: relocating block group 4324327424 flags 17
[ 4860.159362] ------------[ cut here ]------------
[ 4860.159368] kernel BUG at fs/btrfs/inode.c:3004!
[ 4860.159371] invalid opcode: 0000 [#1] SMP
[ 4860.159374] Modules linked in: btrfs raid6_pq zlib_deflate xor crc32c libcrc32c ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge stp llc nfsd auth_rpcgss vhost_net acpi_cpufreq mperf oid_registry tun nfs_acl freq_table coretemp lockd kvm dm_mirror dm_region_hash sunrpc iTCO_wdt dm_log iTCO_vendor_support tg3 dm_mod i3000_edac shpchp lpc_ich edac_core ptp mfd_core i2c_i801 pci_hotplug microcode pps_core i2c_core pcspkr uinput ipv6 autofs4 ext4 crc16 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif ata_piix libata megaraid_sas scsi_mod
[ 4860.159431] CPU: 1 PID: 6575 Comm: btrfs Not tainted 3.10.0 #1
[ 4860.159433] Hardware name: FUJITSU-SV      PRIMERGY            /D2399, BIOS 4.06  Rev. 1.06.2399             05/04/2007
[ 4860.159437] task: ffff88006a838000 ti: ffff880022990000 task.ti: ffff880022990000
[ 4860.159439] RIP: 0010:[<ffffffffa05aef14>]  [<ffffffffa05aef14>] btrfs_orphan_add+0xd4/0x13b [btrfs]
[ 4860.159476] RSP: 0018:ffff880022991b78  EFLAGS: 00010286
[ 4860.159479] RAX: 00000000ffffffe4 RBX: ffff8800414d5800 RCX: 0000000000018000
[ 4860.159482] RDX: 0000000000018000 RSI: 0000000000018000 RDI: ffff88016e70a190
[ 4860.159484] RBP: ffff880022991bb8 R08: 0000000000000001 R09: 0000000000015900
[ 4860.159487] R10: ffff8800d18c9800 R11: ffff8800414d5800 R12: ffff88006b8e09f0
[ 4860.159490] R13: ffff88006cf87f00 R14: 0000000000000000 R15: 0000000000000000
[ 4860.159493] FS:  00007fa79eb36780(0000) GS:ffff88019fd00000(0000) knlGS:0000000000000000
[ 4860.159496] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4860.159498] CR2: 00007ff4745ff000 CR3: 000000001165a000 CR4: 00000000000007e0
[ 4860.159501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4860.159503] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4860.159505] Stack:
[ 4860.159507]  0000000000000001 ffff8800414d5c88 ffff88006b8e09f0 ffff8800414d5800
[ 4860.159512]  ffff88006b8e09f0 ffff8801710922d0 0000000000000000 0000000000000001
[ 4860.159516]  ffff880022991c48 ffffffffa05b4458 ffff88006cf87f00 ffff8800414d5c8c
[ 4860.159521] Call Trace:
[ 4860.159545]  [<ffffffffa05b4458>] btrfs_orphan_cleanup+0x290/0x400 [btrfs]
[ 4860.159571]  [<ffffffffa05cf607>] btrfs_mksubvol.isra.47+0x240/0x33c [btrfs]
[ 4860.159596]  [<ffffffffa05cf824>] btrfs_ioctl_snap_create_transid+0x121/0x151 [btrfs]
[ 4860.159621]  [<ffffffffa05cf8fa>] ? btrfs_ioctl_snap_create_v2+0x35/0x118 [btrfs]
[ 4860.159645]  [<ffffffffa05cf986>] btrfs_ioctl_snap_create_v2+0xc1/0x118 [btrfs]
[ 4860.159652]  [<ffffffff810eb315>] ? handle_pte_fault+0x260/0x6ac
[ 4860.159677]  [<ffffffffa05d1e8e>] btrfs_ioctl+0x62e/0x19bc [btrfs]
[ 4860.159681]  [<ffffffff810eba98>] ? handle_mm_fault+0x1ba/0x1cd
[ 4860.159686]  [<ffffffff813bd8db>] ? __do_page_fault+0x33b/0x3df
[ 4860.159692]  [<ffffffff8111b17a>] vfs_ioctl+0x26/0x39
[ 4860.159695]  [<ffffffff8111ba3a>] do_vfs_ioctl+0x3ed/0x430
[ 4860.159700]  [<ffffffff81054447>] ? finish_task_switch+0x83/0xae
[ 4860.159704]  [<ffffffff8111bad4>] SyS_ioctl+0x57/0x87
[ 4860.159709]  [<ffffffff8106bf9a>] ? current_kernel_time+0x12/0x36
[ 4860.159714]  [<ffffffff813c1242>] system_call_fastpath+0x16/0x1b
[ 4860.159716] Code: fe bf 01 00 00 00 e8 c8 b7 ff ff 48 8b 7d c8 41 89 c7 e8 f3 b7 ff ff 45 85 ff 75 11 4c 89 e6 4c 89 ef e8 10 88 fe ff 85 c0 74 02 <0f> 0b 41 ff ce 75 48 4c 89 e7 e8 4d b8 ff ff 48 89 de 48 89 c2
[ 4860.159753] RIP  [<ffffffffa05aef14>] btrfs_orphan_add+0xd4/0x13b [btrfs]
[ 4860.159776]  RSP <ffff880022991b78>
[ 4860.159780] ---[ end trace 393921d181bfb28f ]---

