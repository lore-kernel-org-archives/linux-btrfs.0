Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:55089 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbcBGG5Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 01:57:24 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id C9E8481E4
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Feb 2016 06:57:21 +0000 (GMT)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id TZpVK-WswO7q for <linux-btrfs@vger.kernel.org>;
	Sun,  7 Feb 2016 06:57:11 +0000 (GMT)
Received: from mabel.local (5ec3d602.skybroadband.com [94.195.214.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@codepoets.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id D4FCD8076
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Feb 2016 06:57:10 +0000 (GMT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: David Goodwin <david@codepoets.co.uk>
Subject: kernel 4.1.15 balance => oops. out of memory.
Message-ID: <56B6EAC5.4040206@codepoets.co.uk>
Date: Sun, 7 Feb 2016 06:57:09 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 4.1.15

balancing a fs led to this oops.

after a reboot, the balance resumed without problem.

presumably there wasn't enough real memory available

David

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 16560 at fs/btrfs/super.c:260 
__btrfs_abort_transaction+0x4b/0x120 [btrfs]()
  BTRFS: Transaction aborted (error -12)
  Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs 
xfs libcrc32c dm_mod veth xt_multiport iptable_filter ip_tables x_tables 
nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc 
bridge stp llc ip_gre ip_tunnel gre fuse crct10dif_pclmul crc32_pclmul 
ppdev cirrus aesni_intel snd_pcsp aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd snd_pcm ttm snd_timer evdev psmouse snd soundcore 
serio_raw drm_kms_helper parport_pc 8250_fintek parport drm i2c_piix4 
i2c_core acpi_cpufreq processor thermal_sys button ext4 crc16 mbcache 
jbd2 btrfs xor raid6_pq ata_generic xen_blkfront crc32c_intel floppy 
ata_piix libata scsi_mod ixgbevf
  CPU: 1 PID: 16560 Comm: apache2 Not tainted 4.1.15-dg1 #1
  Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/07/2015
   0000000000000000 ffffffffa01a1af2 ffffffff81573596 ffff880029f13b08
   ffffffff81071221 ffff880139897388 00000000fffffff4 ffff88014ba71000
   ffffffffa01a061c 0000000000001854 ffffffff8107129a ffffffffa01a46e8
  Call Trace:
   [<ffffffff81573596>] ? dump_stack+0x40/0x50
   [<ffffffff81071221>] ? warn_slowpath_common+0x81/0xb0
   [<ffffffff8107129a>] ? warn_slowpath_fmt+0x4a/0x50
   [<ffffffffa00f4d8b>] ? __btrfs_abort_transaction+0x4b/0x120 [btrfs]
   [<ffffffffa013213a>] ? btrfs_add_link+0x2ea/0x350 [btrfs]
   [<ffffffffa01331e2>] ? btrfs_create+0x1a2/0x1e0 [btrfs]
   [<ffffffff811d663e>] ? generic_permission+0x13e/0x1a0
   [<ffffffff811d79d4>] ? vfs_create+0xc4/0x130
   [<ffffffff811dbe44>] ? do_last+0x1154/0x1210
   [<ffffffff810afe01>] ? __init_waitqueue_head+0x1/0x20
   [<ffffffff811dbf83>] ? path_openat+0x83/0x600
   [<ffffffff8118850e>] ? do_set_pte+0x9e/0xd0
   [<ffffffff8115c95e>] ? filemap_map_pages+0x23e/0x250
   [<ffffffff811ddce0>] ? do_filp_open+0x30/0xa0
   [<ffffffff811ea56f>] ? __alloc_fd+0x9f/0x130
   [<ffffffff811cb19a>] ? do_sys_open+0x12a/0x220
   [<ffffffff81579872>] ? system_call_fastpath+0x16/0x75
  ---[ end trace 388b9f3bfbb5b4e9 ]---
  BTRFS: error (device xvdf) in btrfs_add_link:6228: errno=-12 Out of memory
  BTRFS info (device xvdf): forced readonly
