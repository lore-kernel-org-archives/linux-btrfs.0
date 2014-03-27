Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:43333 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbaC0UwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 16:52:18 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 305B44273A6
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 21:52:16 +0100 (CET)
Received: from localhost (ip-95-223-253-98.unitymediagroup.de [95.223.253.98])
	by mail.virtall.com (Postfix) with ESMTPSA id 184284273A4
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 21:52:16 +0100 (CET)
Date: Thu, 27 Mar 2014 21:52:15 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RAID-1 - handling disk failures?
Message-ID: <20140327215215.68b6ef51@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is btrfs supposed to handle disk failures in RAID-1 mode?

It doesn't seem to be the case for me, with 3.14.0-rc8.

Right now, the system doesn't see the faulty drive anymore (i.e. hdparm -i /dev/sdd is unable to give any info).

Accesses to most files on btrfs filesystem just "freeze" (waiting for IO) the process which is accessing the data.

The other drive in RAID-1, /dev/sdc, is healthy.

# grep -i btrfs syslog
Mar 27 09:57:59 bkp010 kernel: [157256.352840] BTRFS: bdev /dev/sdd1 errs: wr 31, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.353334] BTRFS: bdev /dev/sdd1 errs: wr 32, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.353816] BTRFS: bdev /dev/sdd1 errs: wr 33, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.354338] BTRFS: bdev /dev/sdd1 errs: wr 34, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.354826] BTRFS: bdev /dev/sdd1 errs: wr 35, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.355314] BTRFS: bdev /dev/sdd1 errs: wr 36, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.355810] BTRFS: bdev /dev/sdd1 errs: wr 37, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.356302] BTRFS: bdev /dev/sdd1 errs: wr 38, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.356790] BTRFS: bdev /dev/sdd1 errs: wr 39, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:57:59 bkp010 kernel: [157256.357275] BTRFS: bdev /dev/sdd1 errs: wr 40, rd 1, flush 0, corrupt 0, gen 0
Mar 27 09:58:02 bkp010 kernel: [157259.298965] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:02 bkp010 kernel: [157259.299309] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:02 bkp010 kernel: [157259.299637] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:04 bkp010 kernel: [157261.358796] btrfs_dev_stat_print_on_error: 9038 callbacks suppressed
Mar 27 09:58:04 bkp010 kernel: [157261.358844] BTRFS: bdev /dev/sdd1 errs: wr 9007, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.359215] BTRFS: bdev /dev/sdd1 errs: wr 9008, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.359585] BTRFS: bdev /dev/sdd1 errs: wr 9009, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.359954] BTRFS: bdev /dev/sdd1 errs: wr 9010, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.360323] BTRFS: bdev /dev/sdd1 errs: wr 9011, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.360693] BTRFS: bdev /dev/sdd1 errs: wr 9012, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.361063] BTRFS: bdev /dev/sdd1 errs: wr 9013, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.361433] BTRFS: bdev /dev/sdd1 errs: wr 9014, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.361802] BTRFS: bdev /dev/sdd1 errs: wr 9015, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:04 bkp010 kernel: [157261.362172] BTRFS: bdev /dev/sdd1 errs: wr 9016, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.046550] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:09 bkp010 kernel: [157266.046931] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:09 bkp010 kernel: [157266.047307] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:09 bkp010 kernel: [157266.427724] btrfs_dev_stat_print_on_error: 13860 callbacks suppressed
Mar 27 09:58:09 bkp010 kernel: [157266.427788] BTRFS: bdev /dev/sdd1 errs: wr 22877, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.428288] BTRFS: bdev /dev/sdd1 errs: wr 22878, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.431504] BTRFS: bdev /dev/sdd1 errs: wr 22879, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.432047] BTRFS: bdev /dev/sdd1 errs: wr 22880, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.499055] BTRFS: bdev /dev/sdd1 errs: wr 22881, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.499453] BTRFS: bdev /dev/sdd1 errs: wr 22882, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.499847] BTRFS: bdev /dev/sdd1 errs: wr 22883, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.500238] BTRFS: bdev /dev/sdd1 errs: wr 22884, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.500625] BTRFS: bdev /dev/sdd1 errs: wr 22885, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:09 bkp010 kernel: [157266.501692] BTRFS: bdev /dev/sdd1 errs: wr 22886, rd 73, flush 0, corrupt 0, gen 0
Mar 27 09:58:10 bkp010 kernel: [157267.726185] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:10 bkp010 kernel: [157267.726472] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:10 bkp010 kernel: [157267.726758] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:15 bkp010 kernel: [157272.407794] btrfs_dev_stat_print_on_error: 2918 callbacks suppressed
Mar 27 09:58:15 bkp010 kernel: [157272.407856] BTRFS: bdev /dev/sdd1 errs: wr 25804, rd 74, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.428206] BTRFS: bdev /dev/sdd1 errs: wr 25805, rd 74, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.428778] BTRFS: bdev /dev/sdd1 errs: wr 25805, rd 75, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.436211] BTRFS: bdev /dev/sdd1 errs: wr 25806, rd 75, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.436779] BTRFS: bdev /dev/sdd1 errs: wr 25806, rd 76, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.460585] BTRFS: bdev /dev/sdd1 errs: wr 25807, rd 76, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.462577] BTRFS: bdev /dev/sdd1 errs: wr 25807, rd 77, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.463304] BTRFS: bdev /dev/sdd1 errs: wr 25808, rd 77, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.463854] BTRFS: bdev /dev/sdd1 errs: wr 25808, rd 78, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.467755] BTRFS: bdev /dev/sdd1 errs: wr 25809, rd 78, flush 0, corrupt 0, gen 0
Mar 27 09:58:15 bkp010 kernel: [157272.610100] BTRFS info (device sdd1): csum failed ino 998 extent 1290755563520 csum 2566472073 wanted 3738272199 mirror 0
Mar 27 09:58:15 bkp010 kernel: [157272.610621] BTRFS info (device sdd1): csum failed ino 998 extent 1290755563520 csum 2566472073 wanted 3738272199 mirror 0
Mar 27 09:58:15 bkp010 kernel: [157272.611149] BTRFS info (device sdd1): csum failed ino 998 extent 1290755563520 csum 2566472073 wanted 3738272199 mirror 1
Mar 27 09:58:15 bkp010 kernel: [157272.622317] IP: [<ffffffffa02dfc75>] repair_io_failure+0xba/0x19e [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.622464] Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop tpm_infineon tpm_tis tpm parport_pc parport battery button video lpc_ich mfd_core pcspkr acpi_cpufreq i2c_i801 i2c_core ehci_pci ehci_hcd ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
Mar 27 09:58:15 bkp010 kernel: [157272.622724] CPU: 0 PID: 22767 Comm: btrfs-endio-3 Not tainted 3.14.0-rc8 #1
Mar 27 09:58:15 bkp010 kernel: [157272.622949] RIP: 0010:[<ffffffffa02dfc75>]  [<ffffffffa02dfc75>] repair_io_failure+0xba/0x19e [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.625214]  [<ffffffffa02dffb9>] end_bio_extent_readpage+0x260/0x7c4 [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.625401]  [<ffffffffa02c1194>] end_workqueue_fn+0x33/0x38 [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.625454]  [<ffffffffa02ed649>] worker_loop+0x15e/0x495 [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.625506]  [<ffffffffa02ed4eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
Mar 27 09:58:15 bkp010 kernel: [157272.625918] RIP  [<ffffffffa02dfc75>] repair_io_failure+0xba/0x19e [btrfs]
Mar 27 09:58:42 bkp010 kernel: [157299.287358] btrfs_dev_stat_print_on_error: 23 callbacks suppressed
Mar 27 09:58:42 bkp010 kernel: [157299.287436] BTRFS: bdev /dev/sdd1 errs: wr 25820, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.288571] BTRFS: bdev /dev/sdd1 errs: wr 25821, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.289711] BTRFS: bdev /dev/sdd1 errs: wr 25822, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.290859] BTRFS: bdev /dev/sdd1 errs: wr 25823, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.292029] BTRFS: bdev /dev/sdd1 errs: wr 25824, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.293186] BTRFS: bdev /dev/sdd1 errs: wr 25825, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.294320] BTRFS: bdev /dev/sdd1 errs: wr 25826, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.295474] BTRFS: bdev /dev/sdd1 errs: wr 25827, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.296627] BTRFS: bdev /dev/sdd1 errs: wr 25828, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:42 bkp010 kernel: [157299.297762] BTRFS: bdev /dev/sdd1 errs: wr 25829, rd 91, flush 0, corrupt 0, gen 0
Mar 27 09:58:50 bkp010 kernel: [157307.005902] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:50 bkp010 kernel: [157307.006917] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:58:50 bkp010 kernel: [157307.007931] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:59:15 bkp010 kernel: [157332.169244] btrfs_dev_stat_print_on_error: 9421 callbacks suppressed
Mar 27 09:59:15 bkp010 kernel: [157332.169341] BTRFS: bdev /dev/sdd1 errs: wr 40014, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.170688] BTRFS: bdev /dev/sdd1 errs: wr 40015, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.172027] BTRFS: bdev /dev/sdd1 errs: wr 40016, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.173365] BTRFS: bdev /dev/sdd1 errs: wr 40017, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.174701] BTRFS: bdev /dev/sdd1 errs: wr 40018, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.176051] BTRFS: bdev /dev/sdd1 errs: wr 40019, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.177392] BTRFS: bdev /dev/sdd1 errs: wr 40020, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.178731] BTRFS: bdev /dev/sdd1 errs: wr 40021, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.180068] BTRFS: bdev /dev/sdd1 errs: wr 40022, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:15 bkp010 kernel: [157332.181405] BTRFS: bdev /dev/sdd1 errs: wr 40023, rd 148, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.204302] btrfs_dev_stat_print_on_error: 866 callbacks suppressed
Mar 27 09:59:20 bkp010 kernel: [157337.204382] BTRFS: bdev /dev/sdd1 errs: wr 40884, rd 154, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.205685] BTRFS: bdev /dev/sdd1 errs: wr 40884, rd 155, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.215507] BTRFS: bdev /dev/sdd1 errs: wr 40885, rd 155, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.216931] BTRFS: bdev /dev/sdd1 errs: wr 40885, rd 156, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.218269] BTRFS: bdev /dev/sdd1 errs: wr 40885, rd 157, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.232047] BTRFS: bdev /dev/sdd1 errs: wr 40886, rd 157, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.233788] BTRFS: bdev /dev/sdd1 errs: wr 40886, rd 158, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.271991] BTRFS: bdev /dev/sdd1 errs: wr 40887, rd 158, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.273203] BTRFS: bdev /dev/sdd1 errs: wr 40887, rd 159, flush 0, corrupt 0, gen 0
Mar 27 09:59:20 bkp010 kernel: [157337.274338] BTRFS: bdev /dev/sdd1 errs: wr 40887, rd 160, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.210657] btrfs_dev_stat_print_on_error: 1658 callbacks suppressed
Mar 27 09:59:25 bkp010 kernel: [157342.210735] BTRFS: bdev /dev/sdd1 errs: wr 42362, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.211871] BTRFS: bdev /dev/sdd1 errs: wr 42363, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.213005] BTRFS: bdev /dev/sdd1 errs: wr 42364, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.214140] BTRFS: bdev /dev/sdd1 errs: wr 42365, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.215274] BTRFS: bdev /dev/sdd1 errs: wr 42366, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.217075] BTRFS: bdev /dev/sdd1 errs: wr 42367, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.218343] BTRFS: bdev /dev/sdd1 errs: wr 42368, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.219608] BTRFS: bdev /dev/sdd1 errs: wr 42369, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.220898] BTRFS: bdev /dev/sdd1 errs: wr 42370, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:25 bkp010 kernel: [157342.222163] BTRFS: bdev /dev/sdd1 errs: wr 42371, rd 344, flush 0, corrupt 0, gen 0
Mar 27 09:59:34 bkp010 kernel: [157350.875937] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:59:34 bkp010 kernel: [157350.876953] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 09:59:34 bkp010 kernel: [157350.877968] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:00 bkp010 kernel: [157377.482402] btrfs_dev_stat_print_on_error: 8601 callbacks suppressed
Mar 27 10:00:00 bkp010 kernel: [157377.482498] BTRFS: bdev /dev/sdd1 errs: wr 67397, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.483837] BTRFS: bdev /dev/sdd1 errs: wr 67398, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.485169] BTRFS: bdev /dev/sdd1 errs: wr 67399, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.486498] BTRFS: bdev /dev/sdd1 errs: wr 67400, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.487827] BTRFS: bdev /dev/sdd1 errs: wr 67401, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.489156] BTRFS: bdev /dev/sdd1 errs: wr 67402, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.490439] BTRFS: bdev /dev/sdd1 errs: wr 67403, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.491791] BTRFS: bdev /dev/sdd1 errs: wr 67404, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.493125] BTRFS: bdev /dev/sdd1 errs: wr 67405, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:00 bkp010 kernel: [157377.494454] BTRFS: bdev /dev/sdd1 errs: wr 67406, rd 344, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.486976] btrfs_dev_stat_print_on_error: 1218 callbacks suppressed
Mar 27 10:00:05 bkp010 kernel: [157382.487055] BTRFS: bdev /dev/sdd1 errs: wr 68586, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.488203] BTRFS: bdev /dev/sdd1 errs: wr 68587, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.489342] BTRFS: bdev /dev/sdd1 errs: wr 68588, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.491385] BTRFS: bdev /dev/sdd1 errs: wr 68589, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.492730] BTRFS: bdev /dev/sdd1 errs: wr 68590, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.494065] BTRFS: bdev /dev/sdd1 errs: wr 68591, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.495399] BTRFS: bdev /dev/sdd1 errs: wr 68592, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.496741] BTRFS: bdev /dev/sdd1 errs: wr 68593, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.498631] BTRFS: bdev /dev/sdd1 errs: wr 68594, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:05 bkp010 kernel: [157382.499872] BTRFS: bdev /dev/sdd1 errs: wr 68595, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.654641] btrfs_dev_stat_print_on_error: 12557 callbacks suppressed
Mar 27 10:00:15 bkp010 kernel: [157392.654721] BTRFS: bdev /dev/sdd1 errs: wr 92038, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.655880] BTRFS: bdev /dev/sdd1 errs: wr 92039, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.657017] BTRFS: bdev /dev/sdd1 errs: wr 92040, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.659263] BTRFS: bdev /dev/sdd1 errs: wr 92041, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.660420] BTRFS: bdev /dev/sdd1 errs: wr 92042, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.661592] BTRFS: bdev /dev/sdd1 errs: wr 92043, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.662727] BTRFS: bdev /dev/sdd1 errs: wr 92044, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.663862] BTRFS: bdev /dev/sdd1 errs: wr 92045, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.663982] BTRFS: bdev /dev/sdd1 errs: wr 92046, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.665117] BTRFS: bdev /dev/sdd1 errs: wr 92047, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:15 bkp010 kernel: [157392.741518] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:15 bkp010 kernel: [157392.742716] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:15 bkp010 kernel: [157392.743909] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:45 bkp010 kernel: [157422.426129] btrfs_dev_stat_print_on_error: 11 callbacks suppressed
Mar 27 10:00:45 bkp010 kernel: [157422.426228] BTRFS: bdev /dev/sdd1 errs: wr 92059, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.427619] BTRFS: bdev /dev/sdd1 errs: wr 92060, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.429007] BTRFS: bdev /dev/sdd1 errs: wr 92061, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.430341] BTRFS: bdev /dev/sdd1 errs: wr 92062, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.431673] BTRFS: bdev /dev/sdd1 errs: wr 92063, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.433022] BTRFS: bdev /dev/sdd1 errs: wr 92064, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.434355] BTRFS: bdev /dev/sdd1 errs: wr 92065, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.435685] BTRFS: bdev /dev/sdd1 errs: wr 92066, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.437015] BTRFS: bdev /dev/sdd1 errs: wr 92067, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:45 bkp010 kernel: [157422.438346] BTRFS: bdev /dev/sdd1 errs: wr 92068, rd 383, flush 0, corrupt 0, gen 0
Mar 27 10:00:55 bkp010 kernel: [157432.064784] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:55 bkp010 kernel: [157432.065799] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 10:00:55 bkp010 kernel: [157432.066816] BTRFS: lost page write due to I/O error on /dev/sdd1
Mar 27 20:41:23 bkp010 kernel: [195837.280400] btrfs_dev_stat_print_on_error: 14081 callbacks suppressed
Mar 27 20:41:23 bkp010 kernel: [195837.280448] BTRFS: bdev /dev/sdd1 errs: wr 113630, rd 439, flush 0, corrupt 0, gen 0
Mar 27 20:41:23 bkp010 kernel: [195837.280536] BTRFS: bdev /dev/sdd1 errs: wr 113630, rd 440, flush 0, corrupt 0, gen 0
Mar 27 20:41:23 bkp010 kernel: [195837.280624] BTRFS: bdev /dev/sdd1 errs: wr 113630, rd 441, flush 0, corrupt 0, gen 0
Mar 27 20:41:23 bkp010 kernel: [195837.280996] BTRFS: bdev /dev/sdd1 errs: wr 113630, rd 442, flush 0, corrupt 0, gen 0
Mar 27 20:41:23 bkp010 kernel: [195837.281367] BTRFS: bdev /dev/sdd1 errs: wr 113630, rd 443, flush 0, corrupt 0, gen 0



-- 
Tomasz Chmielewski
http://wpkg.org
