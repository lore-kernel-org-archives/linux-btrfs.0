Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58383 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaBGLfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 06:35:02 -0500
Received: by mail-qa0-f42.google.com with SMTP id k4so5048201qaq.1
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 03:35:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABgvyo-cZ1bw7Gyd5sUYK11mMUp3N2w6v=SNEdXBRYqbNSNNFQ@mail.gmail.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk>
 <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com> <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
 <6C293A14-9A38-4DAA-A720-1F77B9CB083D@colorremedies.com> <CABgvyo-cZ1bw7Gyd5sUYK11mMUp3N2w6v=SNEdXBRYqbNSNNFQ@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Fri, 7 Feb 2014 12:34:21 +0100
Message-ID: <CABgvyo8iS-8i-NKDUPX30B+Mk-B8-ZjLU7p_N7XefXtcSDvCFg@mail.gmail.com>
Subject: Re: lost with degraded RAID1
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there anything else I should do with this setup or may I nuke the
two partitions and reuse them?

2014-02-03 Johan Kröckel <johan.kroeckel@gmail.com>:
> State is: I wont use this filesystem again. I have a backup. So I am
> interested to give the necessary information for debuging it and
> afterwards format it and create a new one. I already did fscks and
> btrfschk --repair and pushed the output to txt-files but they are more
> than 4 mb in size.
>
> So I will post excerpts:
>
> ============file: btrfsck.out===========================
> Checking filesystem on /dev/mapper/bunkerA
> UUID: 7f954a85-7566-4251-832c-44f2d3de2211
> 42
> parent transid verify failed on 1887688011776 wanted 121037 found 88533
> parent transid verify failed on 1888518615040 wanted 121481 found 90267
> parent transid verify failed on 1681394102272 wanted 110919 found 91024
> parent transid verify failed on 1888522838016 wanted 121486 found 90270
> parent transid verify failed on 1888398331904 wanted 121062 found 89987
> leaf parent key incorrect 1887867330560
> bad block 1887867330560
> leaf parent key incorrect 1888120320000
> bad block 1888120320000
> leaf parent key incorrect 1888124637184
> bad block 1888124637184
> leaf parent key incorrect 1888131444736
> bad block 1888131444736
>
> [...and so on for 4MB]
>
> bad block 1888513552384
> leaf parent key incorrect 1888513642496
> bad block 1888513642496
> leaf parent key incorrect 1888513654784
> bad block 1888513654784
> leaf parent key incorrect 1888514023424
> bad block 1888514023424
> btrfsck: cmds-check.c:2212: check_owner_ref: Assertion `!(rec->is_root)' failed.
>
> ================file: smartctl-before-btrfschk-repair==============
> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.12-0.bpo.1-amd64] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail
> Always       -       172055696
>   3 Spin_Up_Time            0x0003   093   093   000    Pre-fail
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age
> Always       -       7
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x000f   069   060   030    Pre-fail
> Always       -       9085642
>   9 Power_On_Hours          0x0032   097   097   000    Old_age
> Always       -       2769
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age
> Always       -       7
> 184 End-to-End_Error        0x0032   100   100   099    Old_age
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age
> Always       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age
> Always       -       0
> 189 High_Fly_Writes         0x003a   083   083   000    Old_age
> Always       -       17
> 190 Airflow_Temperature_Cel 0x0022   077   071   045    Old_age
> Always       -       23 (Min/Max 22/23)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       5
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age
> Always       -       7
> 194 Temperature_Celsius     0x0022   023   040   000    Old_age
> Always       -       23 (0 20 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
>
> =================file:btrfsck-repair.out========================
> enabling repair mode
> Checking filesystem on /dev/mapper/bunkerA
> UUID: 7f954a85-7566-4251-832c-44f2d3de2211
> ify failed on 1887688011776 wanted 121037 found 88533
> parent transid verify failed on 1888518615040 wanted 121481 found 90267
> parent transid verify failed on 1681394102272 wanted 110919 found 91024
> parent transid verify failed on 1888522838016 wanted 121486 found 90270
> parent transid verify failed on 1888398331904 wanted 121062 found 89987
> leaf parent key incorrect 1887867330560
> bad block 1887867330560
>
> [...and so on for 4MB]
>
> bad block 1888513642496
> leaf parent key incorrect 1888513654784
> bad block 1888513654784
> leaf parent key incorrect 1888514023424
> bad block 1888514023424
> btrfsck: cmds-check.c:2212: check_owner_ref: Assertion `!(rec->is_root)' failed.
>
> ==============file:smartctl-after-btrfschk-repair==================
> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.12-0.bpo.1-amd64] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail
> Always       -       178377016
>   3 Spin_Up_Time            0x0003   093   093   000    Pre-fail
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age
> Always       -       7
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x000f   069   060   030    Pre-fail
> Always       -       9087571
>   9 Power_On_Hours          0x0032   097   097   000    Old_age
> Always       -       2769
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age
> Always       -       7
> 184 End-to-End_Error        0x0032   100   100   099    Old_age
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age
> Always       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age
> Always       -       0
> 189 High_Fly_Writes         0x003a   083   083   000    Old_age
> Always       -       17
> 190 Airflow_Temperature_Cel 0x0022   077   071   045    Old_age
> Always       -       23 (Min/Max 22/23)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> Always       -       5
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age
> Always       -       7
> 194 Temperature_Celsius     0x0022   023   040   000    Old_age
> Always       -       23 (0 20 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
>
> 2014-02-03 Chris Murphy <lists@colorremedies.com>:
>>
>> On Feb 3, 2014, at 1:55 PM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:
>>
>>> 2014-01-30 Chris Murphy <lists@colorremedies.com>:
>>>>
>>>> On Jan 30, 2014, at 10:58 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>>
>>>>> On Thu, Jan 30, 2014 at 10:33:21AM -0700, Chris Murphy wrote:
>>>>>> You're doing an online conversion of a degraded raid1 volume into single? Does anyone know if this is expected or intended to work?
>>>>>
>>>>>  I don't see why not. One suggested method of recovering RAID from a
>>>>> degraded situation is to rebalance over just the remaining devices
>>>>> (space permitting, of course).
>>>>
>>>> Right but that's not a conversion. That's a regular balance on a degraded mount, with multiple remaining devices: e.g. a 4 disk raid1, drive fails, mount -o degraded, delete missing, then balance will replicate any missing 2nd copies onto three drives.
>>>>
>>>> The bigger problem at the moment is that -o degraded isn't working for Johan. The too many missing devices message seems like a bug and with limited information it may even be whatever that bug is, that cause the conversion to fail. Some 11GB were converted prior to the failure.
>>> Which usefull information can provide. On the weekend I was at the
>>> server and found out, that the vanishing of the drive at reboot was
>>> strange behavior of the bios. So the drive is online again. but the
>>> filesystem is still showing strange behavior, but now I can mount it
>>> rw.
>>
>> I'd like to see btrfs fi df results for the volume. And new btrfs check. And then a backup if needed, and then a scrub to see if that fixes anything broken between them. I'm not sure what happens if a new generation object is broken and the old generation is OK, what scrub will do? Maybe it just reports it, I'm not sure. If you want you could do a btrfs scrub -r which is read only and just reports what the problems are.
>>
>> You also have an incomplete balance, right? So it's possible some things might not be fixable if the conversion to single was successful. You'll need to decide if you want to reconvert back to data/metadata raid1/raid from whatever you're at now.
>>
>>
>> Chris Murphy
