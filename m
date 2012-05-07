From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 18:36:00 +0200
Message-ID: <C8PCnlO9CXB@helmut.hullen.de>
References: <20120507140540.GF8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507140540.GF8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

>> It's dead - R.I.P.

>    Sorry to be the bearer of bad news. I don't think we can point the
> finger at btrfs here.

a) you know what to do with the bearer?
b) I like such errors - completely independent, but simultaneously.

>    It looks like you've lost most of your data -- losing a RAID-0
> stripe across the whole FS isn't likely to have left much of it
> intact.

I'm just going back to ext4 - then one broken disk doesn't disturb the  
contents of the other disks.

The data is not very valuable - DVB video mpegs. Most of the files are  
repeated on and on.

> If you've got the space (or the money to get it), mkfs.btrfs
> -m raid1 -d raid1 would have saved you here.

About 400 ... 500 Euro for backing up videos? Not necessary.

(No: I don't count the minutes and hours working with the system ...)

> [ Incidentally, thinking about it, the failure coming at a kernel
>    upgrade could well be down to the additional stress of the
>    power-down/reboot finally pushing a bad drive over the edge. ]

Just now it's again an "open system"; I had to wobble the cables too ...

Maybe the SATA-PCI-controller needs to be replaced too ...

Viele Gruesse!
Helmut
