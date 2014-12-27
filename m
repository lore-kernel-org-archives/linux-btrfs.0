Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43855 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0NQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 08:16:51 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 14:16:44 +0100
Message-ID: <9534911.qSQhRgc3Jg@merkaba>
In-Reply-To: <549E9D98.7010102@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <3538352.CI4nobbHtu@merkaba> <549E9D98.7010102@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 03:52:56 schrieb Robert White:
> > My theory from watching the Windows XP defragmentation case is this:
> > 
> > - For writing into the file BTRFS needs to actually allocate and use free
> > space in the current tree allocation, or, as we seem to misunderstood
> > from the words we use, it needs to fit data in
> > 
> > Data, RAID1: total=144.98GiB, used=140.94GiB
> > 
> > between 144,98 GiB and 140,94 GiB given that total space of this tree, or
> > if its not a tree, but the chunks in that the tree manages, in these
> > chunks can *not* be extended anymore.
> 
> If your file was actually COW (and you have _not_ been taking snapshots) 
> then there is no extenting to be had. But if you are using snapper 
> (which I believe you mentioned previously) then the snapshots cause a 
> write boundary and a layer of copying. Frequently taking snapshots of a 
> COW file is self defeating. If you are going to take snapshots then you 
> might as well turn copy on write back on and, for the love of pete, stop 
> defragging things.

I don´t use any snapshots on the filesystems. None, zero, zilch, nada.

And as I understand it copy on write means: It has to write the new write 
requests to somewhere else. For this it needs to allocate space. Either 
withing existing chunks or in a newly allocated one.

So for COW when writing to a file it will always need to allocate new space 
(although it can forget about the old space afterwards unless there isn´t a 
snapshot holding it)

Anyway, I got it reproduced. And am about to write a lengthy mail about.

It can easily be reproduced without even using Virtualbox, just by a nice 
simple fio job.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
