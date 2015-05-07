Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59860 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbEGS5X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 14:57:23 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Paul Harvey <csirac2@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, russell@coker.com.au
Subject: Re: how to clone a btrfs filesystem
Date: Thu, 07 May 2015 20:57:21 +0200
Message-ID: <1540375.q8H4Tysm3j@merkaba>
In-Reply-To: <CAB3_QuKK44Vy8Suu9xFap9m8ef+pLvOwd+=1_y3XA5YZwXpY+A@mail.gmail.com>
References: <1429312124.8371.62.camel@scientia.net> <1816824.Xy3LLo99sJ@merkaba> <CAB3_QuKK44Vy8Suu9xFap9m8ef+pLvOwd+=1_y3XA5YZwXpY+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 7. Mai 2015, 15:14:11 schrieb Paul Harvey:
> Sorry I'm late to this conversation...
> 
> On 18 April 2015 at 18:10, Martin Steigerwald <martin@lichtvoll.de> wrote:
> > That said, I think it can be scripted. But I am not aware of anyone
> > having done this. I may be missing something, so maybe someone on the
> > list has a recommendation.
> 
> I thought I'd mention that I have developed a script [1] which is a
> part of snazzer [2] which at least transports all snapshots of all
> subvolumes on all mounted btrfs filesystems (or a subset thereof),
> using send -p where possible between two local filesystems or a remote
> host via ssh. That is, of course, assuming your snapshots are named
> and located according to the idiomatic convention expected by
> snazzer-receive [1] - which is unlikely, I admit. Everybody uses btrfs
> slightly differently.

Thank you for the hint to your tool, sounds interesting. I am not sure 
whether it would work with my setup of having snapshots in root subvol, but 
then setting another subvol as default to hide snapshots behind a mount of 
the root subvol like this:

LABEL=home              /home                   btrfs           
noatime,space_cache,compress=lzo        0       0

LABEL=home              /mnt/home-snaps          btrfs           
noatime,space_cache,compress=lzo,subvolid=5     0       0

I know that space_cache is not needed after first mount with that option 
(thats why I think it does not make much sense to have this as a mount 
option in the first place, but rather as a property of the filesystem).

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
