Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51553 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaF1HiF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 03:38:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: russell@coker.com.au
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Date: Sat, 28 Jun 2014 09:38 +0200
Message-ID: <3863278.VRAxdhjX0B@merkaba>
In-Reply-To: <1403953457.BS00mAsj6N@xev>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com> <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net> <1403953457.BS00mAsj6N@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 28. Juni 2014, 16:28:23 schrieb Russell Coker:
> > So look for N-way-mirroring when you go RAID shopping, and no, btrfs does
> > not have it at this time, altho it is roadmapped for implementation after
> > completion of the raid5/6 code.
> >
> > 
> >
> > FWIW, N-way-mirroring is my #1 btrfs wish-list item too, not just for
> > device redundancy, but to take full advantage of btrfs data integrity
> > features, allowing to "scrub" a checksum-mismatch copy with the content
> > of a checksum-validated copy if available.  That's currently possible,
> > but due to the pair-mirroring-only restriction, there's only one
> > additional copy, and if it happens to be bad as well, there's no
> > possibility of a third copy to scrub from.  As it happens my personal
> > sweet-spot between cost/performance and reliability would be 3-way
> > mirroring, but once they code beyond N=2, N should go unlimited, so N=3,
> > N=4, N=50 if you have a way to hook them all up... should all be possible.
> 
> What I want is the ZFS copies= feature.

Something like this, even more flexible, was planned to be added. There were 
some discussion on how to specificy complex redundancy patterns totally flexibly 
exactly with how much redundancy, how much spares and so on.

I didn't read any of this since a long time. I wonder what happened to this 
idea.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
