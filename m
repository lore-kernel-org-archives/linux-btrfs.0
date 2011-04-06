From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: 06 Apr 2011 08:57:00 +0200
Message-ID: <BjKsshqy1uB@helmut.hullen.de>
References: <chaz20110328131748.GA18131@seebyte.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110328131748.GA18131@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stephane,

Du meintest am 28.03.11:

> I then did a btrfs fi balance again and let it run through. However
> here is what I get:

> $ df -h /mnt
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sdb              8.2T  3.5T  3.2T  53% /mnt

> Only 3.2T left. How would I reclaim the missing space?

> $ sudo btrfs fi show
> Label: none  uuid: ...
>         Total devices 3 FS bytes used 3.43TB
>         devid    4 size 2.73TB used 1.17TB path /dev/sdc
>         devid    3 size 2.73TB used 1.17TB path /dev/sdb
>         devid    2 size 2.70TB used 1.14TB path /dev/sda4
> $ sudo btrfs fi df /mnt
> Data, RAID0: total=3.41TB, used=3.41TB
> System, RAID1: total=16.00MB, used=232.00KB
> Metadata, RAID1: total=35.25GB, used=20.55GB

> So that kind of worked but that is of little use to me as 2TB
> kind of disappeared under my feet in the process.

It may not please you - I've seen this nasty effect too. Reproducable.

I presume that "balance" eats disk space.

But "balance" seems to be necessary if I want to delete a device, and  
deleting a device is one of the features I'd like to use with btrfs  
(adding a new bigger device, then deleting an old smaller device).

Viele Gruesse!
Helmut
