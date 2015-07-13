Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37093 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbGMG0I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 02:26:08 -0400
Received: by wicmz13 with SMTP id mz13so52437567wic.0
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2015 23:26:05 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 Jul 2015 09:26:05 +0300
Message-ID: <CAOE4rSxMhwqn49fqPz2knzaRPyvkRr3roFD-JYTcm2rvB-LKkA@mail.gmail.com>
Subject: Disk "failed" while doing scrub
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Short version: while doing scrub on 5 disk btrfs filesystem, /dev/sdd
"failed" and also had some error on other disk (/dev/sdh)

Because filesystem still mounts, I assume I should do "btrfs device
delete /dev/sdd /mntpoint" and then restore damaged files from backup.
Are all affected files listed in journal? there's messages about "x
callbacks suppressed" so I'm not sure and if there aren't how to get
full list of damaged files?
Also I wonder if there are any tools to recover partial file fragments
and reconstruct file? (where missing fragments filled with nulls)
I assume that there's no point in running "btrfs check
--check-data-csum" because scrub already does check that?

from journal:

kernel: drivers/scsi/mvsas/mv_sas.c 1863:Release slot [1] tag[1], task
[ffff88007efb8800]:
kernel: drivers/scsi/mvsas/mv_94xx.c 625:command active 00000002,  slot [1].
kernel: sas: sas_ata_task_done: SAS error 8a
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: ata9: end_device-7:2: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata9.00: exception Emask 0x0 SAct 0x800 SErr 0x0 action 0x0
kernel: ata9.00: failed command: READ FPDMA QUEUED
kernel: ata9.00: cmd 60/00:00:00:3d:a1/04:00:ab:00:00/40 tag 11 ncq 524288 in
                                            res
41/40:00:48:40:a1/00:04:ab:00:00/00 Emask 0x409 (media error) <F>
kernel: ata9.00: status: { DRDY ERR }
kernel: ata9.00: error: { UNC }
kernel: ata9.00: configured for UDMA/133
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
kernel: sd 7:0:2:0: [sdd] tag#0 Sense Key : 0x3 [current] [descriptor]
kernel: sd 7:0:2:0: [sdd] tag#0 ASC=0x11 ASCQ=0x4
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 ab a1 3d 00 00 04 00 00
kernel: blk_update_request: I/O error, dev sdd, sector 2879471688
kernel: ata9: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: drivers/scsi/mvsas/mv_sas.c 1863:Release slot [1] tag[1], task
[ffff88007efb9a00]:
kernel: drivers/scsi/mvsas/mv_94xx.c 625:command active 00000003,  slot [1].
kernel: sas: sas_ata_task_done: SAS error 8a
kernel: sas: Enter sas_scsi_recover_host busy: 2 failed: 2
kernel: sas: trying to find task 0xffff8801e0cadb00
kernel: sas: sas_scsi_find_task: aborting task 0xffff8801e0cadb00
kernel: sas: sas_scsi_find_task: task 0xffff8801e0cadb00 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8801e0cadb00 is aborted
kernel: sas: ata9: end_device-7:2: cmd error handler
kernel: sas: ata8: end_device-7:1: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: ata8.00: exception Emask 0x0 SAct 0x40000 SErr 0x0 action 0x6 frozen
kernel: ata8.00: failed command: READ FPDMA QUEUED
kernel: ata8.00: cmd 60/00:00:00:1b:36/04:00:bf:00:00/40 tag 18 ncq 524288 in
                                            res
40/00:08:00:58:11/00:00:a6:00:00/40 Emask 0x4 (timeout)
kernel: ata8.00: status: { DRDY }
kernel: ata8: hard resetting link
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata9: log page 10h reported inactive tag 26
kernel: ata9.00: exception Emask 0x1 SAct 0x400000 SErr 0x0 action 0x6
kernel: ata9.00: failed command: READ FPDMA QUEUED
kernel: ata9.00: cmd 60/08:00:48:40:a1/00:00:ab:00:00/40 tag 22 ncq 4096 in
                                            res
