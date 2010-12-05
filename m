From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 10:51:00 +0100
Message-ID: <BbJON$Fi1uB@helmut.hullen.de>
References: <AANLkTimza7z64TB43BkFoVgtf2SNkks_6dfy+iXafqHf@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimza7z64TB43BkFoVgtf2SNkks_6dfy+iXafqHf@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, cwillu,

Du meintest am 05.12.10:

>>> I am not an expert on this by a long shot, but it looks like you
>>> added these two disks in raid0.

>> I won't hope that this error is related to RAID0, I haven't
>> installed (as far as I know) RAID0.
>>
>> My installation way:
>>
>> (2-TByte-Disk)
>>
>> =A0 =A0 =A0 =A0mkfs.btrfs /dev/sdf2
>> =A0 =A0 =A0 =A0mount /dev/sdf2 /srv/MM
>>
>> (1.5-TByte-Disk)
>> =A0 =A0 =A0 =A0btrfs device add /dev/sdc3 /srv/MM
>> =A0 =A0 =A0 =A0btrfs filesystem balance /srv/MM
>>
>> (and then waiting about 1 day ...)
>> Especially: no RAID definition.

[...]

> If it's not a raid1, and there's multiple devices, it's a raid0 (and
> so available space is the sum of all drives).  Your problem however
> is that metadata is raid1 by default (where everything is duplicated
> on separate drives).

Maybe you're right. But if you're right then I have got the worst of tw=
o =20
worlds. I don't want neither RAID0 nor RAID1, I want a bundle of =20
different disks (at least partititions) which seem to be one large disk=
=2E =20
And I've hoped btrfs does this job.

> Adding another device will probably work around this, as will simply
> running a balance operation (possibly, and you may need to free up
> some space first anyway).

That could lead to the following steps:

Buy a 3 GByte disk =A0 =A0 =A0 =A0

        btrfs device add /dev/sdxy /srv/MM
   =A0 =A0 =A0btrfs filesystem balance /srv/MM

1.5 TByte disk:
        btrfs device delete /dev/sdc3 /srv/MM
   =A0 =A0 =A0btrfs filesystem balance /srv/MM

and then disconnect the 1.5 TByte disk (and hope that now the 2 TByte =20
disk sets the limits).
No nice way ...

--------------------------

Is there a way to avoid this (presumably) RAID mismatch?

By the way: working with TByte disks includes (for home users) that =20
there's no backup ...

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
