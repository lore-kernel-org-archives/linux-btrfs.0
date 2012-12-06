Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57982 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946805Ab2LFSws (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 13:52:48 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, sander@humilis.net
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Date: Thu, 6 Dec 2012 19:52:46 +0100
Cc: Sylvain Alain <d2racing911@gmail.com>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com> <CACR_K2sPZMoqr6hO-xzWFiQ95dsi_0=3kWyi+zmY3qKHP0x1NA@mail.gmail.com> <20121206125908.GA31070@panda> (sfid-20121206_140135_041351_D66DE731)
In-Reply-To: <20121206125908.GA31070@panda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212061952.46519.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 6. Dezember 2012 schrieb Sander:
> Sylvain Alain wrote (ao):
> > Hi, right now I own this SSD :
> > 
> > Intel SSD 520 Series MLC 120 Gigs
> 
> > Also, this is my /etc/fstab
> > /dev/sda3      /boot            ext2       noauto,noatime,defaults
> > /dev/sda1      /boot/efi        vfat        noauto,defaults
> > /dev/sda4      /                  btrfs
> 
> SSDs are sensitive to partitioning. Easiest is not to partition at all.

Huh? How so?

My Intel SSD 320 is partitioned and uses LVM in the biggest partition
and is still just fine after 19 month. Media wearout indicator still at 100
(of 100).

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
