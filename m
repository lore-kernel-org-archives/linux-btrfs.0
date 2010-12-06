From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 06 Dec 2010 18:13:00 +0100
Message-ID: <BbNS4yay1uB@helmut.hullen.de>
References: <20101206151804.GE4273@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206151804.GE4273@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.12.10:

>> How can I see that changing the kernel makes things better? It's
>> more and more difficult to externalize (?) btrfs directories to
>> other disks ...

>    Updating the kernel won't fix the problem I'm thinking of (sorry).
> It will, however, fix the bug that stops the btrfs tool from
> reporting what RAID levels you've got.

>    The problem I suspect you may have (because your symptoms seem to
> be the same as mine) is that there are some circumstances where the
> filesystem can change RAID levels pretty much arbitrarily. Running
> "btrfs fi df" with a kernel that reports RAID levels will show
> whether that's the case, as you'll have more than one RAID level
> listed.

Kernel 2.6.35.8:

# btrfs filesystem df /srv/MM
Data: total=2.39TB, used=2.37TB
Metadata: total=5.25GB, used=3.51GB
System: total=12.00MB, used=188.00KB

Kernel 2.6.37-rc4:

# btrfs filesystem df /srv/MM
Data, RAID0: total=2.39TB, used=2.37TB
System, RAID1: total=8.00MB, used=188.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=4.25GB, used=3.51GB
Metadata, DUP: total=1.00GB, used=2.33MB

Hope it helps!

Viele Gruesse!
Helmut
