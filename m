Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53136 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2GRVsP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 17:48:15 -0400
Date: Wed, 18 Jul 2012 14:48:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Message-ID: <20120718214814.GA3888@merlins.org>
References: <20120201175624.GE16796@shiny> <20120218160702.GB32373@merlins.org> <20120215165540.GC4763@merlins.org> <20120213001400.GD31989@merlins.org> <20120212223242.GA31989@merlins.org> <20120202032345.GB31903@merlins.org> <20120130003754.GD4380@merlins.org> <20120718181316.GD16899@merlins.org> <CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com> <CAFvQSYSAoL2=jmwbP1JE7rRg+LRbmpaO+sETmacVZomWFgtE-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFvQSYSAoL2=jmwbP1JE7rRg+LRbmpaO+sETmacVZomWFgtE-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2012 at 11:34:32PM +0200, Clemens Eisserer wrote:
> Hi,
> 
> > Not using TRIM on my Crucial RealSSD C300 256GB is most likely what caused
> > its garbage collection algorithm to fail (killing the drive and all its
> > data), and it was also causing BRTFS to hang badly when I was getting
> > within 10GB of the drive getting full.
> 
> Funny thing, as without TRIM the drive does not even know how "full" it is ;)

That's very true. To be honest, I don't fully know what happened to that
drive, but I actually heard the following from Crucial tech support twice:
"without TRIM, the drive needs to do garbage collection (correct), and it
only happens when the drive has been fully idle for about 15mn (oh boy,
why?). We recommend you let your drive sit at the bios or just with sata
power from time to time so that it can do garbage collection"

Then, there is also this gem:
http://forums.crucial.com/t5/Solid-State-Drives-SSD/Bios-is-not-recognize-crucail-m4-SSD-64GB/td-p/63835  
If the drive cannot garbage collect, it will shut off and appear dead.
When that happens, it needs to be powered on for 20mn with no data, turned
off, and on again for 20mn, and off.
Then, it's supposed to come back and be usable again.
(well, mine not so much. It came back eventually, but empty).

This is not a btrfs problem per se, but since we had a discussion on TRIM
and SSDs and what to do with dm-crypt, I thought I'd report back since it's
actually not a simple situation at all, and very SSD dependent afterall.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
