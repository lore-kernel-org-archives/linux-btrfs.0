Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58623 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946816Ab2LFSzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 13:55:13 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Date: Thu, 6 Dec 2012 19:55:11 +0100
Cc: sander@humilis.net, Sylvain Alain <d2racing911@gmail.com>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com> <20121206125908.GA31070@panda> <201212061952.46519.Martin@lichtvoll.de> (sfid-20121206_195408_174122_0A12B8B8)
In-Reply-To: <201212061952.46519.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212061955.11919.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 6. Dezember 2012 schrieb Martin Steigerwald:
> Am Donnerstag, 6. Dezember 2012 schrieb Sander:
> > Sylvain Alain wrote (ao):
> > > Hi, right now I own this SSD :
> > > 
> > > Intel SSD 520 Series MLC 120 Gigs
> > 
> > > Also, this is my /etc/fstab
> > > /dev/sda3      /boot            ext2       noauto,noatime,defaults
> > > /dev/sda1      /boot/efi        vfat        noauto,defaults
> > > /dev/sda4      /                  btrfs
> > 
> > SSDs are sensitive to partitioning. Easiest is not to partition at all.
> 
> Huh? How so?
> 
> My Intel SSD 320 is partitioned and uses LVM in the biggest partition
> and is still just fine after 19 month. Media wearout indicator still at 100
> (of 100).

Or did you indirectly refer to partition alignment?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
