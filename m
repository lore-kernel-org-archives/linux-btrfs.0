Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:40899 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeIDGRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 02:17:09 -0400
Received: by mail-wm0-f49.google.com with SMTP id 207-v6so2571611wme.5
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2018 18:54:22 -0700 (PDT)
MIME-Version: 1.0
From: GWB <gwb@2realms.com>
Date: Mon, 3 Sep 2018 20:53:45 -0500
Message-ID: <CAP8EXU0u1sDa97jCeaZWL=+3sRRwigheEeeOL1aM57777XpRQw@mail.gmail.com>
Subject: Does ssd auto detected work for microSD cards?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Curious instance here, but perhaps this is the expected behaviour:

mount | grep btrfs
/dev/sdb3 on / type btrfs (rw,ssd,subvol=@)
/dev/sdb3 on /home type btrfs (rw,ssd,subvol=@home)
/dev/sde1 on /media/gwb09/btrfs-32G-MicroSDc type btrfs
(rw,nosuid,nodev,uhelper=udisks2)

This is on an Ubuntu 14 client.

/dev/sdb is indeed an ssd, a Samsung 850 EVO 500Gig, where Ubuntu runs
on btrfs root.   It appears btrfs did indeed auto detected an ssd
drive.   However:

/dev/sde is a micro SD card (32Gig Samsung) sitting in a USB 3 card
reader, inserted into a USB 3 card slot.  But ssh is not detected.

So is that the expected behavior?

If not, does it make a difference?

Would it be best to mount an sd card with ssd_spread?

The wiki suggests this, but I thought I would check:

https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)#MOUNT_OPTIONS

I think this is an older btrfs userland tools bundle:

btrfs --version
Btrfs v3.12

It's whatever is still in the Ubuntu 14 standard (universal?) repository.

Here's the tl/dr.  This is incidental info, and probably does not
affect the question above, or answer.

I use btrfs on Ubuntu root, and then zfs for home (lots of data, just
shy of 2 TB on this laptop).  I snapshot and send the zfs filesystems
onto a btrfs formatted sd card, and then use zfs receive for the
backup zpools:

sudo zfs send -D -v -i 20180830042620u zpb9/home2@20180904005531u >
zfs-send-zpb9-home2-20180904005531u

(on the sd card, copy to the back up zpools, and then:)

zfs receive -v zpf3/BackUpPoolHome < zfs-send-zpb9-home2-20180904005531u

No complaints at all about btrfs for the root file system, and
apt-btrfs-snapshot works great for rolling back from failed upgrades.
My servers are Solaris and Ubuntu, both of which support zfs, as long
as I don't upgrade beyond the "dreaded" point of no return for "open
source", zpool version 28 and zfs version 5.

When one server is upgraded to Ubuntu 18, I will try again to use
btrfs on the larger Toshiba Hard Drives (6TB and 8TB, either the x300
NAS or Desktop models).  I don't want to try that with Ubuntu 14 given
the older userland tools.

Many thanks.  Please point me to the correct mail list if this is not
the right one.

Yet another side note: both btrfs and zfs are now "housed" at Oracle
(and most of java, correct?).  Any chance of Solaris 11 getting btrfs
in the kernel?  I'm guessing not for Sparc, but it might help x86
Solaris users migrate to Oracle Linux.  At this point, I think Ubuntu
is the only distribution with a version of both btrfs and zfs in the
kernel.  But not Oracle.

Gordon Bynum
