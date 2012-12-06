Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:60523 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424741Ab2LFThu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 14:37:50 -0500
Date: Thu, 6 Dec 2012 20:37:48 +0100
From: Sander <sander@humilis.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, sander@humilis.net,
        Sylvain Alain <d2racing911@gmail.com>
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Message-ID: <20121206193748.GA25875@panda>
Reply-To: sander@humilis.net
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
 <20121206125908.GA31070@panda>
 <201212061952.46519.Martin@lichtvoll.de>
 <201212061955.11919.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201212061955.11919.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald wrote (ao):
> Am Donnerstag, 6. Dezember 2012 schrieb Martin Steigerwald:
> > Am Donnerstag, 6. Dezember 2012 schrieb Sander:
> > > Sylvain Alain wrote (ao):
> > > > Hi, right now I own this SSD :
> > > > 
> > > > Intel SSD 520 Series MLC 120 Gigs
> > > 
> > > > Also, this is my /etc/fstab
> > > > /dev/sda3      /boot            ext2       noauto,noatime,defaults
> > > > /dev/sda1      /boot/efi        vfat        noauto,defaults
> > > > /dev/sda4      /                  btrfs
> > > 
> > > SSDs are sensitive to partitioning. Easiest is not to partition at all.
> > 
> > Huh? How so?
> > 
> > My Intel SSD 320 is partitioned and uses LVM in the biggest partition
> > and is still just fine after 19 month. Media wearout indicator still at 100
> > (of 100).
> 
> Or did you indirectly refer to partition alignment?

Yes I did, I meant sensitive performance wise. I think your Intel 320
will survive just fine, but partition missalignment gives the controller
quite a bit more work to do.

	Sander
