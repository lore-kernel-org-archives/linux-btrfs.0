Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57491 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S933276AbdCaRof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:44:35 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cu0aq-0006lF-CC
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 19:44:12 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Confusion about snapshots containers
Date: Fri, 31 Mar 2017 19:40:29 +0200
Message-ID: <20170331194029.7acf831f@jupiter.sol.kaishome.de>
References: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 29 Mar 2017 16:27:30 -0500
schrieb Tim Cuthbertson <ratcheer@gmail.com>:

> I have recently switched from multiple partitions with multiple
> btrfs's to a flat layout. I will try to keep my question concise.
> 
> I am confused as to whether a snapshots container should be a normal
> directory or a mountable subvolume. I do not understand how it can be
> a normal directory while being at the same level as, for example, a
> rootfs subvolume. This is with the understanding that the rootfs is
> NOT at the btrfs top level.
> 
> Which should it be, a normal directory or a mountable subvolume
> directly under btrfs top level? If either way can work, what are the
> pros and cons of each?

I think there is no exact standard you could follow. Many distributions
seems to go for the standard to prepend subvolumes with "@" if they are
meant to be mounted. However, I'm not doing so.

Generally speaking, subvolumes organize your volume into logical
containers which make sense to be snapshotted on their own. Snapshots
won't propagate to sub-subvolumes, it is important to keep that in mind
while designing your idea of a structure.

I'm using it like this:

In subvol=0 I have the following subvolumes:

/* - contains distribution specific file systems
/home - contains home directories
/snapshots - contains snapshots I want to keep
/other
  - misc stuff, i.e. a dump of the subvol structure in a txt
  - a copy of my restore script
  - some other supporting docs for restore
  - this subvolume is kept in sync with my backup volume

This means: If I mount one of the rootfs, my home will not be part of
this mount automatically because that subvolume is out of scope of the
rootfs.

Now I have the following subvolumes below these:

/gentoo/rootfs - rootfs of my main distribution
  Note 1: Everything below (except subvolumes) should be maintained
          by the package manager.
  Note 2: currently I installed no other distributions
  Note 3: I could have called it main-system-rootfs

/gentoo/usr
  - actually not a subvolume but a directory for volumes shareable with
    other distribution instances

/gentoo/usr/portage - portage, shareable by other gentoo instances
/gentoo/usr/src - the gentoo linux kernel sources, shareable

The following are put below /gentoo/rootfs so they not need to be
mounted separately:

/gentoo/rootfs/var/log
  - log volume because I don't want it to be snapshotted
/gentoo/rootfs/var/tmp
  - tmp volume because it makes no sense to be snapshotted
/gentoo/rootfs/var/lib/machines
  - subvolume for keeping nspawn containers
/gentoo/rootfs/var/lib/machines/*
  - different machines cloned from each other
/gentoo/rootfs/usr/local
  - non-package manager stuff

/home/myuser - my user home
/home/myuser/.VirtualBox
  - VirtualBox machines because I want them snapshotted separately

/etc/fstab now only mounts subvolumes outside of the scope
of /gentoo/rootfs:

LABEL=system /home        btrfs compress=lzo,subvol=home,noatime
LABEL=system /usr/portage btrfs noauto,compress=lzo,subvol=gentoo/usr/portage,noatime,x-systemd.automount
LABEL=system /usr/src     btrfs noauto,compress=lzo,subvol=gentoo/usr/src,noatime,x-systemd.automount

Additionally, I mount the subvol=0 for two special purposes:

LABEL=system /mnt/btrfs-pool btrfs noauto,compress=lzo,subvolid=0,x-systemd.automount,noatime

First: For managing all the subvolumes and have an untampered view
(without tmpfs or special purpose mounts) to the volumes.

Second: To take a clean backup of the whole system.

Now, I can give the bootloader subvol=gentoo/rootfs to select which
system to boot (or make it the default subvolume).

Maybe you get the idea and find that idea helpful.

PS: It can make sense to have var/lib/machines outside of the rootfs
scope if you want to share it with other distributions.

-- 
Regards,
Kai

Replies to list-only preferred.

