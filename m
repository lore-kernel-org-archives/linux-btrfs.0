Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37149 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbCIOyA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 10:54:00 -0400
Received: by widem10 with SMTP id em10so6607457wid.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Mar 2015 07:53:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H41AVqn9xK+Dwo+AjSYpjsEH9wWG+nbCxio6+oL_0TBfA@mail.gmail.com>
References: <CADurGxyF6g5Z+HNMry+q=b_oCKv1a6StDvp6pL20z=twK0BMHQ@mail.gmail.com>
	<CAL3q7H41AVqn9xK+Dwo+AjSYpjsEH9wWG+nbCxio6+oL_0TBfA@mail.gmail.com>
Date: Mon, 9 Mar 2015 15:53:59 +0100
Message-ID: <CADurGxw7ppm0_4beqBu=3JDJszg6_01kqdjma5OE3PbDk_roYQ@mail.gmail.com>
Subject: Re: Status: converting raid levels
From: Marcel Ritter <ritter.marcel@gmail.com>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I tried to revert the mentioned patch set (kernel 4.0.0-rc2).

Starting a new re-balance with this kernel, while running my I/O test
(big dd write) on the same btrfs volume (14 disks) resulted in "cpu stuck"
messages - system was unusable just a few seconds later.

With a plain 4.0.0-rc2 kernel the rebalance at least does finish
without crashing/hanging the system, but - on the downside - it
does not change the raid layout of the btrfs volume :-(

Any other ideas?

2015-03-07 10:39 GMT+01:00 Filipe David Manana <fdmanana@gmail.com>:
> On Fri, Mar 6, 2015 at 10:22 AM, Marcel Ritter <ritter.marcel@gmail.com> wrote:
>> Hi,
>>
>> please, can someone comment on the current status of raid level migration?
>> (kernel 4.0.0-rc2, btrfs-progs 3.19-rc2)
>>
>> I just started testing this feature, and it doesn't seem to work:
>>
>> Starting with Raid1:
>>
>> root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
>> Data, RAID1: total=3.00GiB, used=512.00KiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID1: total=8.00MiB, used=16.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=1.00GiB, used=112.00KiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>> Converting to Raid10:
>>
>> root@thunder[ ~/btrfs-progs ]# ./btrfs balance start -dconvert=raid10
>> -mconvert=raid10 /tmp/m/
>> Done, had to relocate 9 out of 9 chunks
>>
>> Still Raid1 ...:
>>
>> root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
>> Data, RAID1: total=35.00GiB, used=31.49GiB
>> System, RAID1: total=32.00MiB, used=16.00KiB
>> Metadata, RAID1: total=1.00GiB, used=33.86MiB
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>> I also tried conversion of raid6 - but it did not work either
>> (according to btrfs fi df output).
>>
>> Did I miss something, or is it a bug?
>
> Seems like the regression Holger found due to a patch added to 4.0:
>
> http://www.spinics.net/lists/linux-btrfs/msg42084.html
>
> (he mentions a 3.18.x kernel, but that's because he builds his own
> kernels with patches backported)
>
>>
>> Bye,
>>     Marcel
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
