Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33271 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbKNPRz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 10:17:55 -0500
Received: by lbbkw15 with SMTP id kw15so68440071lbb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 07:17:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1447475897.1804.5.camel@gmail.com>
References: <1447475897.1804.5.camel@gmail.com>
Date: Sat, 14 Nov 2015 16:17:53 +0100
Message-ID: <CAPmG0jYFYdESQDM+ptrG-07NfQQOJ8N8swmmbdd_YnEvira3Rg@mail.gmail.com>
Subject: Re: Btrfs device initialisation is quite slow
From: Henk Slager <eye1tm@gmail.com>
To: Robbie Smith <zoqaeski@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It might be that your metadata is quite scattered and if the 320GB is
a HDD and not an SSD,  than this 11s is just  what it takes.
Scattered metadata might be caused by the autodefrag mount option I
think (and by fs getting older and changing often).

What is the output of   btrfs fi df /

You could run   btrfs balance start -musage=50 /   or a bit higher
number to compact the metadata

If this does not help, it could be there is some error in the
filesystem that makes btrfs take time to  figure out, but I done have
example or experience with  it. The only thing that could cause even
more excessive mount delays is when you have an interupted (full)
balance restarting, but that would not be the case every time you
boot.

Maybe a   btrfs scrub start /   could lead to identifying HDD sectors
going bad, but it is unlikely the case.







On Sat, Nov 14, 2015 at 5:38 AM, Robbie Smith <zoqaeski@gmail.com> wrote:
> Hey all
>
> I've been trying to figure out why my system (home desktop) is taking
> so long to boot. Systemd-analyze tells me that my root filesystem
> partition (which is btrfs) takes ~11 seconds to become active, and I'm
> curious as to why and whether or not I can optimise this.
>
> The primary disk has 4 partitions: a EFI/BIOS boot partion (for GRUB);
> a /boot partition (ext4); a swap partition; and the root partition. The
> disk itself is not particularly large (320 GB), and I'm using
> subvolumes to emulate partitions in btrfs. There are three top-level
> subvolumes, for /, /home, and /var, none of which have quotas, and I'm
> not at present doing snapshots because I backup every day to an
> external drive formatted with ext4.
>
> I've got a second 5 TB drive for multimedia that is also btrfs, but it
> only takes ~3 seconds to come online. I had been using a number of bind
> mounts from the multimedia drive to my home folder, so that $HOME/music
> and $HOME/videos point to the library, and replacing them with symlinks
> reduced the time by ~3 seconds, but it still doesn't account for why
> the root device takes so long.
>
> My fstab contains the following:
>
> # /dev/sdc4 LABEL=filesystem
> UUID=4ec80601-4799-4fa8-a711-0171c180f25b /
> btrfs rw,noatime,space_cache,autodefrag,subvol=rootvol 0 0
>
> # /dev/sdc4 LABEL=filesystem
> UUID=4ec80601-4799-4fa8-a711-0171c180f25b /home btrfs rw,noatime,space_cache,autodefrag,subvol=homevol 0 0
>
> # /dev/sdc4 LABEL=filesystem
> UUID=4ec80601-4799-4fa8-a711-0171c180f25b /var btrfs rw,noatime,space_cache,autodefrag,subvol=var 0 0
>
> # /dev/sdc2 LABEL=boot
> UUID=ca281471-0aac-4090-8660-33b8b9fee5a3 /boot ext4 rw,relatime,data=ordered 0 2
>
> # /dev/sdb1 LABEL=library
> UUID=97226949-50e0-4a78-899e-863f5b436bcc /mnt/library btrfs rw,noatime,space_cache,autodefrag 0 0
>
>
> Can anyone offer any insights or advice?
