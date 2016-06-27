Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33967 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbcF0Xtb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 19:49:31 -0400
Received: by mail-oi0-f48.google.com with SMTP id s66so680190oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 16:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628010339.7fcddf5e@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <20160628010339.7fcddf5e@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 17:49:30 -0600
Message-ID: <CAJCQCtT6vgE7pggjPQNJEqc0vVb3F4Q3WBxmWF8cpSb7PGOQ0A@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 5:03 PM, Saint Germain <saintger@gmail.com> wrote:

>>
>
> Ok thanks I will begin to make an image with dd.
> Do you recommend to use sda or sdb ?

Well at the moment you're kinda stuck. I'd leave them together and
just get the data off the drive normally with cp -a (or just -r if you
don't care about permissions and other metadata like time stamps and
xattr) or rsync -a. Certainly the dying drive is being really pissy
but if you get a bad read off one drive *maybe* it can correct off the
other drive. But that's not possible if you pull one of those drives.

Also as for imaging the drive, you probably need to use ddrescue instead of dd.

Be warned that there's a gotcha where you can corrupt Btrfs volumes
where multiple instances of the same fs uuid and dev uuid appear at
the same time to the kernel. So once you've cloned in this manner,
don't mount the volume until you hide (as in remove) one of the
copies. See block level copies:
https://btrfs.wiki.kernel.org/index.php/Gotchas





> root@system:/# smartctl -x /dev/sda
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    0
>   2 Throughput_Performance  -OS--K   252   252   000    -    0
>   3 Spin_Up_Time            PO---K   091   090   025    -    2993
>   4 Start_Stop_Count        -O--CK   100   100   000    -    661
>   5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
>   7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
>   8 Seek_Time_Performance   --S--K   252   252   015    -    0
>   9 Power_On_Hours          -O--CK   100   100   000    -    1379
>  10 Spin_Retry_Count        -O--CK   252   252   051    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    349
> 191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
> 192 Power-Off_Retract_Count -O---K   252   252   000    -    0
> 194 Temperature_Celsius     -O----   060   047   000    -    40 (Min/Max 18/53)
> 195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
> 196 Reallocated_Event_Count -O--CK   252   252   000    -    0
> 197 Current_Pending_Sector  -O--CK   252   252   000    -    0
> 198 Offline_Uncorrectable   ----CK   252   252   000    -    0
> 199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    2
> 223 Load_Retry_Count        -O--CK   100   100   000    -    1
> 225 Load_Cycle_Count        -O--CK   099   099   000    -    10744
> 241 Total_LBAs_Written      -O--CK   095   094   000    -    7981553
> 242 Total_LBAs_Read         -O--CK   098   094   000    -    4015781

No current pending, reallocated, or uncorrected sectors. Interesting.
But this drive has piles of write errors. Why? Bad cable? That should
result in UDMA CRC errors, lots of them.

> SATA Phy Event Counters (GP Log 0x11)

No significant problems.



> root@system:/# smartctl -x /dev/sdb
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    28
>   2 Throughput_Performance  -OS--K   252   252   000    -    0
>   3 Spin_Up_Time            PO---K   092   083   025    -    2678
>   4 Start_Stop_Count        -O--CK   100   100   000    -    575
>   5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
>   7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
>   8 Seek_Time_Performance   --S--K   252   252   015    -    0
>   9 Power_On_Hours          -O--CK   100   100   000    -    1391
>  10 Spin_Retry_Count        -O--CK   252   252   051    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    371
> 191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
> 192 Power-Off_Retract_Count -O---K   252   252   000    -    0
> 194 Temperature_Celsius     -O----   061   047   000    -    39 (Min/Max 19/53)
> 195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
> 196 Reallocated_Event_Count -O--CK   252   252   000    -    0
> 197 Current_Pending_Sector  -O--CK   100   100   000    -    1
> 198 Offline_Uncorrectable   ----CK   252   252   000    -    0
> 199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    3
> 223 Load_Retry_Count        -O--CK   100   100   000    -    1
> 225 Load_Cycle_Count        -O--CK   099   099   000    -    13957
> 241 Total_LBAs_Written      -O--CK   096   094   000    -    6153920
> 242 Total_LBAs_Read         -O--CK   097   094   000    -    4873960

One pending sector. Enough for a dozen scary warnings or so, but not
enough to account for as many as you have. Pretty curious.


>
> Error 28 [3] occurred at disk power-on lifetime: 1390 hours (57 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

>   40 -- 41 05 80 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

>   40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

>   40 -- 41 00 08 00 00 0f 70 d8 08 40 00  Error: UNC at LBA = 0x0f70d808 = 259053576

[..snip extras of these..]

Consistent.



> SMART Extended Self-test Log Version: 1 (2 sectors)
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Short captive       Completed: read failure       90%      1384         259053576
> # 2  Short captive       Completed: read failure       90%      1384         259053576

Also consistent. For whatever reason it's not being overwritten... I
guess the copy on dev/sda is bad or unavailable.

>
> SATA Phy Event Counters (GP Log 0x11)

The vendor specific ones have a massive pile of noise in them compared
to the other drive. But inconclusive because they aren't defined.



-- 
Chris Murphy
