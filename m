Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.univ-montp1.fr ([193.51.157.11]:45480 "EHLO
        mx1.univ-montp1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932944AbcILNJY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 09:09:24 -0400
From: Michel Bouissou <michel.bouissou@umontpellier.fr>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Date: Mon, 12 Sep 2016 14:59:12 +0200
Message-ID: <13278997.DcMfnd2pLu@vajra>
In-Reply-To: <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com>
References: <57D51BF9.2010907@online.no> <20160911130221.GE7138@carfax.org.uk> <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le lundi 12 septembre 2016, 08:20:20 Austin S. Hemmelgarn a écrit :
> FWIW, here's a list of what I personally consider stable (as in, I'm 
> willing to bet against reduced uptime to use this stuff on production 
> systems at work and personal systems at home):
> 1. Single device mode, including DUP data profiles on single device 
> without mixed-bg.
> 2. Multi-device … raid1, … with symmetrical 
> devices (all devices are the same size).
> 4. Small numbers (max double digit) of snapshots, taken at infrequent 
> intervals (no more than once an hour).  I use single snapshots regularly 
> to get stable images of the filesystem for backups, and I keep hourly 
> ones of my home directory for about 48 hours.
> 5. Subvolumes used to isolate parts of a filesystem from snapshots.  I 
> use this regularly to isolate areas of my filesystems from backups.
> 6. Non-incremental send/receive (no clone source, no parent's, no 
> deduplication).  I use this regularly for cloning virtual machines.
> 7. Checksumming and scrubs using any of the profiles I've listed above.
> 8. Defragmentation, including autodefrag.
> 9. All of the compat_features, including no-holes and skinny-metadata.

I would also agree that all this is perfectly stable in my own experience. (I 
removed above what I didn’t personnally use, or didn’t use long enough to 
vouch for it).

> Things I consider stable enough that I'm willing to use them on my 
> personal systems but not systems at work:
> 1. In-line data compression with compress=lzo.  I use this on my laptop 
> and home server system.  I've never had any issues with it myself, but I 
> know that other people have, and it does seem to make other things more 
> likely to have issues.

I never had problems with lzo compression, although I suspect that it (in 
conjuction with snapshots) adds much fragmentation that may relate to the 
extremely bad performance I get over time with mechanical HDs.

> 2. Batch deduplication.

Every time I tried to use any of the available dedup tools, either it 
immediately failed miserably, or it failed after eating all of my machine’s 
RAM. It didn’t eat my data, although.

My 2 cents…

-- 
Michel Bouissou <michel.bouissou@umontpellier.fr>
Ingénieur Systèmes
Université de Montpellier - DSIN

