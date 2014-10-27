Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60231 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaJ0J0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 05:26:42 -0400
MIME-Version: 1.0
Message-ID: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
From: "Stephan Alz" <stephan008@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS balance segfault, where to go from here
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Oct 2014 10:26:40 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Folks,

I used to have an array of 4x4TB drives with BTRFS in raid10.
The kernel version is: 3.13-0.bpo.1-amd64
BTRFS version is: v3.14.1

When it was reaching 80% in space I added another 4TB drive to the array with:

> btrfs device add /dev/sdf /mnt/backup

And started the balancing to the new drive:

> btrfs filesystem balance /mnt/backup

This was going for a while for 5-6 hours before it segfaulted with not enough free space message.
Now my configuration looks like this:

btrfs fi show /mnt/backup
Label: 'backup'  uuid: ...
	Total devices 5 FS bytes used 5.93TiB
	devid    1 size 3.64TiB used 2.82TiB path /dev/sdd
	devid    2 size 3.64TiB used 2.82TiB path /dev/sdc
	devid    3 size 3.64TiB used 2.81TiB path /dev/sdb
	devid    4 size 3.64TiB used 2.82TiB path /dev/sde
	devid    5 size 3.64TiB used 638.50GiB path /dev/sdf

After this crash happend during the balancing (logs are attached at the end) the system remounted my /mnt/backup share as RO.
At this point I started to really worry. I umounted and remounted it manually. At the beginning it run some self checks which took like 5 mins then as iotop showed it continued with the balancing which failed again the same way. For next time after mount I immediately put the balancing on pause (which helped). 

My question is where to go from here? What I going to do right now is to copy the most important data to another separated XFS drive.
What I planning to do is:

1, Upgrade the kernel
2, Upgrade BTRFS
3, Continue the balancing.


Could someone please also explain that how is exactly the raid10 setup works with ODD number of drives with btrfs? 
Raid10 should be a stripe of mirrors. Now then this sdf drive is mirrored or striped or what? 
Some btrfs gurus could tell me that should I be worried of dataloss because of this or not?

Would I need even more free space just to add a 5th drive? If so how much more? 

Kernel logs
-----------


