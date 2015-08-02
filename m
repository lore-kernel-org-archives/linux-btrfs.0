Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:58521 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbbHBMys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 08:54:48 -0400
Message-ID: <55BE1310.20608@friedels.name>
Date: Sun, 02 Aug 2015 14:54:40 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
References: <55BD277F.2040201@friedels.name>	<20150801203258.GA14352@carfax.org.uk> <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
In-Reply-To: <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>>     Looking at the btrfs fi show output, you've probably run out of
>> space during the conversion, probably due to an uneven distribution of
>> the original "single" chunks.
>>
>>     I think I would suggest balancing the single chunks, and trying the
>> conversion (of the unconverted parts) again:
>>
>> # btrfs balance start -dprofiles=single -mprofile=raid1 /mnt/new_storage/
>> # btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft /mnt/new_storage/
>>
>
> Yep I bet that's it also. btrfs fi usage might be better at exposing this case.


Thanks for your hints.
The balance is running now for about 11h:
The status is a bit surprising to me:
0 out of about 2619 chunks balanced (4165 considered), 100% left

btrfs fi usage is also surprising:
Overall:
     Device size:                   8.19TiB
     Device allocated:              2.56TiB
     Device unallocated:            5.62TiB
     Device missing:                  0.00B
     Used:                          2.56TiB
     Free (estimated):             11.65TiB      (min: 2.81TiB)
     Data ratio:                       0.48
     Metadata ratio:                   1.33
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:2.55TiB, Used:2.55TiB
    /dev/sdc        1.60TiB
    /dev/sde      975.44GiB

Data,RAID5: Size:2.73TiB, Used:2.72TiB
    /dev/sdc        1.12TiB
    /dev/sdd        2.73TiB
    /dev/sde        1.61TiB

Metadata,RAID1: Size:6.00GiB, Used:5.33GiB
    /dev/sdc        5.00GiB
    /dev/sdd        1.00GiB
    /dev/sde        6.00GiB

Metadata,RAID5: Size:3.00GiB, Used:2.99GiB
    /dev/sdc        2.00GiB
    /dev/sdd        1.00GiB
    /dev/sde        3.00GiB

System,RAID5: Size:32.00MiB, Used:736.00KiB
    /dev/sdd       32.00MiB
    /dev/sde       32.00MiB

Unallocated:
    /dev/sdc        1.02MiB
    /dev/sdd        1.02MiB
    /dev/sde      164.59GiB


I hope, that is because Raid5 is not implemented yet?

Regards,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