01/04:a8:40:40:a1/00:00:ab:00:00/40 Emask 0x3 (HSM violation)
kernel: ata9.00: status: { ERR }
kernel: ata9.00: error: { ABRT }
kernel: ata9: hard resetting link
kernel: sas: sas_form_port: phy1 belongs to port1 already(1)!
kernel: ata9.00: both IDENTIFYs aborted, assuming NODEV
kernel: ata9.00: revalidation failed (errno=-2)
kernel: drivers/scsi/mvsas/mv_sas.c 1428:mvs_I_T_nexus_reset for device[1]:rc= 0
kernel: ata8.00: configured for UDMA/133
kernel: ata8.00: device reported invalid CHS sector 0
kernel: ata8: EH complete
kernel: ata9: hard resetting link
kernel: ata9.00: both IDENTIFYs aborted, assuming NODEV
kernel: ata9.00: revalidation failed (errno=-2)
kernel: ata9: hard resetting link
kernel: ata9.00: both IDENTIFYs aborted, assuming NODEV
kernel: ata9.00: revalidation failed (errno=-2)
kernel: ata9.00: disabled
kernel: ata9: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 ab a1 40 48 00 00 08 00
kernel: blk_update_request: I/O error, dev sdd, sector 2879471688
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 ab a1 45 00 00 06 00 00
kernel: BTRFS: unable to fixup (regular) error at logical
7390602616832 on dev /dev/sdd
kernel: BTRFS: unable to fixup (regular) error at logical
7390602891264 on dev /dev/sdd
kernel: scsi_io_completion: 186117 callbacks suppressed
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x2a 2a 00 00 14 78 c0 00 00 20 00
kernel: blk_update_request: 186156 callbacks suppressed
kernel: blk_update_request: I/O error, dev sdd, sector 1341632
kernel: sd 7:0:2:0: [sdd] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#1 CDB: opcode=0x2a 2a 00 00 14 7a 80 00 00 20 00
kernel: blk_update_request: I/O error, dev sdd, sector 2879472896
kernel: BTRFS: i/o error at logical 7386235424768 on dev /dev/sdd,
sector 2891849768, root 3034, inode 5633529, offset 11878400, length
4096, links 1 (path: [...])
kernel: BTRFS: i/o error at logical 7386235039744 on dev /dev/sdd,
sector 2891849016, root 3034, inode 5633529, offset 11493376, length
4096, links 1 (path: [...])
kernel: btrfs_dev_stat_print_on_error: 78908 callbacks suppressed
kernel: BTRFS: bdev /dev/sdd errs: wr 347, rd 1644871, flush 0, corrupt 0, gen 0
kernel: BTRFS: bdev /dev/sdd errs: wr 356, rd 1644871, flush 0, corrupt 0, gen 0
kernel: BTRFS: error (device sdh) in write_all_supers:3454: errno=-5
IO failure (errors while submitting device barriers.)
kernel: BTRFS info (device sdh): forced readonly
kernel: BTRFS warning (device sdh): Skipping commit of aborted transaction.
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 5 PID: 3756 at fs/btrfs/super.c:260
__btrfs_abort_transaction+0x54/0x130 [btrfs]()
kernel: BTRFS: Transaction aborted (error -5)
kernel: Modules linked in: nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT [...]
kernel:  nvidia(PO) tda8290 tuner aes_x86_64 lrw saa7134
snd_hda_codec_realtek gf128mul edac_core glue_helper [...]
kernel:
kernel: CPU: 5 PID: 3756 Comm: btrfs-transacti Tainted: P           O
  4.0.7-2-ARCH #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 000000005f5d9ca7 ffff88006090fc18 ffffffff81574ec3
