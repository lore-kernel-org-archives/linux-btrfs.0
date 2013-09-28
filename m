Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3I1WvT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 18:51:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQ3M5-0007HK-TW
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 00:51:17 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 00:51:17 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 00:51:17 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... (Due to *sata* errors)
Date: Sat, 28 Sep 2013 23:51:04 +0100
Message-ID: <l27mgf$qmn$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <87F045E8-CBB5-4818-B60B-0325EC87A56D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
In-Reply-To: <87F045E8-CBB5-4818-B60B-0325EC87A56D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

All agreed. Further comment inlined:

(Should have mentioned more prominently that the hardware problem has
been worked-around by limiting the sata to 3Gbit/s on bootup.)


On 28/09/13 21:51, Chris Murphy wrote:
> 
> On Sep 28, 2013, at 1:26 PM, Martin <m_btrfs@ml1.co.uk> wrote:
> 
>> Writing data via rsync at the 6Gbit/s sata rate caused IO errors
>> for just THREE sectors...
>> 
>> Yet btrfsck bombs out with LOTs of errors…
> 
> Any fs will bomb out on write errors.

Indeed. However, are not the sata errors reported back to btrfs so that
it knows whatever parts haven't been updated?

Is there not a mechanism to then go "read-only"?

Also, should not the journal limit the damage?


>> How best to recover from this?
> 
> Why you're getting I/O errors at SATA 6Gbps link speed needs to be
> understood. Is it a bad cable? Bad SATA port? Drive or controller
> firmware bug? Or libata driver bug?

I systematically eliminated such as leads, PSU, and NCQ. Limiting libata
to only use 3Gbit/s is the one change that gives a consistent fix. The
HDD and motherboard both support 6Gbit/s, but hey-ho, that's an
experiment I can try again some other time when I have another HDD/SSD
to test in there.

In any case, for the existing HDD - motherboard combination, using sata2
rather than sata3 speeds shouldn't noticeably impact performance. (Other
than sata2 works reliably and so is infinitely better for this case!)


>> Lots of sata error noise omitted.
> 
> And entire dmesg might still be useful. I don't know if the list will
> handle the whole dmesg in one email, but it's worth a shot (reply to
> an email in the thread, don't change the subject).

I can email directly if of use/interest. Let me know offlist.


> do a smartctl -x on the drive, chances are it's recording PHY Event

(smartctl -x errors shown further down...)

Nothing untoward noticed:

# smartctl -a /dev/sdc

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD20EARX-00PASB0
Serial Number:    WD-...
LU WWN Device Id: ...
Firmware Version: 51.0AB51
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Sep 28 23:35:57 2013 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

[...]

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always
      -       9
  3 Spin_Up_Time            0x0027   253   159   021    Pre-fail  Always
      -       1983
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
      -       55
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always
      -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always
      -       800
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always
      -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
      -       53
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       31
193 Load_Cycle_Count        0x0032   199   199   000    Old_age   Always
      -       3115
194 Temperature_Celsius     0x0022   118   110   000    Old_age   Always
      -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0


# smartctl -x /dev/sdc

... also shows the errors it saw:

(Just the last 4 copied which look timed for when the HDD was last
exposed to 6Gbit/s sata)

Error 46 [21] occurred at disk power-on lifetime: 755 hours (31 days +
11 hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  01 -- 51 00 08 00 00 6c 1a 4b b0 e0 00  Error: AMNF 8 sectors at LBA =
0x6c1a4bb0 = 1813662640

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time
Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------
--------------------
  25 00 00 00 08 00 00 6c 1a 4b b0 e0 08     10:51:07.192  READ DMA EXT
  35 00 00 00 08 00 00 6c 1a 4b a8 e0 08     10:51:07.192  WRITE DMA EXT
  25 00 00 00 08 00 00 6c 1a 4b a8 e0 08     10:51:07.192  READ DMA EXT
  35 00 00 00 08 00 00 6c 1a 4b a8 e0 08     10:51:07.192  WRITE DMA EXT
  25 00 00 00 08 00 00 6c 1a 4b a8 e0 08     10:51:07.157  READ DMA EXT

Error 45 [20] occurred at disk power-on lifetime: 755 hours (31 days +
11 hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  01 -- 51 04 00 00 00 6c 1a 4b b0 e0 00  Error: AMNF 1024 sectors at
LBA = 0x6c1a4bb0 = 1813662640

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time
Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------
--------------------
  25 00 00 04 00 00 00 6c 1a 48 00 e0 08     10:51:03.450  READ DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     10:51:03.449  SET FEATURES
[Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     10:51:03.449  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     10:51:03.446  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     10:51:03.446  SET FEATURES
[Set transfer mode]

Error 44 [19] occurred at disk power-on lifetime: 755 hours (31 days +
11 hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  01 -- 51 04 00 00 00 6c 1a 4b b0 e0 00  Error: AMNF 1024 sectors at
LBA = 0x6c1a4bb0 = 1813662640

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time
Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------
--------------------
  25 00 00 04 00 00 00 6c 1a 48 00 e0 08     10:51:00.453  READ DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     10:51:00.452  SET FEATURES
[Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     10:51:00.452  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     10:51:00.449  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     10:51:00.449  SET FEATURES
[Set transfer mode]

Error 43 [18] occurred at disk power-on lifetime: 755 hours (31 days +
11 hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  01 -- 51 04 00 00 00 6c 1a 4b b0 e0 00  Error: AMNF 1024 sectors at
LBA = 0x6c1a4bb0 = 1813662640

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time
Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------
--------------------
  25 00 00 04 00 00 00 6c 1a 48 00 e0 08     10:50:57.455  READ DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     10:50:57.455  SET FEATURES
[Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     10:50:57.455  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     10:50:57.452  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     10:50:57.452  SET FEATURES
[Set transfer mode]

Error 42 [17] occurred at disk power-on lifetime: 755 hours (31 days +
11 hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  01 -- 51 04 00 00 00 6c 1a 4b b0 e0 00  Error: AMNF 1024 sectors at
LBA = 0x6c1a4bb0 = 1813662640

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time
Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------
--------------------
  25 00 00 04 00 00 00 6c 1a 48 00 e0 08     10:50:54.459  READ DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     10:50:54.458  SET FEATURES
[Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     10:50:54.458  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     10:50:54.455  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     10:50:54.455  SET FEATURES
[Set transfer mode]







>> Running btrfsck twice gives the same result, giving a failure
>> with:
> 
> Well honestly at this point I expect file system corruption as it's
> entirely possible that before the hardware dropped the link speed
> down to SATA 3Gbps, there was corrupt data already sent to the drive
> and that's not something Btrfs can know about until trying to read
> the data back in. So *shrug* - I don't see Btrfs as a way to totally
> mitigate hardware problems. It's the same problem with bad RAM, and
> Btrfs doesn't like that either.

Indeed. Hence trapping 'unexpectedness' where reasonable to then go
read-only... (I guess a hard compromise though whilst still debugging
bugs 'unexpectedness'! But still good to have in mind. ;-) )


Regards,
Martin




