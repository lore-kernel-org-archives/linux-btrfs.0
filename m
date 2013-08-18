Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:44074 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3HRTNO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Aug 2013 15:13:14 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 55CFF11F838
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Aug 2013 21:13:09 +0200 (CEST)
Received: from shiva (unknown [88.171.134.228])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 3748F4C80B9
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Aug 2013 21:12:32 +0200 (CEST)
Message-ID: <52111C9D.3090704@pook.it>
Date: Sun, 18 Aug 2013 21:12:29 +0200
From: Stuart Pook <slp644161@pook.it>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: uncorrectable errors after btrfs replace
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org>
In-Reply-To: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi all

I moved my btrfs filesystems around using btrfs replace and now I have errors (lots of errors)

[63724.419779] BTRFS info (device dm-12): csum failed ino 9340 off 8192 csum 717036259 private 94677163

: root; time  btrfs  scrub start -Bd /disks/backups
scrub device /dev/dm-11 (id 1) done
	scrub started at Sun Aug 18 15:17:50 2013 and finished after 4487 seconds
	total bytes scrubbed: 576.46GB with 261883 errors
	error details: csum=261883
	corrected errors: 0, uncorrectable errors: 261883, unverified errors: 0

I had two 2 Tb disks who's data I needed to swap (/mnt on a WD-Black & /disks/backup on a HD204UI). Both had btrfs systems but /disks/backup was encrypted using luks. I had a spare 640 Gb WD-Blue disk that I plugged into an SATA dock for this operation.

I "btrfs resize"d /disks/backup to fit in 590 GB then I "btrfs replace"d /disks/backup to a new luks partition on the WD-Blue disk. Then I "btrfs replace"d /mnt to the HD204UI.  Then I "btrfs replace"d the backup data to a new luks partition on the WD-Black. I then got IO Errors reading /disks/backup.

I'm using: Linux kooka 3.10-2-amd64 #1 SMP Debian 3.10.5-1 (2013-08-07) x86_64 GNU/Linux
and btrfs-tools 0.19+20130315-5

rsync: write failed on "/disks/backups/snapshot_rsync/stuart/secret/current/.purple/accounts.xml": Input/output error (5)

Lots of files on /disks/backup have errors. smartctl says passed for all the drives.

This is a summary of what I did:

     6  btrfs filesystem resize 580g .
     9  time btrfs  balance start -musage=1 -dusage=1 . && time  btrfs filesystem resize 580g .
    10  time  btrfs filesystem resize 590g .
    12  cryptsetup luksOpen /dev/sdd2 640Gb
    13  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
    14  time btrfs replace start  /dev/dm-11 /dev/dm-12 -B /disks/backups
    18  cryptsetup remove _dev_sdc2
    19  fdisk /dev/sdc
    32  time btrfs replace start  /dev/sdb1  /dev/sdc2 -B /mnt
    34  btrfs filesystem label  /dev/dm-12
    36   btrfs filesystem label /disks/backups backups2Tb
    38   btrfs filesystem label /disks/backups
    39  cryptsetup luksFormat /dev/sdb2
    40  cryptsetup luksAddKey /dev/sdb2
    41  cryptsetup open  /dev/sdb2 newbackups
    43  time btrfs replace start  /dev/dm-12  /dev/dm-11 -B /disks/backups
    44  btrfs filesystem show
    45  cryptsetup status 640Gb
    46  cryptsetup remove 640Gb
    47  btrfs filesystem show
    49  btrfs filesystem resize max /disks/backups/
    54  /etc/local/backups
# errors !
    57  time  btrfs  scrub start -Bd /disks/backups

Lots of errors in /var/log/syslog

