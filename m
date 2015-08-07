Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:57293 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbHGFQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 01:16:13 -0400
Message-ID: <55C43F14.7080402@friedels.name>
Date: Fri, 07 Aug 2015 07:16:04 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Data single *and* raid?
References: <55BD277F.2040201@friedels.name> <20150801203258.GA14352@carfax.org.uk> <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com> <55C3AE34.8050804@friedels.name> <55C40957.9040209@cn.fujitsu.com>
In-Reply-To: <55C40957.9040209@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Quo,

thanks for your reply.

 >> But then:
>> root@homeserver:/mnt/__Complete_Disk# btrfs fi df /mnt/__Complete_Disk/
>> Data, RAID5: total=3.83TiB, used=3.78TiB
>> System, RAID5: total=32.00MiB, used=576.00KiB
>> Metadata, RAID5: total=6.46GiB, used=4.84GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> GlobalReserve is not a chunk type, it just means a range of metadata
> reserved for overcommiting.
> And it's always single.
>
> Personally, I don't think it should be output in "fi df" command, as
> it's in a higher level than chunk.
>
> At least for your case, nothing is needed to worry about.


But this seems to be a RAID5 now, right?
Well, that's what I want, but the command was:
btrfs balance start -dprofiles=single -mprofiles=raid1
/mnt/__Complete_Disk/

So, we would expect raid1 here, no?

Greetings,
Hendrik


>>
>>
>> On 01.08.2015 22:44, Chris Murphy wrote:
>>> On Sat, Aug 1, 2015 at 2:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>> On Sat, Aug 01, 2015 at 10:09:35PM +0200, Hendrik Friedel wrote:
>>>>> Hello,
>>>>>
>>>>> I converted an array to raid5 by
>>>>> btrfs device add /dev/sdd /mnt/new_storage
>>>>> btrfs device add /dev/sdc /mnt/new_storage
>>>>> btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
>>>>>
>>>>> The Balance went through. But now:
>>>>> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>>>>>          Total devices 3 FS bytes used 5.28TiB
>>>>>          devid    1 size 2.73TiB used 2.57TiB path /dev/sde
>>>>>          devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
>>>>>          devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
>>>>> btrfs-progs v4.1.1
>>>>>
>>>>> Already the 2.57TiB is a bit surprising:
>>>>> root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
>>>>> Data, single: total=2.55TiB, used=2.55TiB
>>>>> Data, RAID5: total=2.73TiB, used=2.72TiB
>>>>> System, RAID5: total=32.00MiB, used=736.00KiB
>>>>> Metadata, RAID1: total=6.00GiB, used=5.33GiB
>>>>> Metadata, RAID5: total=3.00GiB, used=2.99GiB
>>>>
>>>>     Looking at the btrfs fi show output, you've probably run out of
>>>> space during the conversion, probably due to an uneven distribution of
>>>> the original "single" chunks.
>>>>
>>>>     I think I would suggest balancing the single chunks, and trying the
>>>> conversion (of the unconverted parts) again:
>>>>
>>>> # btrfs balance start -dprofiles=single -mprofile=raid1
>>>> /mnt/new_storage/
>>>> # btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft
>>>> /mnt/new_storage/
>>>>
>>>
>>> Yep I bet that's it also. btrfs fi usage might be better at exposing
>>> this case.
>>>
>>>
>>
>>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Tel. 04203 8394854
Mobil 0178 1874363

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

