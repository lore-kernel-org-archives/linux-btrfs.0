Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38737 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbeIIIGF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Sep 2018 04:06:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id w11-v6so18449642wrc.5
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Sep 2018 20:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAP8EXU0u1sDa97jCeaZWL=+3sRRwigheEeeOL1aM57777XpRQw@mail.gmail.com>
 <CAJCQCtR6tmRaYwipw9JEut9Nu=1754LYz1EBmSRH8Gu_1_JBGg@mail.gmail.com>
In-Reply-To: <CAJCQCtR6tmRaYwipw9JEut9Nu=1754LYz1EBmSRH8Gu_1_JBGg@mail.gmail.com>
From: GWB <gwb@2realms.com>
Date: Sat, 8 Sep 2018 22:17:25 -0500
Message-ID: <CAP8EXU1VhEJ7zDf-=abLoC0TfwCCES+5DTUwJfSo49JCZMdDCw@mail.gmail.com>
Subject: Re: Does ssd auto detected work for microSD cards?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Great, thank you.  That would make sense, but I might have to specify
something for the mmcblk devices.

Here is the terminal output when the MicroSD is inserted to the USB 3 holder:

$ mount | grep btrfs
$ /dev/sdb3 on / type btrfs (rw,ssd,subvol=@)
$ /dev/sdb3 on /home type btrfs (rw,ssd,subvol=@home)
$ /dev/sdd1 on /media/gwb09/btrfs-32G-MicroSDc type btrfs
(rw,nosuid,nodev,uhelper=udisks2)

$ cat /sys/block/sdd/queue/rotational
1

Now the same MicroSD in the SD slot on the computer:

$ mount | grep btrfs
$ /dev/sdb3 on / type btrfs (rw,ssd,subvol=@)
$ /dev/sdb3 on /home type btrfs (rw,ssd,subvol=@home)
$ /dev/mmcblk0p1 on /media/gwb09/btrfs-32G-MicroSDc type btrfs
(rw,nosuid,nodev,uhelper=udisks2)

$ cat /sys/block/mmcblk0/queue/rotational
0

So Ubuntu 14 knows the mmcblk is non-rotational.  It also looks as if
the block device has a partition table of some sort by the existence
of:

/sys/block/mmcblk0/mmcblk0p1

I will see what happens after I install Ubuntu 18.  I probably
specified the mount options for /dev/sdb in /etc/fstab by using a
UUID.  I'll probably tweak the ssd mounts, using ssd_spread, ssd, etc.
at some point.

I've been using nilfs2 for this, but it occurs to me that btrfs will
have more support on more platforms and on more OS's.  There's also a
mounting issue for nilfs2 in Ubuntu 14 which prevents the nilfs-clean
daemon from starting.  I will see if F2FS is in the kernel of the
other machines here.

No complaints here, just gratitude, for the money, time and effort on
the part of tech firms that support and develop btrfs.  I think Oracle
developed the first blueprints for btrfs, but I might be wrong.
Oracle also, of course, caught vast amounts of flak from some of the
open source zfs devs for changing the dev model after buying Sun.  But
I have no idea what parts of Sun would have survived without a buyer.

Gordon
On Mon, Sep 3, 2018 at 11:22 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mon, Sep 3, 2018 at 7:53 PM, GWB <gwb@2realms.com> wrote:
> > Curious instance here, but perhaps this is the expected behaviour:
> >
> > mount | grep btrfs
> > /dev/sdb3 on / type btrfs (rw,ssd,subvol=@)
> > /dev/sdb3 on /home type btrfs (rw,ssd,subvol=@home)
> > /dev/sde1 on /media/gwb09/btrfs-32G-MicroSDc type btrfs
> > (rw,nosuid,nodev,uhelper=udisks2)
> >
> > This is on an Ubuntu 14 client.
> >
> > /dev/sdb is indeed an ssd, a Samsung 850 EVO 500Gig, where Ubuntu runs
> > on btrfs root.   It appears btrfs did indeed auto detected an ssd
> > drive.   However:
> >
> > /dev/sde is a micro SD card (32Gig Samsung) sitting in a USB 3 card
> > reader, inserted into a USB 3 card slot.  But ssh is not detected.
> >
> > So is that the expected behavior?
>
> cat /sys/block/sde/queue/rotational
>
> That's what Btrfs uses for detection. I'm willing to bet the SD Card
> slot is not using the mmc driver, but instead USB and therefore always
> treated as a rotational device.
>
>
> > If not, does it make a difference?
> >
> > Would it be best to mount an sd card with ssd_spread?
>
> For the described use case, it probably doesn't make much of a
> difference. It sounds like these are fairly large contiguous files,
> ZFS send files.
>
> I think for both SDXC and eMMC, F2FS is probably more applicable
> overall than Btrfs due to its reduced wandering trees problem. But
> again for your use case it may not matter much.
>
>
>
> > Yet another side note: both btrfs and zfs are now "housed" at Oracle
> > (and most of java, correct?).
>
> Not really. The ZFS we care about now is OpenZFS, forked from Oracle's
> ZFS. And a bunch of people not related to Oracle do that work. And
> Btrfs has a wide assortment of developers: Facebook, SUSE, Fujitsu,
> Oracle, and more.
>
>
> --
> Chris Murphy
