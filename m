From: Gustavo Alves <gjalves@gjalves.com.br>
Subject: Re: Problem with renaming devices
Date: Sat, 7 Nov 2009 19:44:51 -0200
Message-ID: <69e11d1f0911071344n7c059bd3o53896f4e8982e20b@mail.gmail.com>
References: <69e11d1f0911071341n4c0a845ds7bbf5d64b039d8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <69e11d1f0911071341n4c0a845ds7bbf5d64b039d8f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I found the same problem on 2.6.32-0.33.rc5.git1 with btrfs-progs
0.19. This problem is already fixed?

Thanks

----
Gustavo Junior Alves
Specchio Solu=E7=F5es em TI
http://specchio.inf.br
Tel: +55 19 9223-0500


> From: Chris Mason <chris.mason_=E4t_oracle.com>
> Date: Tue, 07 Apr 2009 07:35:56 -0400
>
> On Mon, 2009-04-06 at 18:41 +0100, Hugo Mills wrote:
> > There seems to be some issue over changing the names of the device
> > that a btrfs filesystem lives on:
> >
> > # lvcreate scratch -n fstest -L 2G
> > Logical volume "fstest" created
> > # mkfs -t btrfs /dev/scratch/fstest
> >
> > WARNING! - Btrfs v0.18-ge3b0f66 IS EXPERIMENTAL
> > WARNING! - see http://btrfs.wiki.kernel.org before using
> >
> > fs created label (null) on /dev/scratch/fs1
> > nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
> > Btrfs v0.18-ge3b0f66
> >
> > # mount /dev/scratch/fstest /mnt
> > # umount /mnt
> >
> > # lvrename scratch fstest derek
> > Renamed "fstest" to "derek" in volume group "scratch"
> > # mount /dev/scratch/derek /mnt
> > mount: /dev/mapper/scratch-derek: can't read superblock
> >
> > # lvrename scratch derek fstest
> > Renamed "derek" to "fstest" in volume group "scratch"
> > # mount /dev/scratch/fstest /mnt
> > [success]
> >
> > The rename works properly on a completely virgin filesystem, but
> > not on one that's been mounted and unmounted (as above).
>
> Whoops, we need to reset the pathname when a probe finds a given dev
> uuid on a given device. I'll patch it up when I get back next week.
>
> Thanks for this bug report.
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