kernel:  0000000000000000 ffff88006090fc70 ffff88006090fc58 ffffffff81074e7a
kernel:  0000000000000000 ffff8800ce8e6c60 00000000fffffffb ffff8800bbaa4800
kernel: Call Trace:
kernel:  [<ffffffff81574ec3>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff81074e7a>] warn_slowpath_common+0x8a/0xc0
kernel:  [<ffffffff81074f05>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffffa0253bb4>] __btrfs_abort_transaction+0x54/0x130 [btrfs]
kernel:  [<ffffffffa0282ceb>] cleanup_transaction+0x7b/0x300 [btrfs]
kernel:  [<ffffffff810b6ce0>] ? wake_atomic_t_function+0x60/0x60
kernel:  [<ffffffffa0284162>] btrfs_commit_transaction+0x932/0xc10 [btrfs]
kernel:  [<ffffffffa027f3a5>] transaction_kthread+0x1d5/0x240 [btrfs]
kernel:  [<ffffffffa027f1d0>] ? btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
kernel:  [<ffffffff810934b8>] kthread+0xd8/0xf0
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8157a718>] ret_from_fork+0x58/0x90
kernel:  [<ffffffff810933e0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 8ecc49ef203bd88c ]---
kernel: BTRFS: error (device sdh) in cleanup_transaction:1686:
errno=-5 IO failure
kernel: BTRFS info (device sdh): delayed_refs has NO entry
kernel: scrub_handle_errored_block: 92600 callbacks suppressed
kernel: BTRFS: i/o error at logical 7390928568320 on dev /dev/sdd,
sector 2892627456, root 3034, inode 5637106, offset 614400, length
4096, links 1 (path: [...])
kernel: BTRFS: i/o error at logical 7390928175104 on dev /dev/sdd,
sector 2892626688, root 3034, inode 5637106, offset 483328, length
4096, links 1 (path: [...])
kernel: scrub_handle_errored_block: 77404 callbacks suppressed
kernel: BTRFS: unable to fixup (regular) error at logical
7390928568320 on dev /dev/sdd
kernel: BTRFS: unable to fixup (regular) error at logical
7390928175104 on dev /dev/sdd
smartd[723]: Device: /dev/sdd [SAT], not capable of SMART self-check
smartd[723]: Device: /dev/sdd [SAT], failed to read SMART Attribute Data
smartd[723]: Device: /dev/sdd [SAT], Read SMART Self Test Log Failed
smartd[723]: Device: /dev/sdd [SAT], Read Summary SMART Error Log failed
kernel: scsi_io_completion: 8110 callbacks suppressed
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 e8 e0 88 00 00 00 08 00
kernel: blk_update_request: 8115 callbacks suppressed
kernel: blk_update_request: I/O error, dev sdd, sector 3907028992
kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 e8 e0 88 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdd, sector 3907028992
kernel: Buffer I/O error on dev sdd, logical block 488378624, async page read


Long story:

I had Seagate disk which died, but still was covered by warranty so I
got replacement, only disk they returned wasn't new, but repaired
and I haven't used it much, but seems it won't hold for long as it got
uncorrectable sectors.
When I received it, I did full SMART test and checked all sectors,
everything passed and seemed to be good, but now I copied my data
and used it for a while, only to find

smartd[592]: Device: /dev/sdd [SAT], 16 Currently unreadable (pending) sectors
smartd[592]: Device: /dev/sdd [SAT], 16 Offline uncorrectable sectors

then I ran scrub

scrub status for 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
       scrub started at Sun Jul 12 13:36:11 2015 and was aborted after 02:43:21
       total bytes scrubbed: 6.24TiB with 1648151 errors
       error details: read=1648151
       corrected errors: 704, uncorrectable errors: 1647447,
unverified errors: 0

it caused drive to become unrecognizable by Linux and seems it also
made some error for different disk (/dev/sdh)
which caused filesystem to become read-only and didn't mount

