Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53971 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3AGRsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 12:48:25 -0500
Message-ID: <50EB0A65.4090009@petaramesh.org>
Date: Mon, 07 Jan 2013 18:48:21 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net>
In-Reply-To: <50E9D909.1020207@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 06/01/2013 21:05, Gene Czarcinski a écrit :
> I assume you have a "grub partition" (or its equivalent) with a
> grub.cfg file having menuentry definitions [pointing to the different
> grub.cfg file for each system ... that seems to work well (at least
> for me).  Currently, os-prober does not support btrfs. 

I don't have any specific "grub" partition, every Linux install has its
own grub install in its own /boot BTRFS subvolume.

But I of course have only one grub actually installed in the disk MBR,
the one that corresponds to the distro I use most (and for which I redid
« grub-install /dev/sda » last).

As this grub doesn't auto-detect the other distros, I simply chain from
there the other distro's grub.cfg, by having crafted once for all a :


"/etc/grub.d/40_custom" that contains, i.e. :


#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply
type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.

menuentry "DebMint Loader (Chained)" {
    configfile (hd0,2)/LMDE/@boot/grub/grub.cfg
}

menuentry "Mint 13 Loader (Chained)" {
    configfile (hd0,2)/MINT/@boot/grub/grub.cfg
}

menuentry "Bodhi Loader (Chained)" {
    configfile (hd0,2)/BODHI/@boot/grub/grub.cfg
}


That's all folks ;-))

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

