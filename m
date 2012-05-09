From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: failed disk (was: kernel 3.3.4 damages filesystem (?))
Date: Wed, 9 May 2012 19:13:13 +0300
Message-ID: <20120509161312.GA2536@zambezi.lan>
References: <20120507180047.GG8938@carfax.org.uk>
 <C8XIuHi9CXB@helmut.hullen.de>
 <20120509143735.GQ8938@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509143735.GQ8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2012 at 03:37:35PM +0100, Hugo Mills wrote:
> On Wed, May 09, 2012 at 04:25:00PM +0200, Helmut Hullen wrote:
> > Du meintest am 07.05.12:
> > 
> > [...]
> > 
> > >> With a file system like ext2/3/4 I can work with several directories
> > >> which are mounted together, but (as said before) one broken disk
> > >> doesn't disturb the others.
> > 
> > >    mkfs.btrfs -m raid1 -d single should give you that.
> > 
> > Just a small bug, perhaps:
> > 
> > created a system with
> > 
> >         mkfs.btrfs -m raid1 -d single /dev/sdl1
> >         mount /dev/sdl1 /mnt/Scsi
> >         btrfs device add /dev/sdk1 /mnt/Scsi
> >         btrfs device add /dev/sdm1 /mnt/Scsi
> >         (filling with data)
> > 
> > and
> > 
> >         btrfs fi df /mnt/Scsi
> > 
> > now tells
> > 
> > Data, RAID0: total=183.18GB, used=76.60GB
> > Data: total=80.01GB, used=79.83GB
> > System, DUP: total=8.00MB, used=32.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, DUP: total=1.00GB, used=192.74MB
> > Metadata: total=8.00MB, used=0.00
> > 
> > --------------------------------------
> > 
> > "Data, RAID0" confuses me (not very much ...), and the system for  
> > metadata (RAID1) is not told.
> 
>    DUP is two copies of each block, but it allows the two copies to
> live on the same device. It's done this because you started with a
> single device, and you can't do RAID-1 on one device. The first bit of

What Hugo said.  Newer mkfs.btrfs will error out if you try to do this.

> metadata you write to it should automatically upgrade the DUP chunk to
> RAID-1.

We don't "upgrade" chunks in place, only during balance.

> 
>    As to the spurious "upgrade" of single to RAID-0, I thought Ilya
> had stopped it doing that. What kernel version are you running?

I did, but again, we were doing it only as part of balance, not as part
of normal operation.

Helmut, do you have any additional data points - the output of btrfs fi
df right after you created FS or somewhere in the middle of filling it ?

Also could you please paste the output of btrfs fi show and tell us what
kernel version you are running ?

Thanks,

		Ilya