Oct 24 17:25:44 backup kernel: [29396.873750] btrfs: relocating block group 5162588438528 flags 65
Oct 24 17:26:09 backup kernel: [29421.594524] btrfs: found 13126 extents
Oct 24 17:26:38 backup kernel: [29450.769228] btrfs: found 13126 extents
Oct 24 17:26:39 backup kernel: [29451.345198] btrfs: relocating block group 5161514696704 flags 68
Oct 24 17:31:33 backup kernel: [29745.776810] BTRFS debug (device sdb): run_one_delayed_ref returned -28
Oct 24 17:31:33 backup kernel: [29745.776818] ------------[ cut here ]------------
Oct 24 17:31:33 backup kernel: [29745.776847] WARNING: CPU: 1 PID: 1807 at /build/linux-t5aGFh/linux-3.13.10/fs/btrfs/super.c:254 __btrfs_abort_transaction+0x5a/0x140 [btrfs]()
Oct 24 17:31:33 backup kernel: [29745.776849] btrfs: Transaction aborted (error -28)
Oct 24 17:31:33 backup kernel: [29745.776851] Modules linked in: xen_gntdev xen_evtchn xenfs xen_privcmd nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc 8021q garp mrp bridge stp llc loop iTCO_wdt iTCO_vendor_support lpc_ich radeon mfd_core processor evdev ttm drm_kms_helper drm i2c_algo_bit coretemp rng_core serio_raw pcspkr i2c_i801 i2c_core i3000_edac thermal_sys button shpchp edac_core ext4 crc16 mbcache jbd2 btrfs xor raid6_pq crc32c libcrc32c dm_mod xen_pciback sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic ahci ata_piix libahci 3w_9xxx libata scsi_mod ehci_pci uhci_hcd ehci_hcd e1000e ptp pps_core usbcore usb_common
Oct 24 17:31:33 backup kernel: [29745.776902] CPU: 1 PID: 1807 Comm: btrfs-transacti Not tainted 3.13-0.bpo.1-amd64 #1 Debian 3.13.10-1~bpo70+1
Oct 24 17:31:33 backup kernel: [29745.776905] Hardware name: Supermicro PDSM4+/PDSM4+, BIOS 6.00 02/05/2007
Oct 24 17:31:33 backup kernel: [29745.776907]  0000000000000000 ffffffffa0257130 ffffffff814d16c9 ffff88006a7f3cc8
Oct 24 17:31:33 backup kernel: [29745.776911]  ffffffff81060967 00000000ffffffe4 ffff880004282800 ffff88003b813ec0
Oct 24 17:31:33 backup kernel: [29745.776914]  0000000000000aaa ffffffffa0253b60 ffffffff81060a55 ffffffffa0257260
Oct 24 17:31:33 backup kernel: [29745.776918] Call Trace:
Oct 24 17:31:33 backup kernel: [29745.776926]  [<ffffffff814d16c9>] ? dump_stack+0x41/0x51
Oct 24 17:31:33 backup kernel: [29745.776931]  [<ffffffff81060967>] ? warn_slowpath_common+0x87/0xc0
Oct 24 17:31:33 backup kernel: [29745.776935]  [<ffffffff81060a55>] ? warn_slowpath_fmt+0x45/0x50
Oct 24 17:31:33 backup kernel: [29745.776946]  [<ffffffffa01b73ca>] ? __btrfs_abort_transaction+0x5a/0x140 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.776959]  [<ffffffffa01d2e72>] ? btrfs_run_delayed_refs+0x372/0x530 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.776974]  [<ffffffffa01fa8c3>] ? btrfs_run_ordered_operations+0x213/0x2b0 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.776988]  [<ffffffffa01e2fea>] ? btrfs_commit_transaction+0x5a/0x990 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.777001]  [<ffffffffa01e1345>] ? transaction_kthread+0x1c5/0x240 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.777015]  [<ffffffffa01e1180>] ? open_ctree+0x1ff0/0x1ff0 [btrfs]
Oct 24 17:31:33 backup kernel: [29745.777019]  [<ffffffff8108233c>] ? kthread+0xbc/0xe0
Oct 24 17:31:33 backup kernel: [29745.777022]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
Oct 24 17:31:33 backup kernel: [29745.777026]  [<ffffffff814dee4c>] ? ret_from_fork+0x7c/0xb0
Oct 24 17:31:33 backup kernel: [29745.777030]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
Oct 24 17:31:33 backup kernel: [29745.777032] ---[ end trace 5de5beb31698a3c1 ]---
Oct 24 17:31:33 backup kernel: [29745.777035] BTRFS error (device sdb) in btrfs_run_delayed_refs:2730: errno=-28 No space left
Oct 24 17:31:33 backup kernel: [29745.777512] BTRFS info (device sdb): forced readonly
Oct 24 17:31:33 backup kernel: [29745.784767] BTRFS debug (device sdb): run_one_delayed_ref returned -28
Oct 24 17:31:33 backup kernel: [29745.784773] BTRFS error (device sdb) in btrfs_run_delayed_refs:2730: errno=-28 No space left
Oct 24 17:35:53 backup kernel: [30005.015967] btrfs: device label backup_fs devid 3 transid 86656 /dev/sdb
Oct 24 17:35:53 backup kernel: [30005.063903] btrfs: disk space caching is enabled
Oct 24 17:43:01 backup kernel: [30433.356660] BTRFS debug (device sdf): unlinked 1 orphans
Oct 24 17:43:01 backup kernel: [30433.395645] btrfs: continuing balance
Oct 24 17:43:02 backup kernel: [30434.395936] btrfs: relocating block group 7434626138112 flags 65
Oct 24 17:43:17 backup kernel: [30449.104022] btrfs: found 8842 extents
Oct 24 17:43:24 backup kernel: [30456.043235] btrfs: found 8834 extents
Oct 24 17:43:24 backup kernel: [30456.580133] btrfs: relocating block group 7223098998784 flags 68
Oct 24 17:48:42 backup kernel: [30774.465707] btrfs: found 37187 extents
Oct 24 17:48:43 backup kernel: [30775.058570] btrfs: relocating block group 6782864850944 flags 68
Oct 24 17:52:16 backup kernel: [30988.070735] BTRFS debug (device sdf): run_one_delayed_ref returned -28
Oct 24 17:52:16 backup kernel: [30988.070742] ------------[ cut here ]------------
Oct 24 17:52:16 backup kernel: [30988.070772] WARNING: CPU: 1 PID: 15920 at /build/linux-t5aGFh/linux-3.13.10/fs/btrfs/super.c:254 __btrfs_abort_transaction+0x5a/0x140 [btrfs]()
Oct 24 17:52:16 backup kernel: [30988.070775] btrfs: Transaction aborted (error -28)
Oct 24 17:52:16 backup kernel: [30988.070776] Modules linked in: xen_gntdev xen_evtchn xenfs xen_privcmd nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc 8021q garp mrp bridge stp llc loop iTCO_wdt iTCO_vendor_support lpc_ich radeon mfd_core processor evdev ttm drm_kms_helper drm i2c_algo_bit coretemp rng_core serio_raw pcspkr i2c_i801 i2c_core i3000_edac thermal_sys button shpchp edac_core ext4 crc16 mbcache jbd2 btrfs xor raid6_pq crc32c libcrc32c dm_mod xen_pciback sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic ahci ata_piix libahci 3w_9xxx libata scsi_mod ehci_pci uhci_hcd ehci_hcd e1000e ptp pps_core usbcore usb_common
Oct 24 17:52:16 backup kernel: [30988.070828] CPU: 1 PID: 15920 Comm: btrfs-transacti Tainted: G        W    3.13-0.bpo.1-amd64 #1 Debian 3.13.10-1~bpo70+1
Oct 24 17:52:16 backup kernel: [30988.070830] Hardware name: Supermicro PDSM4+/PDSM4+, BIOS 6.00 02/05/2007
Oct 24 17:52:16 backup kernel: [30988.070833]  0000000000000000 ffffffffa0257130 ffffffff814d16c9 ffff880056d7bcc8
Oct 24 17:52:16 backup kernel: [30988.070838]  ffffffff81060967 00000000ffffffe4 ffff880003c97000 ffff88006ba9abe0
Oct 24 17:52:16 backup kernel: [30988.070841]  0000000000000aaa ffffffffa0253b60 ffffffff81060a55 ffffffffa0257260
Oct 24 17:52:16 backup kernel: [30988.070845] Call Trace:
Oct 24 17:52:16 backup kernel: [30988.070853]  [<ffffffff814d16c9>] ? dump_stack+0x41/0x51
Oct 24 17:52:16 backup kernel: [30988.070858]  [<ffffffff81060967>] ? warn_slowpath_common+0x87/0xc0
Oct 24 17:52:16 backup kernel: [30988.070862]  [<ffffffff81060a55>] ? warn_slowpath_fmt+0x45/0x50
Oct 24 17:52:16 backup kernel: [30988.070873]  [<ffffffffa01b73ca>] ? __btrfs_abort_transaction+0x5a/0x140 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070886]  [<ffffffffa01d2e72>] ? btrfs_run_delayed_refs+0x372/0x530 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070901]  [<ffffffffa01fa8c3>] ? btrfs_run_ordered_operations+0x213/0x2b0 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070915]  [<ffffffffa01e2fea>] ? btrfs_commit_transaction+0x5a/0x990 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070929]  [<ffffffffa01e1345>] ? transaction_kthread+0x1c5/0x240 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070942]  [<ffffffffa01e1180>] ? open_ctree+0x1ff0/0x1ff0 [btrfs]
Oct 24 17:52:16 backup kernel: [30988.070946]  [<ffffffff8108233c>] ? kthread+0xbc/0xe0
Oct 24 17:52:16 backup kernel: [30988.070949]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
Oct 24 17:52:16 backup kernel: [30988.070954]  [<ffffffff814dee4c>] ? ret_from_fork+0x7c/0xb0
Oct 24 17:52:16 backup kernel: [30988.070957]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
Oct 24 17:52:16 backup kernel: [30988.070960] ---[ end trace 5de5beb31698a3c2 ]---
Oct 24 17:52:16 backup kernel: [30988.070963] BTRFS error (device sdf) in btrfs_run_delayed_refs:2730: errno=-28 No space left
Oct 24 17:52:16 backup kernel: [30988.071439] BTRFS info (device sdf): forced readonly
Oct 24 17:52:16 backup kernel: [30988.081154] BTRFS debug (device sdf): run_one_delayed_ref returned -28
Oct 24 17:52:16 backup kernel: [30988.081161] BTRFS error (device sdf) in btrfs_run_delayed_refs:2730: errno=-28 No space left
Oct 24 17:55:34 backup kernel: [31186.936384] btrfs: device label backup_fs devid 3 transid 86683 /dev/sdb
Oct 24 17:55:35 backup kernel: [31187.067619] btrfs: disk space caching is enabled
Oct 24 18:01:23 backup kernel: [31535.301582] BTRFS debug (device sdf): unlinked 1 orphans
Oct 24 18:01:23 backup kernel: [31535.339410] btrfs: continuing balance
Oct 24 18:01:23 backup kernel: [31535.624023] btrfs: relocating block group 7438921105408 flags 68
Oct 24 18:02:37 backup kernel: [31609.293378] btrfs: found 26705 extents


Thanks!


