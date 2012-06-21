Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43599 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab2FULqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 07:46:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, kreijack@inwind.it
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
Date: Thu, 21 Jun 2012 13:46:40 +0200
Cc: "H. Peter Anvin" <hpa@zytor.com>, cwillu <cwillu@cwillu.com>,
        helmut@hullen.de
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE2455E.2090007@zytor.com> <4FE2B576.3030301@libero.it> (sfid-20120621_090410_016018_05466806)
In-Reply-To: <4FE2B576.3030301@libero.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206211346.40683.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 21. Juni 2012 schrieb Goffredo Baroncelli:
> > 
> >
> >> Now we have the possibility to move the kernel near the modules, and
> >> this could lead some interesting possibility: think about different
> >> linux installations, with an own kernel version and an own modules
> >> version; what are the reasons to put together under /boot different
> >> kernel which potential conflicting names ? de facto standard ?
> >> historical reasons ? Nothing wrong here; but also the idea to moving
> >> the kernel under /lib/modules is not so wrong.
> >
> > 
> >
> > No, it is completely, totally and very very seriously wrong.
> 
> When a bootloader (and the bioses) will be able to address the whole
> diskS, this will change.. Not now

Why not the other way around? /boot/modules-3.4 or so.

But either way, these are different discussions. H. Peter´s question was, 
if I understood correctly, whether to use subvolid or path?

I tend to lean towards subvolid.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
