From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 12:46:00 +0100
Message-ID: <BbJOcqST1uB@helmut.hullen.de>
References: <AANLkTiktNawUi95WjtceJ6RfW_FG1S=brWtMY9ut=pJ9@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktNawUi95WjtceJ6RfW_FG1S=brWtMY9ut=pJ9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, cwillu,

Du meintest am 05.12.10:

>> Maybe you're right. But if you're right then I have got the worst of
>> two worlds. I don't want neither RAID0 nor RAID1, I want a bundle of
>> different disks (at least partititions) which seem to be one large
>> disk. And I've hoped btrfs does this job.

> That's what raid0 is, and it's actually the best of both worlds:
> your metadata (which will be less than 5% of the data) is safely
> duplicated, such that you always have the checksums even with a disk
> gone, so you can verify that the data that you still have is good,
> while not wasting space duplicating every little bit of file data,
> which you may not care about that much, and which you have backed up
> anyway (right? right?).

Is it really RAID0, or is the btrfs way only similar to RAID0? I don't =
=20
like RAID0 because I never now on which physical disk the files are. =20
That makes changing disks very risky.

[...]

> This will almost certainly become much more tunable in the future,
> but not every feature that people want is done yet.  In fact, most of
> the really cool user-visible features aren't done yet.  Btrfs is
> still pretty young.

But I still hope btrfs is smarter than RAID0 or LVM ...

[...]

>> 1.5 TByte disk:
>> =A0 =A0 =A0 =A0btrfs device delete /dev/sdc3 /srv/MM
>> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>>
>> and then disconnect the 1.5 TByte disk (and hope that now the 2
>> TByte disk sets the limits).
>> No nice way ...

> No, just run the balance without adding another disk.  That will
> probably work (although it _will_ take a while on a large
> filesystem).

I'll try - perhaps it helps for some (few) weeks.

> I'm not sure that you understand how this all works though;  you
> might want to re-read the wiki articles (which I believe have been
> freshened up recently).

Beg your pardon - my major interest is that the system works. I'm glad =
=20
when I believe to understand what happens, but this feeling is an add-=20
on, no must.

>> Is there a way to avoid this (presumably) RAID mismatch?

> Yes, you can specify the raid level for each when you make the
> filesystem (and will eventually be able to do it with existing
> filesystems).  However, as I described above, you really want
> metadata to be duplicated.  Your problem is more of an unfortunate
> case of everything not being tuned quite right yet.

May be - I thought avoiding the "RAID0" definition was a good idea.

>> By the way: working with TByte disks includes (for home users) that
>> there's no backup ...

> Not sure why you'd think that.  It can't be the bandwidth, and if you
> can't afford a second drive, there's a good case to be made that you
> can't afford the data you can't afford to lose.

The data isn't really valuable - DVB videos. Most of them are copied to=
 =20
disks in a machine about 250 km away. And the TV stations repeat them o=
n =20
and on.

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
