From: cwillu <cwillu@cwillu.com>
Subject: Re: 800 GByte free, but "no space left"
Date: Sun, 5 Dec 2010 04:36:29 -0600
Message-ID: <AANLkTiktNawUi95WjtceJ6RfW_FG1S=brWtMY9ut=pJ9@mail.gmail.com>
References: <AANLkTimza7z64TB43BkFoVgtf2SNkks_6dfy+iXafqHf@mail.gmail.com>
	<BbJON$Fi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJON$Fi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 5, 2010 at 3:51 AM, Helmut Hullen <Hullen@t-online.de> wrot=
e:
> Hallo, cwillu,
>
> Du meintest am 05.12.10:
>
>>>> I am not an expert on this by a long shot, but it looks like you
>>>> added these two disks in raid0.
>
>>> I won't hope that this error is related to RAID0, I haven't
>>> installed (as far as I know) RAID0.
>>>
>>> My installation way:
>>>
>>> (2-TByte-Disk)
>>>
>>> =A0 =A0 =A0 =A0mkfs.btrfs /dev/sdf2
>>> =A0 =A0 =A0 =A0mount /dev/sdf2 /srv/MM
>>>
>>> (1.5-TByte-Disk)
>>> =A0 =A0 =A0 =A0btrfs device add /dev/sdc3 /srv/MM
>>> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>>>
>>> (and then waiting about 1 day ...)
>>> Especially: no RAID definition.
>
> [...]
>
>> If it's not a raid1, and there's multiple devices, it's a raid0 (and
>> so available space is the sum of all drives). =A0Your problem howeve=
r
>> is that metadata is raid1 by default (where everything is duplicated
>> on separate drives).
>
> Maybe you're right. But if you're right then I have got the worst of =
two
> worlds. I don't want neither RAID0 nor RAID1, I want a bundle of
> different disks (at least partititions) which seem to be one large di=
sk.
> And I've hoped btrfs does this job.

That's what raid0 is, and it's actually the best of both worlds:  your
metadata (which will be less than 5% of the data) is safely
duplicated, such that you always have the checksums even with a disk
gone, so you can verify that the data that you still have is good,
while not wasting space duplicating every little bit of file data,
which you may not care about that much, and which you have backed up
anyway (right? right?).

Larger files will be striped though, which is more incidental to how
data is allocated to block groups, but even so, it's generally not as
simple as saying "I don't want raid0, I just want a single big disk";
you have to figure out how to do that, and it'll generally result in
some raid0-like properties.

This will almost certainly become much more tunable in the future, but
not every feature that people want is done yet.  In fact, most of the
really cool user-visible features aren't done yet.  Btrfs is still
pretty young.

>> Adding another device will probably work around this, as will simply
>> running a balance operation (possibly, and you may need to free up
>> some space first anyway).
>
> That could lead to the following steps:
>
> Buy a 3 GByte disk
>
> =A0 =A0 =A0 =A0btrfs device add /dev/sdxy /srv/MM
> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>
> 1.5 TByte disk:
> =A0 =A0 =A0 =A0btrfs device delete /dev/sdc3 /srv/MM
> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>
> and then disconnect the 1.5 TByte disk (and hope that now the 2 TByte
> disk sets the limits).
> No nice way ...

No, just run the balance without adding another disk.  That will
probably work (although it _will_ take a while on a large filesystem).

I'm not sure that you understand how this all works though;  you might
want to re-read the wiki articles (which I believe have been freshened
up recently).

> Is there a way to avoid this (presumably) RAID mismatch?

Yes, you can specify the raid level for each when you make the
filesystem (and will eventually be able to do it with existing
filesystems).  However, as I described above, you really want metadata
to be duplicated.  Your problem is more of an unfortunate case of
everything not being tuned quite right yet.

> By the way: working with TByte disks includes (for home users) that
> there's no backup ...

Not sure why you'd think that.  It can't be the bandwidth, and if you
can't afford a second drive, there's a good case to be made that you
can't afford the data you can't afford to lose.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
