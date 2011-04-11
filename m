From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: 11 Apr 2011 11:06:00 +0200
Message-ID: <BjeBqvFy1uB@helmut.hullen.de>
References: <chaz20110411072946.GA5587@seebyte.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110411072946.GA5587@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stephane,

Du meintest am 11.04.11:

> What's the implication of having disks of differing sizes? Does
> that mean that the extra space on larger disks is lost?

Seems to work.
I've tried:

/dev/sda   140 GByte
/dev/sdb   140 GByte
/dev/sdc    70 GByte

    mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdc1

mounted, more than 140 GByte free

Filled with more than 140 GByte (/dev/sdc1 was full to the brim)

    btrfs device add /dev/sda1 ...
    btrfs filesystem balance ...

Needed many hours, but then more than 210 GByte were usable.

Filled up to about 220 GByte; /dev/sdc1 was again full to the brim

    btrfs device delete /dev/sdc1
    umount
    mount

All looks as expected, only the 2 bigger devices are seen, and they  
contain the expected files.

And that looks good: my major interest in btrfs is working in that way -  
adding a bigger device, deleting a smaller device.

Kernel 2.6.38.1
btrfs from november 2010


Only the values shown with "df" and "btrfs filesystem df" need getting  
used to; maybe "available" has to be seen as "at least available".

Viele Gruesse!
Helmut
