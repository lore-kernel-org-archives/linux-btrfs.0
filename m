From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 22:19:00 +0200
Message-ID: <C8TGo1T9CXB@helmut.hullen.de>
References: <20120508200228.GM8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120508200228.GM8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 08.05.12:

>>> Otherwise if you remove a disk from a raid0 (doesn't matter if you
>>> have 2 or 5 or x disks in the fs, btrfs should stripe above all
>>> disks) your fs should be broken.

>> Not with btrfs ... there it works even with
>>
>>   mkfs.btrfs -m raid1 -d raid0 ...

>    There is a big difference between "orderly and planned removal of
> a hard disk", and "disk goes away with no warning".

And I know the difference ...

When I first called for help I searched the failure in another place  
than in "disk is dead".

> This is essentially the difference you've been talking about at cross-
> purposes all day.

What I still hope (may be it's impossible): when 1 disk/partition fails,  
then the contents of the other disks is "somehow" restorable. And not  
irreproducable.

Viele Gruesse!
Helmut
