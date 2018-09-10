Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57972 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727683AbeIJQIy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 12:08:54 -0400
Date: Mon, 10 Sep 2018 13:15:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: GWB <gwb@2realms.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Does ssd auto detected work for microSD cards?
Message-ID: <20180910111503.GQ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAP8EXU0u1sDa97jCeaZWL=+3sRRwigheEeeOL1aM57777XpRQw@mail.gmail.com>
 <CAJCQCtR6tmRaYwipw9JEut9Nu=1754LYz1EBmSRH8Gu_1_JBGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtR6tmRaYwipw9JEut9Nu=1754LYz1EBmSRH8Gu_1_JBGg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 10:22:42PM -0600, Chris Murphy wrote:
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

The correct rotational/non-rot status should be provided by the block
device driver. The btrfs kernel module or the mkfs utility will not try
to guess the status by the device name, this does not belong to that
layer.

So either the device driver is updated or an udev rule could fix that
too.
