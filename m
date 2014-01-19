Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42221 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaASSvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 13:51:39 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Sir Civit <sircivit@yahoo.com>
Subject: Re: btrfs-convert destroyed my system
Date: Sun, 19 Jan 2014 19:51:37 +0100
Message-ID: <4701079.A6ieFUm802@merkaba>
In-Reply-To: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com>
References: <1390015849.15401.YahooMailNeo@web122606.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 17. Januar 2014, 19:30:49 schrieben Sie:
> To start off, I have an encrypted LVM setup with a root logical volume and a
> home logical volume. Today decided to upgrade my home LV to btrfs for
> compression. I installed btrfs-progs, unmounted /home, and ran
> btrfs-convert /dev/MyVolumeGroup/home
> and it completed with no errors reported. I rebooted my system, and I got a
> "Welcome to emergency mode!" message. I rebooted into a live CD and found

Unless you changes fstab, I´d not be that surprised about this.

> that all of my logical volumes were showing up, but almost all of them
> showed status "NOT available". I ran vgck and lvck, both of which found no
> errors. I ran lvscan and still /dev/MyVolumeGroup/ (and
> /dev/mapper/MyVolumeGroup-*) contains only one of the LVs.

>From the live CD you probably have to issue

vgchange -ay

to make all volumes available.

> It seems that btrfs-convert possibly overwrote the LVM metadata somehow, but
> I have no idea how since the argument was a logical volume. Even if I had
> accidentally typed /dev/MyVolumeGroup, I would think that btrfs-convert
> should have realized that it was not an ext2/3/4 filesystem.

As to what I know this can´t be possible. A logical volume is a block device 
which boundaries the kernel does guarantee. A userspace application should not 
be able to write beyond these boundaries. Now it might by that part of the 
conversion is happening in kernel, but I doubt it… and… I think even then the 
kernel guarentees it unless the part of the kernel that does the writing 
deliberately writes into completely different memory (then lots of bad things 
could probably happen).

> I tried mounting one of the "available" LVs, and got
> mount: /dev/MyVolumeGroup/root is write-protected, mounting read only.
> mount: special device /dev/MyVolumeGroup/root does not exist.

What does dmesg say to this?

> I've already
> started a fresh installation due to time constraints, but I'd like to
> find out why this happened and let everyone know about a potential bug.

Do you have a backup?

I strongly recommend making one directly before such a bold conversion.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
