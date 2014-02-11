Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60700 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751582AbaBKSTz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:19:55 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAJbEPe67biUB001mvFZkdKOyTOrWesgsbr+W9uonE8aBoDO64A@mail.gmail.com>
Date: Tue, 11 Feb 2014 11:19:52 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4C14DE8A-B78F-4BC6-B29D-AA87B59052AA@colorremedies.com>
References: <20140209224055.3175e70f@system> <191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com> <20140211041527.57ef96c4@system> <0812CEB3-ACEC-4582-BD86-18B7F6A3F74D@colorremedies.com> <CAJbEPe67biUB001mvFZkdKOyTOrWesgsbr+W9uonE8aBoDO64A@mail.gmail.com>
To: Saint Germain <saintger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 11, 2014, at 10:36 AM, Saint Germain <saintger@gmail.com> wrote:
>> 
>> grub-install <device> shouldn't work on UEFI because the only place grub-install installs is to the volume mounted at /boot/efi. And also grub-install /dev/sdb implies installing grub to a disk boot sector, which also isn't applicable to UEFI.
>> 
> 
> I am still not up to date on UEFI partition and so.
> But I have read these pages:
> http://tanguy.ortolo.eu/blog/article51/debian-efi
> http://forums.debian.net/viewtopic.php?f=16&t=81120
> And apparently is grub-install <device> is the correct command (but
> you have to copy file in addition).
> It is maybe because they use a special package grub-efi-amd64, which
> replace the grub-install.
> It is quite difficult to find reliable info on the topic…

grub-install <device> probably works insofar as <device> is being ignored. I bet you get the same results no matter what device you choose, but maybe I'm mistaken and they have some way to write to an unmounted ESP which seems like not such a great idea.


Chris Murphy

