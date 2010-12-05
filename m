From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 19:26:00 +0100
Message-ID: <BbJPrrUD1uB@helmut.hullen.de>
References: <AANLkTim_vYJtsknDEYFkOXqZ9BtpReywpy2ajFq_8QR6@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim_vYJtsknDEYFkOXqZ9BtpReywpy2ajFq_8QR6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Evert,

Du meintest am 05.12.10:

>>>>>> =A0 =A0 =A0 devid =A0 =A02 size 1.35TB used 1.35TB path /dev/sdc=
3
>>>>>> =A0 =A0 =A0 devid =A0 =A01 size 1.81TB used 1.35TB path /dev/sdf=
2

[...]

> When I created a file system with
> mkfs.btrfs -d single /dev/sdb6 /dev/sdb7
> I was able to fill the resulting file system to 2.7Gb before it
> started throwing ENOSPACE this file system was quite a bit faster...

> So, by far the simplest solution would be to re-create your file
> system with "single" mode,

Can I add or delete hard disks/partitions to the two devices/partitions=
 =20
in your example?
I've studied the man page and the Wiki but didn't find any help.

And in my special case I have to add at least yearly new disks and from=
 =20
time to time remove the smallest disks from this bundle.

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
