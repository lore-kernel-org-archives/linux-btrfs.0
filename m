Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56524 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaCWRDW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 13:03:22 -0400
Date: Sun, 23 Mar 2014 10:03:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>
Message-ID: <20140323170314.GM12833@merlins.org>
References: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net>
 <20140323114712.GC25400@carfax.org.uk>
 <20140323162000.GK12833@merlins.org>
 <20140323162825.GF25400@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140323162825.GF25400@carfax.org.uk>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 23, 2014 at 04:28:25PM +0000, Hugo Mills wrote:
>    Before you do this, can you take a btrfs-image of your metadata,
> and add a report to bugzilla.kernel.org? You're not the only person
> who's had this problem recently, and I suspect there's something
> still lurking in there that needs attention.
> 
> > Hopefully this will be handled better in later code.
> 
>    With the info you can provide from a btrfs-image... let's hope so. :)

Mmmh, this may not be good :-/

legolas:/mnt/btrfs_pool2# btrfs-image -c 9 -t 6 /dev/mapper/disk2 /tmp/pool2.image
parent transid verify failed on 295965446144 wanted 51493 found 51495
parent transid verify failed on 295965446144 wanted 51493 found 51495
parent transid verify failed on 295965446144 wanted 51493 found 51495
parent transid verify failed on 295965446144 wanted 51493 found 51495
Ignoring transid failure
leaf parent key incorrect 295965446144
parent transid verify failed on 106205184 wanted 51468 found 51528
parent transid verify failed on 106205184 wanted 51468 found 51528
parent transid verify failed on 106205184 wanted 51468 found 51528
parent transid verify failed on 106205184 wanted 51468 found 51528
Ignoring transid failure
parent transid verify failed on 267162120192 wanted 51469 found 51528
parent transid verify failed on 267162120192 wanted 51469 found 51528
parent transid verify failed on 267162120192 wanted 51469 found 51528
parent transid verify failed on 267162120192 wanted 51469 found 51528
Ignoring transid failure
parent transid verify failed on 107315200 wanted 51468 found 51528
parent transid verify failed on 107315200 wanted 51468 found 51528
parent transid verify failed on 107315200 wanted 51468 found 51528
parent transid verify failed on 107315200 wanted 51468 found 51528
Ignoring transid failure
parent transid verify failed on 108081152 wanted 51468 found 51528
parent transid verify failed on 108081152 wanted 51468 found 51528
parent transid verify failed on 108081152 wanted 51468 found 51528
parent transid verify failed on 108081152 wanted 51468 found 51528
Ignoring transid failure
parent transid verify failed on 267162124288 wanted 51469 found 51528
parent transid verify failed on 267162124288 wanted 51469 found 51528
parent transid verify failed on 267162124288 wanted 51469 found 51528
parent transid verify failed on 267162124288 wanted 51469 found 51528
Ignoring transid failure
parent transid verify failed on 108351488 wanted 51468 found 51528
parent transid verify failed on 108351488 wanted 51468 found 51528
parent transid verify failed on 108351488 wanted 51468 found 51528
parent transid verify failed on 108351488 wanted 51468 found 51528
Ignoring transid failure
parent transid verify failed on 275021406208 wanted 51469 found 51529
parent transid verify failed on 275021406208 wanted 51469 found 51529
parent transid verify failed on 275021406208 wanted 51469 found 51529
parent transid verify failed on 275021406208 wanted 51469 found 51529
Ignoring transid failure
parent transid verify failed on 108466176 wanted 51468 found 51528
parent transid verify failed on 108466176 wanted 51468 found 51528
parent transid verify failed on 108466176 wanted 51468 found 51528
parent transid verify failed on 108466176 wanted 51468 found 51528
Ignoring transid failure
Segmentation fault

Is it a bug in the tool, or do I have real corruption?

Are there magic options I can give it to make it work around this?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
