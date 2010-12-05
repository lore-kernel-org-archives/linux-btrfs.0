From: cwillu <cwillu@cwillu.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 02:59:15 -0600
Message-ID: <AANLkTimza7z64TB43BkFoVgtf2SNkks_6dfy+iXafqHf@mail.gmail.com>
References: <AANLkTimJ3dDdOFiQb8G=rrjCk2h68Y59oWdKEGH-80jN@mail.gmail.com>
	<BbJOCYcD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Helmut Hullen <Hullen@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJOCYcD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 5, 2010 at 1:48 AM, Helmut Hullen <Hullen@t-online.de> wrot=
e:
> Hallo, Evert,
>
> Du meintest am 04.12.10 zum Thema Re: 800 GByte free, but "no space l=
eft":
>
>> On Sat, Dec 4, 2010 at 10:17 AM, Helmut Hullen <Hullen@t-online.de>
>> wrote:
>>> Hallo,
>>>
>>> I wrote am 02.12.10:
>>>
>>>> I use 2 disks (1.5 Tbyte and 2.0 TByte) under 1 LABEL (for my vide=
o
>>>> collection, nearly alle files have more than 1 GByte):
>>>
>>>> Label: MM2 =A0uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
>>>> =A0 =A0 =A0 Total devices 2 FS bytes used 2.38TB
>>>> =A0 =A0 =A0 devid =A0 =A02 size 1.35TB used 1.35TB path /dev/sdc3
>>>> =A0 =A0 =A0 devid =A0 =A01 size 1.81TB used 1.35TB path /dev/sdf2
>>>
>>>> ("btrfs-show" uses TiByte, it's 10% less than TByte)
>>>
>>>> Btrfs Btrfs v0.19
>>>
>>>> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available=
 Use% Mounted on
>>>> /dev/sdc3 =A0 =A0 =A0 =A0 =A0 =A03400799848 2559596740 841203108 =A0=
76% /srv/MM
>>>
>>>> --------------------------------
>>>
>>>> When I add some more videos, writing gets slower and slower, and
>>>> then the system refuses with "no space left ..."
>>>
>>> [...]
>
>>> No help?

The weekend isn't the best time for

>> I am not an expert on this by a long shot, but it looks like you
>> added these two disks in raid0.
>
>> This means that the total space cannot exceed the space of the
>> smallest disk.
>
>> ie: 1.35TB is the max you can use on any of your disks, as that is
>> the size of the smallest disk. In other words, once any of the disks
>> in a btrfs array runs out of space, the whole array is out of space.
>
>> I don't know if this is intended, but it certainly would appear so.
>
> I won't hope that this error is related to RAID0, I haven't installed
> (as far as I know) RAID0.
>
> My installation way:
>
> (2-TByte-Disk)
>
> =A0 =A0 =A0 =A0mkfs.btrfs /dev/sdf2
> =A0 =A0 =A0 =A0mount /dev/sdf2 /srv/MM
>
> (1.5-TByte-Disk)
> =A0 =A0 =A0 =A0btrfs device add /dev/sdc3 /srv/MM
> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>
> (and then waiting about 1 day ...)
> Especially: no RAID definition.
>
> If the smallest device defines the capacity then I should use 2*1.35
> TiByte, but my system tells "no space left" at about 2.4 TiByte - whe=
re
> are (at least) 300 GiByte hidden?
>
> ---------------------------------------
>
> Kernel 2.6.35.8
> btrfs-git from 20101117
>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

If it's not a raid1, and there's multiple devices, it's a raid0 (and
so available space is the sum of all drives).  Your problem however is
that metadata is raid1 by default (where everything is duplicated on
separate drives). One device has no space unallocated to any block
groups, and so if a particular metadata block group is full, there's
no place for that device's copy to end up, hence ENOSPC.

Adding another device will probably work around this, as will simply
running a balance operation (possibly, and you may need to free up
some space first anyway).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
