From: Evert Vorster <evorster@gmail.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 04:08:26 -0700
Message-ID: <AANLkTim9nJrfHeFqLp4d+KYs4jX3hQBV_JTuSBCzFmu3@mail.gmail.com>
References: <AANLkTimJ3dDdOFiQb8G=rrjCk2h68Y59oWdKEGH-80jN@mail.gmail.com>
	<BbJOCYcD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Helmut Hullen <Hullen@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJOCYcD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 5, 2010 at 12:48 AM, Helmut Hullen <Hullen@t-online.de> wro=
te:
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
>
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

>>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
>>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2

Here devid 2 is at 100%, and hence you are getting the no more space
left errors. So, the 300 TB is on the bigger disk, and not usable for
you right now.

I know of the disk mode you speak.. an old raid card of mine called it
"Just a bunch of disks" and it literally filled up the first disk
before carrying on to the second one until that was full under
windows... under UNIX it had the effect of just adding all the sectors
to each other, and stretching the file system over the disks in a
linear fashion. Most UNIX file systems writes files in the middle of
the largest contiguous free space, which meant that some files got
written on the first disk, and some on the second. As far as I know,
btrfs does not support this raid mode.

Another thing to keep in mind is that as far as I know you cannot
remove devid 1 from a btrfs volume. This is due to be fixed, but I
have no idea on the status of that.

Lastly, external USB disks are not too expensive, and together with
rsync makes a good off-line backup solution.

You could, if you really wanted to use all of two differently sized
disks in a btrfs, subdivide the disks in equal sized partitions, and
just put all of those partitions in a btrfs raid0...

ie:

Say you have a 1TB disk and 2TB disk... make 1TB partition on first
disk, and two 1TB partitions on second disk, then add all three
partitions to btrfs raid0 to make one volume of 3TB which will be
fully usable.

In your case:
1.81 Tb and 1.3 Tb your best use of space would probably be 0.6Tb
partitions.ie: 3x0.6Tb partitions on the first disk, and 2x0.6TB
partitions on the second. Then add all five partitions to a btrfs
raid. This would leave 0.1Tb of wasted space on the smaller device,
but at least you can use this partition separately.

Kind regards,
-Evert Vorster-
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
