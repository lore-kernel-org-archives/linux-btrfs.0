Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34913 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdHAGnk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 02:43:40 -0400
Received: by mail-wr0-f175.google.com with SMTP id k71so2666539wrc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 23:43:39 -0700 (PDT)
Date: Tue, 1 Aug 2017 07:43:05 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Slow mounting raid1
Message-ID: <20170801064305.b6pgarooqu73gg3o@tiamat>
References: <20170731183047.x2p4vyqd2pvf7t4g@tiamat>
 <pan$1eb89$fa81c30b$fe750acd$9555f678@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$1eb89$fa81c30b$fe750acd$9555f678@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

Thanks for your answer
On 01/08/17, Duncan wrote:
> 
> If you're doing any snapshotting, you almost certainly want noatime, not 
> the default relatime.  Even without snapshotting and regardless of the 
> filesystem, tho on btrfs it's a bigger factor due to COW, noatime is a 
> recommended performance optimization.
> 
> The biggest caveat with that is if you're running something that actually 
> depends on atime.  Few if any modern applications depend on atime, with 
> mutt in some configurations being an older application that still does.  
> But AFAIK it only does in some configurations...
The array has no snapshots and my mutt resides on a diff SSD btrfs so I can
safely try this option.

> 
> Is there anything suspect in dmesg during the mount?  What does smartctl 
> say about the health of the devices?  (smartctl -AH at least, the selftest 
> data is unlikely to be useful unless you actually run the selftests.)
>
dmesg while mount says:
  [19823.896790] BTRFS info (device sde): use lzo compression
  [19823.896798] BTRFS info (device sde): disk space caching is enabled
  [19823.896800] BTRFS info (device sde): has skinny extents

Smartctl tests are scheduled to run all disks once every day (for short test) and every week for long tests.
smartctl output:
  # smartctl -AH /dev/sdd
  smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.11.12-1-ck] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
  
  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED
  
  SMART Attributes Data Structure revision number: 16
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
    1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always       -       0
    2 Throughput_Performance  0x0005   143   143   054    Pre-fail  Offline      -       67
    3 Spin_Up_Time            0x0007   124   124   024    Pre-fail  Always       -       185 (Average 185)
    4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       651
    5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
    7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
    8 Seek_Time_Performance   0x0005   110   110   020    Pre-fail  Offline      -       36
    9 Power_On_Hours          0x0012   100   100   000    Old_age   Always       -       4594
   10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
   12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       353
  192 Power-Off_Retract_Count 0x0032   094   094   000    Old_age   Always       -       7671
  193 Load_Cycle_Count        0x0012   094   094   000    Old_age   Always       -       7671
  194 Temperature_Celsius     0x0002   162   162   000    Old_age   Always       -       37 (Min/Max 17/62)
  196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
  197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
  198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
  199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0

  # smartctl -AH /dev/sde
  smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.11.12-1-ck] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
  
  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED
  
  SMART Attributes Data Structure revision number: 16
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
    1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always       -       0
    2 Throughput_Performance  0x0005   142   142   054    Pre-fail  Offline      -       69
    3 Spin_Up_Time            0x0007   123   123   024    Pre-fail  Always       -       186 (Average 187)
    4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       709
    5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
    7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
    8 Seek_Time_Performance   0x0005   113   113   020    Pre-fail  Offline      -       35
    9 Power_On_Hours          0x0012   100   100   000    Old_age   Always       -       4678
   10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
   12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       353
  192 Power-Off_Retract_Count 0x0032   093   093   000    Old_age   Always       -       8407
  193 Load_Cycle_Count        0x0012   093   093   000    Old_age   Always       -       8407
  194 Temperature_Celsius     0x0002   166   166   000    Old_age   Always       -       36 (Min/Max 17/64)
  196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
  197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
  198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
  199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0

> 1) Attempting to mount filesystems with many devices is of course 
> slower.  But two devices shouldn't be a problem.
> 
> 2) Sometimes a device might take awhile to "spin up" and initialize 
> itself.  Since you're still on spinning rust, are the devices perhaps 
> spinning down to save power, and the delay you see is them spinning back 
> up?
> 
Good idea but even when I do it like below it's still 6 seconds:
  # time umount /media/raid1 && time mount /media/raid1
  
  real    0m0.501s
  user    0m0.046s
  sys     0m0.011s

  real    0m5.540s
  user    0m0.943s
  sys     0m0.062s

> SSDs may have a similar, tho generally shorter and for different reasons, 
> delay.  SSDs often have a capacitor that charges up so they can finish a 
> write and avoid corrupting themselves in the event of an unexpected power 
> loss in the middle of a write.  A lower end device might allow the device 
> to appear ready while the capacitor is still charging to avoid long power-
> on response times, while higher end devices both tend to have higher 
> capacity capacitors, and don't signify ready until they are sufficiently 
> charged to avoid issues in "blink" situations where the power supply 
> comes back on but isn't immediately steady and might go out again right 
> away.
> 
> If a device takes too long and times out you'll see resets and the like 
> in dmesg, but that normally starts at ~30 seconds, not the 5 seconds you 
> mention.  Still, doesn't hurt to check.
Nothing on dmesg related as you can see.

> 
> 3) If the space cache is damaged the mount may take longer, but btrfs 
> will complain so you'll see it in dmesg.
> 
That was my idea and that's why I asked in ML.

I'll give 'noatime' a go and see if it's changes anything.

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