Aug 18 12:27:51 kooka kernel: [54113.507151] btrfs: dev_replace from /dev/mapper/640Gb (devid 1) to /dev/dm-11) started
Aug 18 12:27:51 kooka kernel: [54113.601334] device label backups2Tb devid 1 transid 39282 /dev/dm-12
Aug 18 12:28:03 kooka kernel: [54125.020038] ata10.00: exception Emask 0x10 SAct 0x3dfe0ff0 SErr 0x780100 action 0x6
Aug 18 12:28:03 kooka kernel: [54125.020043] ata10.00: irq_stat 0x08000000
Aug 18 12:28:03 kooka kernel: [54125.020047] ata10: SError: { UnrecovData 10B8B Dispar BadCRC Handshk }
Aug 18 12:28:03 kooka kernel: [54125.020050] ata10.00: failed command: READ FPDMA QUEUED
Aug 18 12:28:03 kooka kernel: [54125.020056] ata10.00: cmd 60/18:20:c0:18:0b/00:00:00:00:00/40 tag 4 ncq 12288 in
Aug 18 12:28:03 kooka kernel: [54125.020056]          res 40/00:5c:f0:1a:0b/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Aug 18 12:28:03 kooka kernel: [54125.020059] ata10.00: status: { DRDY }
[...]
Aug 18 12:28:03 kooka kernel: [54125.020262] ata10: hard resetting link
Aug 18 12:28:03 kooka kernel: [54125.512032] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 18 12:28:03 kooka kernel: [54125.523759] ata10.00: configured for UDMA/133
Aug 18 12:28:03 kooka kernel: [54125.536380] ata10: EH complete
Aug 18 12:28:04 kooka kernel: [54125.770176] ata10.00: exception Emask 0x10 SAct 0x7fffffff SErr 0x780100 action 0x6
Aug 18 12:28:04 kooka kernel: [54125.770181] ata10.00: irq_stat 0x08000000
Aug 18 12:28:04 kooka kernel: [54125.770184] ata10: SError: { UnrecovData 10B8B Dispar BadCRC Handshk }
[...]
Aug 18 12:28:17 kooka kernel: [54138.957095] ata10.00: status: { DRDY }
Aug 18 12:28:17 kooka kernel: [54138.957100] ata10: hard resetting link
Aug 18 12:28:17 kooka kernel: [54139.448029] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Aug 18 12:28:17 kooka kernel: [54139.449972] ata10.00: configured for UDMA/133
Aug 18 12:28:17 kooka kernel: [54139.464065] ata10: EH complete
[...]

Aug 18 12:38:31 kooka kernel: [54753.527070] btrfs: checksum error at logical 52642709504 on dev /dev/dm-12, sector 104931328, root 1281, inode 42152, offset 0, length 4096, links 1 (path: XXXXX)
[...]
Aug 18 12:38:31 kooka kernel: [54753.606566] btrfs: bdev /dev/dm-12 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[...]
Aug 18 12:38:32 kooka kernel: [54753.679513] btrfs: bdev /dev/dm-12 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
Aug 18 12:38:36 kooka kernel: [54758.076089] scrub_handle_errored_block: 15173 callbacks suppressed
[...]
Aug 18 12:38:52 kooka kernel: [54774.647414] btrfs: bdev /dev/dm-12 errs: wr 0, rd 0, flush 0, corrupt 65313, gen 0
[...]
Aug 18 15:24:03 kooka kernel: [64685.641464] btrfs: unable to fixup (regular) error at logical 52643758080 on dev /dev/dm-11

It appears that my WD-Blue or its connection is bad but why didn't the "btrfs replace" give me an error? "btrfs replace" seems to have read bad data without checking the checksum and then wrote the bad data to the new disk.

ata10 is the WD-Blue

Aug 17 21:26:19 kooka kernel: [    1.410573] ata10.00: ATA-8: WDC WD6400AAKS-00A7B2, 01.03B01, max UDMA/133

: root; sleep 2m;  smartctl -a   /dev/sdd
[...]
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0027   161   158   021    Pre-fail  Always       -       4933
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       327
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   070   070   000    Old_age   Always       -       22077
  10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       245
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       169
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       327
194 Temperature_Celsius     0x0022   096   090   000    Old_age   Always       -       51
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       12080
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

I guess that /disks/backup is mostly dead and that I should just reformat it.  What do you think?  Next time I'll watch /var/log/syslog but I would have preferred that "btrfs replace" stop when getting errors.

thanks, Stuart

