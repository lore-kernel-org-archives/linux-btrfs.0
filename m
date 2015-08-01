Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:36550 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbHAUox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 16:44:53 -0400
Received: by vkci6 with SMTP id i6so31933122vkc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 13:44:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150801203258.GA14352@carfax.org.uk>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
Date: Sat, 1 Aug 2015 14:44:52 -0600
Message-ID: <CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
Subject: Re: Data single *and* raid?
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 1, 2015 at 2:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Aug 01, 2015 at 10:09:35PM +0200, Hendrik Friedel wrote:
>> Hello,
>>
>> I converted an array to raid5 by
>> btrfs device add /dev/sdd /mnt/new_storage
>> btrfs device add /dev/sdc /mnt/new_storage
>> btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/new_storage/
>>
>> The Balance went through. But now:
>> Label: none  uuid: a8af3832-48c7-4568-861f-e80380dd7e0b
>>         Total devices 3 FS bytes used 5.28TiB
>>         devid    1 size 2.73TiB used 2.57TiB path /dev/sde
>>         devid    2 size 2.73TiB used 2.73TiB path /dev/sdc
>>         devid    3 size 2.73TiB used 2.73TiB path /dev/sdd
>> btrfs-progs v4.1.1
>>
>> Already the 2.57TiB is a bit surprising:
>> root@homeserver:/mnt# btrfs fi df /mnt/new_storage/
>> Data, single: total=2.55TiB, used=2.55TiB
>> Data, RAID5: total=2.73TiB, used=2.72TiB
>> System, RAID5: total=32.00MiB, used=736.00KiB
>> Metadata, RAID1: total=6.00GiB, used=5.33GiB
>> Metadata, RAID5: total=3.00GiB, used=2.99GiB
>
>    Looking at the btrfs fi show output, you've probably run out of
> space during the conversion, probably due to an uneven distribution of
> the original "single" chunks.
>
>    I think I would suggest balancing the single chunks, and trying the
> conversion (of the unconverted parts) again:
>
> # btrfs balance start -dprofiles=single -mprofile=raid1 /mnt/new_storage/
> # btrfs balance start -dconvert=raid5,soft -mconvert=raid5,soft /mnt/new_storage/
>

Yep I bet that's it also. btrfs fi usage might be better at exposing this case.


-- 
Chris Murphy
