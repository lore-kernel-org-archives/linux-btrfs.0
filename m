Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:38001 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdGGHGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 03:06:31 -0400
Received: by mail-it0-f42.google.com with SMTP id k192so26910672ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Jul 2017 00:06:31 -0700 (PDT)
Subject: Re: Chunk root problem
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
References: <CABRvOkNWpaKB=mAEF9UvUUveFLBQroTWLpC5H=Fqc+okQ_BU3Q@mail.gmail.com>
 <20170707104817.3e2b6273@natsu>
From: Daniel Brady <drbrady@gmail.com>
Message-ID: <350bd522-7169-3510-6c70-87434eef62d6@gmail.com>
Date: Fri, 7 Jul 2017 01:06:26 -0600
MIME-Version: 1.0
In-Reply-To: <20170707104817.3e2b6273@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/6/2017 11:48 PM, Roman Mamedov wrote:
> On Wed, 5 Jul 2017 22:10:35 -0600
> Daniel Brady <drbrady@gmail.com> wrote:
> 
>> parent transid verify failed
> 
> Typically in Btrfs terms this means "you're screwed", fsck will not fix it, and
> nobody will know how to fix or what is the cause either. Time to restore from
> backups! Or look into "btrfs restore" if you don't have any.
> 
> In your case it's especially puzzling as the difference in transid numbers is
> really significant (about 100K), almost like the FS was operating for months
> without updating some parts of itself -- and no checksum errors either, so
> all looks correct, except that everything is horribly wrong.
> 
> This kind of error seems to occur more often in RAID setups, either Btrfs
> native RAID, or with Btrfs on top of other RAID setups -- i.e. where it
> becomes a complex issue that all writes to multi devices DO complete IN order,
> in case of an unclean shutdown. (which is much simpler on a single device FS).
> 
> Also one of your disks or cables is failing (was /dev/sde on that boot, but may
> get a different index next boot), check SMART data for it and replace.
> 
>> [   21.230919] BTRFS info (device sdf): bdev /dev/sde errs: wr 402545, rd
>> 234683174, flush 194501, corrupt 0, gen 0
> 

Well that's not good news. Unfortunately I made a fatal error in not
having a backup. Restore looks like I could recover a good chunk of it
from the dry runs, however it has a lot of trouble reading many files.
I'm sure that is related to the one disk (sde). Drives were setup as raid56.

After updating the kernel as suggested in the email from Duncan it
reduced the "parent transid verify" errors down to just one and the errs
on sde still exist.

[   21.400190] BTRFS info (device sdb): use no compression
[   21.400191] BTRFS info (device sdb): disk space caching is enabled
[   21.400192] BTRFS info (device sdb): has skinny extents
[   21.584923] BTRFS info (device sdb): bdev /dev/sde errs: wr 402545,
rd 234683174, flush 194501, corrupt 0, gen 0
[   23.394788] BTRFS error (device sdb): parent transid verify failed on
5257838690304 wanted 591492 found 489231
[   23.416489] BTRFS error (device sdb): parent transid verify failed on
5257838690304 wanted 591492 found 489231
[   23.416524] BTRFS error (device sdb): failed to read block groups: -5
[   23.448478] BTRFS error (device sdb): open_ctree failed

I ran a SMART test as you suggested with a passing result. I also
swapped SATA cables & power with another drive and the error followed
the drive confirmed by the serial via SMART. It seems like it just can't
read from that one drive for whatever reason. I also tried disconnecting
the drive and trying to mount it degraded with no luck. Still had the
transid error just with null as the bdev.

smartctl -a /dev/sde
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.12.0-1.el7.elrepo.x86_64]
(local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68EUZN0
Serial Number:    WD-WCC4N0PEYTEV
LU WWN Device Id: 5 0014ee 2b7dbfe54
Firmware Version: 82.00A82
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Jul  7 00:30:10 2017 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection:
Disabled.
Self-test execution status:      (   0) The previous self-test routine
completed
                                        without error or no self-test
has ever
                                        been run.
Total time to complete Offline
data collection:                (40500) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 406) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x703d) SCT Status supported.
                                        SCT Error Recovery Control
supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always
      -       0
  3 Spin_Up_Time            0x0027   179   179   021    Pre-fail  Always
      -       6050
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
      -       15
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always
      -       0
  9 Power_On_Hours          0x0032   092   091   000    Old_age   Always
      -       6337
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always
      -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
      -       15
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       5
193 Load_Cycle_Count        0x0032   197   197   000    Old_age   Always
      -       9084
194 Temperature_Celsius     0x0022   122   114   000    Old_age   Always
      -       28
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      6337
    -
# 2  Extended offline    Aborted by host               90%      6337
    -

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

-Dan