kernel: sd 7:0:2:0: [sdd] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] tag#0 CDB: opcode=0x28 28 00 00 00 00 80 00 00 08 00
kernel: blk_update_request: I/O error, dev sdd, sector 128
kernel: BTRFS info (device sdh): enabling auto defrag
kernel: BTRFS info (device sdh): disk space caching is enabled
kernel: BTRFS: has skinny extents
kernel: BTRFS: failed to read chunk tree on sdh
mount[17625]: mount: wrong fs type, bad option, bad superblock on /dev/sdh,
mount[17625]: missing codepage or helper program, or other error
mount[17625]: In some cases useful info is found in syslog - try
mount[17625]: dmesg | tail or so.
kernel: BTRFS: open_ctree failed
kernel: sd 7:0:2:0: [sdd] Synchronizing SCSI cache
kernel: sd 7:0:2:0: [sdd] Synchronize Cache(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:2:0: [sdd] Stopping disk
kernel: sd 7:0:2:0: [sdd] Start/Stop Unit failed: Result:
hostbyte=0x04 driverbyte=0x00

pulled out that /dev/sdd drive and plugged back in

kernel: mvsas 0000:07:00.0: Phy2 : No sig fis
kernel: sas: phy-7:2 added to port-7:2, phy_mask:0x4 ( 200000000000000)
kernel: sas: DOING DISCOVERY on port 2, pid:16744
kernel: sas: DONE DISCOVERY on port 2, pid:16744, result:0
kernel: sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: ata20.00: ATA-8: ST2000DM001-9YN164, CC9F, max UDMA/133
kernel: ata20.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
kernel: ata20.00: configured for UDMA/133
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: scsi 7:0:8:0: Direct-Access     ATA      ST2000DM001-9YN1 CC9F
PQ: 0 ANSI: 5
kernel: sd 7:0:8:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
kernel: sd 7:0:8:0: [sdd] 4096-byte physical blocks
kernel: sd 7:0:8:0: [sdd] Write Protect is off
kernel: sd 7:0:8:0: [sdd] Mode Sense: 00 3a 00 00
kernel: sd 7:0:8:0: [sdd] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
kernel: sd 7:0:8:0: [sdd] Attached SCSI disk
smartd[723]: Device: /dev/sdd [SAT], SMART Usage Attribute: 187
Reported_Uncorrect changed from 100 to 98
smartd[723]: Device: /dev/sdd [SAT], previous self-test completed with
error (read test element)
smartd[723]: Device: /dev/sdd [SAT], Self-Test Log error count
increased from 0 to 2
smartd[723]: Device: /dev/sdd [SAT], ATA error count increased from 0 to 2

everything seems "ok" again, run short SMART self-test which now
failed for first time (but disk SMART status still says PASSED)
then resumed scrub and it completed

scrub status for 1ec5b839-acc6-4f70-be9d-6f9e6118c71c
scrub device /dev/sdc (id 1) history
       scrub resumed at Sun Jul 12 18:07:06 2015 and finished after 04:34:02
       total bytes scrubbed: 2.35TiB with 0 errors
scrub device /dev/sdd (id 2) history
       scrub resumed at Sun Jul 12 18:07:06 2015 and finished after 02:56:23
       total bytes scrubbed: 1.44TiB with 1648151 errors
       error details: read=1648151
       corrected errors: 704, uncorrectable errors: 1647447,
unverified errors: 0
scrub device /dev/sde (id 3) history
       scrub started at Sun Jul 12 13:36:11 2015 and finished after 02:35:46
       total bytes scrubbed: 1.43TiB with 0 errors
scrub device /dev/sdg (id 4) history
       scrub started at Sun Jul 12 13:36:11 2015 and finished after 02:40:01
       total bytes scrubbed: 1.44TiB with 0 errors
scrub device /dev/sdh (id 5) history
       scrub started at Sun Jul 12 13:36:11 2015 and finished after 01:14:34
       total bytes scrubbed: 537.82GiB with 0 errors

btrfs device stats doesn't show any errors

[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 0
[/dev/sdc].generation_errs 0
[/dev/sdd].write_io_errs   0
[/dev/sdd].read_io_errs    0
[/dev/sdd].flush_io_errs   0
[/dev/sdd].corruption_errs 0
[/dev/sdd].generation_errs 0
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0
[/dev/sdg].write_io_errs   0
[/dev/sdg].read_io_errs    0
[/dev/sdg].flush_io_errs   0
[/dev/sdg].corruption_errs 0
[/dev/sdg].generation_errs 0
[/dev/sdh].write_io_errs   0
[/dev/sdh].read_io_errs    0
[/dev/sdh].flush_io_errs   0
[/dev/sdh].corruption_errs 0
[/dev/sdh].generation_errs 0


other disk /dev/sdh doesn't show any signs if it would have become bad
so most likely it was controller's fault when sdd threw errors.
when scrub says about error counts, what exactly count's as error, a
file fragment?
also are there some easy way to locate those unreadable sectors and
rewrite them so hdd relocates them?

Thanks :)

Here's ful SMART info for /dev/sdd

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST2000DM001-9YN164
Serial Number:    W2404VST
LU WWN Device Id: 5 000c50 044a7a68a
Firmware Version: CC9F
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Jul 13 07:40:14 2015 EEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     128 (minimum power consumption without standby)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Unavailable

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                       was never started.
                                       Auto Offline Data Collection: Disabled.
Self-test execution status:      ( 121) The previous self-test completed having
                                       the read element of the test failed.
Total time to complete Offline
data collection:                (  592) seconds.
Offline data collection
capabilities:                    (0x73) SMART execute Offline immediate.
                                       Auto Offline data collection
on/off support.
                                       Suspend Offline collection upon new
                                       command.
                                       No Offline surface scan supported.
                                       Self-test supported.
                                       Conveyance Self-test supported.
                                       Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                       power-saving mode.
                                       Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                       General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 254) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3081) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 1 Raw_Read_Error_Rate     POSR--   117   100   006    -    166724616
 3 Spin_Up_Time            PO----   092   092   000    -    0
 4 Start_Stop_Count        -O--CK   100   100   020    -    626
 5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
 7 Seek_Error_Rate         POSR--   060   060   030    -    1306645
 9 Power_On_Hours          -O--CK   097   097   000    -    3154
