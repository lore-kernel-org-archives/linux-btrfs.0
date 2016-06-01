Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33890 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbcFAWW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 18:22:59 -0400
Received: by mail-vk0-f48.google.com with SMTP id c189so47512711vkb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 15:22:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
	<CAEtw4r2hsCd1+bFNcXn_s5jj-8x6qer+x0gLx8wTgNi1=nAXhw@mail.gmail.com>
	<CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
Date: Thu, 2 Jun 2016 00:22:57 +0200
Message-ID: <CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
Subject: Re: "No space left on device" and balance doesn't work
From: Henk Slager <eye1tm@gmail.com>
To: MegaBrutal <megabrutal@gmail.com>
Cc: Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 1, 2016 at 11:06 PM, MegaBrutal <megabrutal@gmail.com> wrote:
> Hi Peter,
>
> I tried. I either get "Done, had to relocate 0 out of 33 chunks" or
> "ERROR: error during balancing '/': No space left on device", and
> nothing changes.
>
>
> 2016-06-01 22:29 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
>> try this:
>>
>> btrfs fi balance start -musage=0 /
>> btrfs fi balance start -dusage=0 /
>>
>> btrfs fi balance start -musage=1 /
>> btrfs fi balance start -dusage=1 /
>>
>> btrfs fi balance start -musage=5 /
>> btrfs fi balance start -musage=10 /
>> btrfs fi balance start -musage=20 /
>>
>>
>> btrfs fi balance start -dusage=5 /
>> btrfs fi balance start -dusage=10 /
>> btrfs fi balance start -dusage=20 /
>> ....
>>
>> 2016-06-01 20:30 GMT+02:00 MegaBrutal <megabrutal@gmail.com>:
>>> Hi all,
>>>
>>> I have a 20 GB file system and df says I have about 2,6 GB free space,
>>> yet I can't do anything on the file system because I get "No space
>>> left on device" errors. I read that balance may help to remedy the
>>> situation, but it actually doesn't.
>>>
>>>
>>> Some data about the FS:
>>>
>>>
>>> root@ReThinkCentre:~# df -h /
>>> Fájlrendszer                Méret Fogl. Szab. Fo.% Csatol. pont
>>> /dev/mapper/centrevg-rootlv   20G   18G  2,6G  88% /
>>>
>>> root@ReThinkCentre:~# btrfs fi show /
>>> Label: 'RootFS'  uuid: 3f002b8d-8a1f-41df-ad05-e3c91d7603fb
>>>         Total devices 1 FS bytes used 15.42GiB
>>>         devid    1 size 20.00GiB used 20.00GiB path /dev/mapper/centrevg-rootlv

The device is completely filled with chunks (size and used are the
same) and none of the chunks is empty so a balance won't work at all.

A way to get out of this situation is to add a temporary extra device
(e.g. 8GB USB stick or a loop device on some larger USB disk) to the
fs and then do the various balance operations. Removing as much as
possible snapshots will ease the balance mostly, depending how old the
snapshots are.
Once you see that the total amount of space used by chunks is (a few
GiB) less then 19GiB, you can remove the temporary extra device from
the fs again.

It then is still possible that you run into the same situation again;
This is a longterm bug/problem. A brand new kernel might help, with
ENOSPC patches included.

What is the kernel version used?
Is the fs on a mechanical disk or SSD?
What are the mount options?
How old is the fs?

You might want to run this phython script, so you get an idea of what
the chunks fill-level is
https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py

Also you could mount the fs with enospc_debug, and see what is reported in dmesg

>>> root@ReThinkCentre:~# btrfs fi df /
>>> Data, single: total=16.69GiB, used=14.14GiB
>>> System, DUP: total=32.00MiB, used=16.00KiB
>>> Metadata, DUP: total=1.62GiB, used=1.28GiB
>>> GlobalReserve, single: total=352.00MiB, used=0.00B
>>>
>>> root@ReThinkCentre:~# btrfs version
>>> btrfs-progs v4.4
>>>
>>>
>>> This happens when I try to balance:
>>>
>>> root@ReThinkCentre:~# btrfs fi balance start -dusage=66 /
>>> Done, had to relocate 0 out of 33 chunks
>>> root@ReThinkCentre:~# btrfs fi balance start -dusage=67 /
>>> ERROR: error during balancing '/': No space left on device
>>> There may be more info in syslog - try dmesg | tail
>>>
>>>
>>> "dmesg | tail" does not show anything related to this.
>>>
>>> It is important to note that the file system currently has 32
>>> snapshots of / at the moment, and snapshots taking up all the free
>>> space is a plausible explanation. Maybe deleting some of the oldest
>>> snapshots or just increasing the file system would help the situation.
>>> However, I'm still interested, if the file system is full, why does df
>>> show there is free space, and how could I show the situation without
>>> having the mentioned options? I actually have an alert set up which
>>> triggers when the FS usage reaches 90%, so then I know I have to
>>> delete some old snapshots. It worked so far, I cleaned the snapshots
>>> at 90%, FS usage fell back, everyone was happy. But now the alert
>>> didn't even trigger because the FS is at 88% usage, so it shouldn't be
>>> full yet.
>>>
>>>
>>> Best regards and kecske,
>>> MegaBrutal
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
