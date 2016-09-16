Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dmz.skyward.com ([12.28.97.8]:52879 "EHLO dmz.skyward.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755654AbcIPPKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 11:10:17 -0400
Received: from mailhub.skyward.com (mailhub.skyward.com [10.1.1.28]) by dmz.skyward.com with ESMTP id zybW6VaEgypH44Oz (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 09:57:45 -0500 (CDT)
From: Jeffrey Michels <jeffreym@skyward.com>
To: "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: Filesystem will remount read-only
Date: Fri, 16 Sep 2016 14:57:43 +0000
Message-ID: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a system that has been in production for a few years.  The SAN the VM was running on had a hardware failure about a month ago and now one of the two btrfs filesystems will remount after boot read-only.  Here is the system information:

uname -a

Linux retain 3.0.101-0.47.71-default #1 SMP Thu Nov 12 12:22:22 UTC 2015 (b5b212e) x86_64 x86_64 x86_64 GNU/Linux

Btrfs --version

Btrfs v0.20+

Btrfs fi show

Label: none  uuid: f1e23038-22c1-44b2-8cf8-a3ca6363d2f4
	Total devices 1 FS bytes used 303.01GiB
	devid    1 size 1024.00GiB used 351.04GiB path /dev/dm-2

Label: none  uuid: 85e58f4e-ce56-4b11-9ed9-16abeead8863
	Total devices 1 FS bytes used 83.83GiB
	devid    1 size 149.49GiB used 101.49GiB path /dev/dm-0

Btrfs v0.20+

Btrfs fi df /retain

Data: total=261.01GiB, used=259.23GiB
System, DUP: total=8.00MiB, used=40.00KiB
System: total=4.00MiB, used=0.00
Metadata, DUP: total=45.00GiB, used=43.77GiB
Metadata: total=8.00MiB, used=0.00

Dmesg--Can provide the full output if needed via attachment.  Here is where the fs remounts read-only:

[   55.181245] btrfs: parent transid verify failed on 153295646720 wanted 230487 found 230484
[   55.187980] btrfs: parent transid verify failed on 153295646720 wanted 230487 found 230484
[   55.187991] BTRFS debug (device dm-2): run_one_delayed_ref returned -5
[   55.187994] ------------[ cut here ]------------
[   55.188021] WARNING: at /usr/src/packages/BUILD/kernel-default-3.0.101/linux-3.0/fs/btrfs/super.c:255 __btrfs_abort_transaction+0x60/0x170 [btrfs]()
[   55.188024] Hardware name: VMware Virtual Platform
[   55.188026] btrfs: Transaction aborted (error -5)
[   55.188028] Modules linked in: acpiphp microcode fuse xfs ext3 jbd mbcache loop sr_mod ppdev vmw_balloon(X) i2c_piix4 intel_agp pciehp ipv6_lib cdrom parport_pc shpchp parport rtc_cmos intel_gtt pci_hotplug floppy i2c_core sg container ac mptctl serio_raw button pcspkr btrfs zlib_deflate crc32c libcrc32c dm_mirror dm_region_hash dm_log linear sd_mod crc_t10dif processor thermal_sys hwmon scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh dm_snapshot dm_mod vmw_pvscsi vmxnet3 ata_generic ata_piix libata mptspi mptscsih mptbase scsi_transport_spi scsi_mod
[   55.188071] Supported: Yes, External
[   55.188075] Pid: 1985, comm: sync Tainted: G             X 3.0.101-0.47.71-default #1
[   55.188077] Call Trace:
[   55.188090]  [<ffffffff81004b95>] dump_trace+0x75/0x300
[   55.188097]  [<ffffffff814638a3>] dump_stack+0x69/0x6f
[   55.188104]  [<ffffffff81061f07>] warn_slowpath_common+0x87/0xe0
[   55.188109]  [<ffffffff81062015>] warn_slowpath_fmt+0x45/0x60
[   55.188125]  [<ffffffffa018eb40>] __btrfs_abort_transaction+0x60/0x170 [btrfs]
[   55.188152]  [<ffffffffa01ab466>] btrfs_run_delayed_refs+0x3a6/0x520 [btrfs]
[   55.188192]  [<ffffffffa01bb3de>] btrfs_commit_transaction+0x42e/0xa00 [btrfs]
[   55.188228]  [<ffffffff8118a0f2>] __sync_filesystem+0x62/0xb0
[   55.188234]  [<ffffffff8116133a>] iterate_supers+0x6a/0xc0
[   55.188239]  [<ffffffff8118a1b2>] sys_sync+0x52/0x80
[   55.188244]  [<ffffffff8146e772>] system_call_fastpath+0x16/0x1b
[   55.188251]  [<00007f45758cafc7>] 0x7f45758cafc6
[   55.188253] ---[ end trace c5a604849514ffcd ]---
[   55.188257] BTRFS error (device dm-2) in btrfs_run_delayed_refs:2688: errno=-5 IO failure
[   55.188259] BTRFS info (device dm-2): forced readonly
[   55.188263] BTRFS warning (device dm-2): Skipping commit of aborted transaction.
[   55.188266] BTRFS error (device dm-2) in cleanup_transaction:1538: errno=-5 IO failure

Thank you for your assistance,

Jeff Michels

iCon 2017 Registration is Now Open!
Agents of Innovation
March 8 - 10, 2017
TradeWinds Island Resort, St. Pete Beach, Florida
Register today at: www.skyward.com/icon

PRIVILEGED AND CONFIDENTIAL
Skyward Communication

This is a transmission from Skyward, Inc. and may contain information which is privileged, confidential, and protected by service work privileges.  The response is in direct relationship to the information provided to Skyward.   If you are not the addressee, note that any disclosure, copying, distribution, or use of the contents of this message is prohibited.  If you have received this transmission in error, please destroy it and notify us immediately at 715-341-9406.