10 Spin_Retry_Count        PO--C-   100   100   097    -    0
12 Power_Cycle_Count       -O--CK   100   100   020    -    433
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   098   098   000    -    2
188 Command_Timeout         -O--CK   100   099   000    -    4 4 4
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   070   058   045    -    30 (0 1 34 29 0)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    335
193 Load_Cycle_Count        -O--CK   096   096   000    -    9566
194 Temperature_Celsius     -O---K   030   042   000    -    30 (128 0 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    16
198 Offline_Uncorrectable   ----C-   100   100   000    -    16
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    367h+26m+14.504s
241 Total_LBAs_Written      ------   100   253   000    -    38608136381115
242 Total_LBAs_Read         ------   100   253   000    -    7979572945843
                           ||||||_ K auto-keep
                           |||||__ C event count
                           ||||___ R error rate
                           |||____ S speed/performance
                           ||_____ O updated online
                           |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS      20  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    5067  Device vendor specific log
0xbd       GPL     VS     512  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 2
       CR     = Command Register
       FEATR  = Features Register
       COUNT  = Count (was: Sector Count) Register
       LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
       LH     = LBA High (was: Cylinder High) Register    ]   LBA
       LM     = LBA Mid (was: Cylinder Low) Register      ] Register
       LL     = LBA Low (was: Sector Number) Register     ]
       DV     = Device (was: Device/Head) Register
       DC     = Device Control Register
       ER     = Error register
       ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 2 [1] occurred at disk power-on lifetime: 3139 hours (130 days + 19 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 40 -- 51 00 00 00 00 ab a1 40 48 00 00  Error: UNC at LBA =
0xaba14048 = 2879471688

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 60 00 00 00 08 00 00 ab a1 40 48 40 00     02:54:39.784  READ FPDMA QUEUED
 60 00 00 00 08 00 00 ab a1 40 40 40 00     02:54:39.783  READ FPDMA QUEUED
 60 00 00 00 08 00 00 ab a1 40 38 40 00     02:54:39.783  READ FPDMA QUEUED
 60 00 00 00 08 00 00 ab a1 40 30 40 00     02:54:39.782  READ FPDMA QUEUED
 60 00 00 00 08 00 00 ab a1 40 28 40 00     02:54:39.782  READ FPDMA QUEUED

Error 1 [0] occurred at disk power-on lifetime: 3139 hours (130 days + 19 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 40 -- 51 00 00 00 00 ab a1 40 48 00 00  Error: UNC at LBA =
0xaba14048 = 2879471688

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 60 00 00 04 00 00 00 ab a0 14 00 40 00     02:54:36.512  READ FPDMA QUEUED
 60 00 00 04 00 00 00 ab a0 10 00 40 00     02:54:36.500  READ FPDMA QUEUED
 60 00 00 04 00 00 00 ab a0 0c 00 40 00     02:54:36.498  READ FPDMA QUEUED
 60 00 00 04 00 00 00 ab a0 08 00 40 00     02:54:36.497  READ FPDMA QUEUED
 60 00 00 04 00 00 00 ab 9f f9 00 40 00     02:54:36.402  READ FPDMA QUEUED

SMART Error Log Version: 1
ATA Error Count: 2
       CR = Command Register [HEX]
       FR = Features Register [HEX]
       SC = Sector Count Register [HEX]
       SN = Sector Number Register [HEX]
       CL = Cylinder Low Register [HEX]
       CH = Cylinder High Register [HEX]
       DH = Device/Head Register [HEX]
       DC = Device Command Register [HEX]
       ER = Error register [HEX]
       ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 2 occurred at disk power-on lifetime: 3139 hours (130 days + 19 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER ST SC SN CL CH DH
 -- -- -- -- -- -- --
 40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

 Commands leading to the command that caused the error were:
 CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
 -- -- -- -- -- -- -- --  ----------------  --------------------
 60 00 08 ff ff ff 4f 00      02:54:39.784  READ FPDMA QUEUED
 60 00 08 ff ff ff 4f 00      02:54:39.783  READ FPDMA QUEUED
 60 00 08 ff ff ff 4f 00      02:54:39.783  READ FPDMA QUEUED
 60 00 08 ff ff ff 4f 00      02:54:39.782  READ FPDMA QUEUED
 60 00 08 ff ff ff 4f 00      02:54:39.782  READ FPDMA QUEUED

Error 1 occurred at disk power-on lifetime: 3139 hours (130 days + 19 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER ST SC SN CL CH DH
 -- -- -- -- -- -- --
 40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

 Commands leading to the command that caused the error were:
 CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
 -- -- -- -- -- -- -- --  ----------------  --------------------
 60 00 00 ff ff ff 4f 00      02:54:36.512  READ FPDMA QUEUED
 60 00 00 ff ff ff 4f 00      02:54:36.500  READ FPDMA QUEUED
 60 00 00 ff ff ff 4f 00      02:54:36.498  READ FPDMA QUEUED
 60 00 00 ff ff ff 4f 00      02:54:36.497  READ FPDMA QUEUED
 60 00 00 ff ff ff 4f 00      02:54:36.402  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       90%      3139
      2879471688
# 2  Short offline       Completed: read failure       90%      3139
      2879471688
# 3  Short offline       Completed without error       00%      3049         -
# 4  Conveyance offline  Completed without error       00%      2996         -
# 5  Short offline       Completed without error       00%      2239         -
# 6  Extended offline    Completed without error       00%      2238         -
# 7  Short offline       Completed without error       00%      1550         -
# 8  Short offline       Completed without error       00%      1550         -
# 9  Short offline       Completed without error       00%        69         -
#10  Short offline       Completed without error       00%         9         -

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       90%      3139
      2879471688
# 2  Short offline       Completed: read failure       90%      3139
      2879471688
# 3  Short offline       Completed without error       00%      3049         -
# 4  Conveyance offline  Completed without error       00%      2996         -
# 5  Short offline       Completed without error       00%      2239         -
# 6  Extended offline    Completed without error       00%      2238         -
# 7  Short offline       Completed without error       00%      1550         -
# 8  Short offline       Completed without error       00%      1550         -
# 9  Short offline       Completed without error       00%        69         -
#10  Short offline       Completed without error       00%         9         -

SMART Selective self-test log data structure revision number 1
SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
   1        0        0  Not_testing
   2        0        0  Not_testing
   3        0        0  Not_testing
   4        0        0  Not_testing
   5        0        0  Not_testing
Selective self-test flags (0x0):
 After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    30 Celsius
Power Cycle Min/Max Temperature:     29/34 Celsius
Lifetime    Min/Max Temperature:      9/42 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS





SMART info for /dev/sdh

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F3
Device Model:     SAMSUNG HD103SJ
Serial Number:    S246JDWZ113593
LU WWN Device Id: 5 0024e9 002bf43c5
Firmware Version: 1AJ100E4
User Capacity:    1 000 204 886 016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Mon Jul 13 07:53:49 2015 EEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                       was completed without error.
                                       Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                       without error or no self-test has ever
                                       been run.
Total time to complete Offline
data collection:                ( 9420) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                       Auto Offline data collection
on/off support.
                                       Suspend Offline collection upon new
                                       command.
                                       Offline surface scan supported.
                                       Self-test supported.
                                       No Conveyance Self-test supported.
                                       Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                       power-saving mode.
                                       Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                       General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 157) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                       SCT Error Recovery Control supported.
                                       SCT Feature Control supported.
                                       SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    1
 2 Throughput_Performance  -OS--K   055   055   000    -    8621
 3 Spin_Up_Time            PO---K   073   071   025    -    8314
 4 Start_Stop_Count        -O--CK   091   091   000    -    9745
 5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
 7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
 8 Seek_Time_Performance   --S--K   252   252   015    -    0
 9 Power_On_Hours          -O--CK   100   100   000    -    20675
10 Spin_Retry_Count        -O--CK   252   252   051    -    0
11 Calibration_Retry_Count -O--CK   252   252   000    -    0
12 Power_Cycle_Count       -O--CK   097   097   000    -    3297
191 G-Sense_Error_Rate      -O---K   100   100   000    -    42
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   043   000    -    32 (Min/Max 4/57)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   100   100   000    -    2
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    101
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    9897
                           ||||||_ K auto-keep
                           |||||__ C event count
                           ||||___ R error rate
                           |||____ S speed/performance
                           ||_____ O updated online
                           |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      2  Comprehensive SMART error log
0x03       GPL     R/O      2  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      2  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xbb       GPL     VS       4  Device vendor specific log
0xbc       GPL     VS       2  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
Device Error Count: 2
       CR     = Command Register
       FEATR  = Features Register
       COUNT  = Count (was: Sector Count) Register
       LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
       LH     = LBA High (was: Cylinder High) Register    ]   LBA
       LM     = LBA Mid (was: Cylinder Low) Register      ] Register
       LL     = LBA Low (was: Sector Number) Register     ]
       DV     = Device (was: Device/Head) Register
       DC     = Device Control Register
       ER     = Error register
       ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 2 [1] occurred at disk power-on lifetime: 4244 hours (176 days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 84 -- 51 93 e8 00 00 00 00 00 00 e0 00  Error: ICRC, ABRT 37864
sectors at LBA = 0x00000000 = 0

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 35 00 00 01 00 00 00 61 18 92 e8 e0 08     00:00:01.927  WRITE DMA EXT
 25 00 00 01 00 00 00 1b ce e8 60 e0 08     00:00:01.927  READ DMA EXT
 25 00 00 01 00 00 00 1b ce e7 60 e0 08     00:00:01.927  READ DMA EXT
 25 00 00 01 00 00 00 1b ce e6 60 e0 08     00:00:01.927  READ DMA EXT
 25 00 00 01 00 00 00 1b ce e5 60 e0 08     00:00:01.927  READ DMA EXT

Error 1 [0] occurred at disk power-on lifetime: 2234 hours (93 days + 2 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 84 -- 51 e5 ee 00 00 00 00 00 00 e0 00  Error: ICRC, ABRT 58862
sectors at LBA = 0x00000000 = 0

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 35 00 00 00 06 00 00 00 35 e5 e8 e0 08     00:00:17.173  WRITE DMA EXT
 35 00 00 00 08 00 00 06 d5 77 10 e0 08     00:00:17.173  WRITE DMA EXT
 35 00 00 00 03 00 00 00 82 12 48 e0 08     00:00:17.173  WRITE DMA EXT
 35 00 00 00 07 00 00 06 d5 77 10 e0 08     00:00:17.171  WRITE DMA EXT
 35 00 00 00 03 00 00 00 82 12 48 e0 08     00:00:17.171  WRITE DMA EXT

SMART Error Log Version: 1
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     20661         -
# 2  Extended offline    Completed without error       00%     19724         -
# 3  Short offline       Completed without error       00%     19721         -
# 4  Short offline       Aborted by host               90%     19404         -
# 5  Short offline       Completed without error       00%     18910         -
# 6  Short offline       Completed without error       00%     15792         -
# 7  Short offline       Completed without error       00%     15792         -

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     20661         -
# 2  Extended offline    Completed without error       00%     19724         -
# 3  Short offline       Completed without error       00%     19721         -
# 4  Short offline       Aborted by host               90%     19404         -
# 5  Short offline       Completed without error       00%     18910         -
# 6  Short offline       Completed without error       00%     15792         -
# 7  Short offline       Completed without error       00%     15792         -

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has
ever been run
SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
   1        0        0  Completed [00% left] (0-65535)
   2        0        0  Not_testing
   3        0        0  Not_testing
   4        0        0  Not_testing
   5        0        0  Not_testing
Selective self-test flags (0x0):
 After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    32 Celsius
Power Cycle Min/Max Temperature:     24/38 Celsius
Lifetime    Min/Max Temperature:      7/57 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (106)

Index    Estimated Time   Temperature Celsius
107    2015-07-12 21:15    35  ****************
108    2015-07-12 21:20    34  ***************
105    2015-07-13 07:45    33  **************
106    2015-07-13 07:50    32  *************

SCT Error Recovery Control:
          Read: Disabled
         Write: Disabled

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  4            0  Command failed due to ICRC error
0x0002  4            0  R_ERR response for data FIS
0x0003  4            0  R_ERR response for device-to-host data FIS
0x0004  4            0  R_ERR response for host-to-device data FIS
0x0005  4            0  R_ERR response for non-data FIS
0x0006  4            0  R_ERR response for device-to-host non-data FIS
0x0007  4            0  R_ERR response for host-to-device non-data FIS
0x0008  4            0  Device-to-host non-data FIS retries
0x0009  4            1  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            2  Device-to-host register FISes sent due to a COMRESET
0x000b  4            0  CRC errors within host-to-device FIS
0x000d  4            0  Non-CRC errors within host-to-device FIS
0x000f  4            0  R_ERR response for host-to-device data FIS, CRC
0x0010  4            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  4            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  4            0  R_ERR response for host-to-device non-data FIS, non-CRC
0x8e00  4            0  Vendor specific
0x8e01  4            0  Vendor specific
0x8e02  4            0  Vendor specific
0x8e03  4            0  Vendor specific
0x8e04  4            0  Vendor specific
0x8e05  4            0  Vendor specific
0x8e06  4            0  Vendor specific
0x8e07  4            0  Vendor specific
0x8e08  4            0  Vendor specific
0x8e09  4            0  Vendor specific
0x8e0a  4            0  Vendor specific
0x8e0b  4            0  Vendor specific
0x8e0c  4            0  Vendor specific
0x8e0d  4            0  Vendor specific
0x8e0e  4            0  Vendor specific
0x8e0f  4            0  Vendor specific
0x8e10  4            0  Vendor specific
0x8e11  4            0  Vendor specific
