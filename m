Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36466 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbcGFRuJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 13:50:09 -0400
Received: by mail-wm0-f54.google.com with SMTP id f126so182659085wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 10:50:09 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
 <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
 <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com>
 <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com>
Date: Wed, 6 Jul 2016 19:50:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sudo mount -o ro /dev/sdc /shares
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


sudo mount -o ro,recovery /dev/sdc /shares
mount: wrong fs type, bad option, bad superblock on /dev/sdc,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


dmesg
http://sebsauvage.net/paste/?04d1162dc44d7e55#uY0kIaX66o7Kh+TZAGK2T+CKdRk2jorIWM3w5gfXp8I=

Do you want any other log to see?


For all 3 disks:
sudo smartctl -l scterc,70,70 /dev/sdx
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control set to:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

Thank you
Tomas

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Wednesday, July 06, 2016 6:08PM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

On Wed, Jul 6, 2016 at 2:07 AM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> Now with 3 disks:
> 
> sudo btrfs check /dev/sda
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> bytenr mismatch, want=7008807157760, have=65536
> Checking filesystem on /dev/sda
> UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
> checking extents
> parent transid verify failed on 7009468874752 wanted 70180 found 70133
> parent transid verify failed on 7009468874752 wanted 70180 found 70133
> checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
> checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
> bytenr mismatch, want=7009468874752, have=65536
> parent transid verify failed on 7008859045888 wanted 70175 found 70133
> parent transid verify failed on 7008859045888 wanted 70175 found 70133
> checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
> checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
> bytenr mismatch, want=7008859045888, have=65536
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
> parent transid verify failed on 7008899547136 wanted 70175 found 70133
> Ignoring transid failure
> leaf parent key incorrect 7008899547136
> bad block 7008899547136
> Errors found in extent allocation tree or chunk allocation
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> parent transid verify failed on 7009074167808 wanted 70175 found 70133
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
> bytenr mismatch, want=7009074167808, have=65536

Ok much better than before, these all seem sane with a limited number
of problems. Maybe --repair can fix it, but don't do that yet.




> sudo btrfs-debug-tree -d /dev/sdc
> http://sebsauvage.net/paste/?d690b2c9d130008d#cni3fnKUZ7Y/oaXm+nsOw0afoWDFXNl26eC+vbJmcRA=

OK good, so now it finds the chunk tree OK. This is good news. I would
try to mount it ro first, if you need to make or refresh a backup. So
in order:

mount -o ro
mount -o ro,recovery

If those don't work lets see what the user and kernel errors are.



> 
>>
> sudo btrfs-find-root /dev/sdc
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> Superblock thinks the generation is 70182
> Superblock thinks the level is 1
> Found tree root at 6062830010368 gen 70182 level 1
> Well block 6062434418688(gen: 70181 level: 1) seems good, but
> generation/level doesn't match, want gen: 70182 level: 1
> Well block 6062497202176(gen: 69186 level: 0) seems good, but
> generation/level doesn't match, want gen: 70182 level: 1
> Well block 6062470332416(gen: 69186 level: 0) seems good, but
> generation/level doesn't match, want gen: 70182 level: 1

This is also a good sign that you can probably get btrfs rescue to
work and point it to one of these older tree roots, if mount won't
work.


> 
>>
> sudo smartctl -l scterc /dev/sda
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
> 
>>
> sudo smartctl -l scterc /dev/sdb
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
> 
>>
> sudo smartctl -l scterc /dev/sdc
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled



There's good news and bad news. The good news is all the drives
support SCT ERC. The bad news is two of the drives have the wrong
setting for raid1+, including raid5. Issue:

smartctl -l scterc,70,70 /dev/sdX   #for each drive


This is not a persistent setting. The drive being powered off (maybe
even reset) will revert the setting to drive default. Some people use
a udev rule to set this during startup. I think it can also be done
with a systemd unit. You'd want to specify the drives by id, wwn if
available, so that it's always consistent across boots.

The point of this setting is to force the drive to give up on errors
quickly, allowing Btrfs in this case to be informed of the exact
problem (media error and what sector) so that Btrfs can reconstruct
the data from parity and then fix the bad sector(s). In your current
configuration the fixup can't happen, so problems start to accumulate.



> sudo smartcl -a /dev/sdx
> http://sebsauvage.net/paste/?aab1d282ceb1e1cf#auxFRkK5GCW8j1gR7mwgzR1z92Qn9oqtc6EEC2C6sEE=

sudo smartctl -a /dev/sda
 === START OF INFORMATION SECTION === Model Family: Seagate NAS HDD
Device Model: ST4000VN000-1H4168 Serial Number: Z302YVSZ
5 Reallocated_Sector_Ct 0x0033 089 089 010 Pre-fail Always - 14648

That's too many reallocated sectors. The good news is none are
pending. But for a NAS drive I think this is too high, get it replaced
under warranty. It certainly means that the unrecoverable read spec
for this particular drive is being busted so they should replace it
without question. It's possible this value is high by a factor of 8 if
they're counting 512 byte logical sectors, where the actual physical
sector is 4096 bytes. So it might not be as big of a problem as it
seems, but it's still busted the spec.

sudo smartctl -a /dev/sdb
=== START OF INFORMATION SECTION === Model Family: Seagate NAS HDD
Device Model: ST4000VN000-2AH166 Serial Number: WDH00SM8 LU WWN Device
Id: 5 000c50 09bbd3af2

 Error 1 occurred at disk power-on lifetime: 453 hours (18 days + 21
hours) When the command that caused the error occurred, the device was
active or idle. After command completion occurred, registers were: ER
ST SC SN CL CH DH -- -- -- -- -- -- -- 40 51 00 ff ff ff 0f Error: UNC
at LBA = 0x0fffffff = 268435455

This drive has recently experienced an explicit read error. That
probably was fixed by Btrfs 18 days ago, if you have logs going back
that long you'd likely see a fixup for this same sector LBA value.


/dev/sdc looks OK.

What's interesting looking at all smartctl outputs is that all three
are NAS models of Seagate but *two* of them do not have SCT ERC
enabled by default. That is very eyebrow raising as it relates to the
potential spread of misconfigurations of RAID.


Device Model: ST4000VN000-1H4168
Device Model: ST4000VN000-2AH166  ## this one has SCT ERC set to 70
deciseconds
Device Model: ST4000VN000-1H4168

Seems like a bad idea for a NAS drive to default to SCT ERC disabled,
I would expect the overwhelming use case for NAS drives will be raid1,
5, or 6, all of which need SCT ERC enabled. Very weird choice by
Seagate in my opinion.

Anyway, you should enable this on the other two drives. That way there
are fast error recoveries. If it turns out Btrfs can't reconstruct
something upon error, we can deal with that later. The main thing is
you want to get this raid5 as healthy as possible before the
previously failed device fails again, or gets replaced.



---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

