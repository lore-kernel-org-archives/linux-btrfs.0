Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49529 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140AbaCSWkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 18:40:36 -0400
Date: Wed, 19 Mar 2014 15:40:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
Message-ID: <20140319224034.GV18959@merlins.org>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org> <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com> <20140319154031.GP6143@merlins.org> <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EBE67530-BDC7-487C-826D-A0E65259BCBA@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 10:53:33AM -0600, Chris Murphy wrote:
> > Yes, although it's limited, you apparently only lose new data that was added
> > after you went into degraded mode and only if you add another drive where
> > you write more data.
> > In real life this shouldn't be too common, even if it is indeed a bug.
> 
> It's entirely plausible a drive power/data cable becomes lose, runs for hours degraded before the wayward device is reseated. It'll be common enough. It's definitely not OK for all of that data in the interim to vanish just because the volume has resumed from degraded to normal. Two states of data, normal vs degraded, is scary. It sounds like totally silent data loss. So yeah if it's reproducible it's worthy of a separate bug.

Actually what I did is more complex, I first added a drive to a degraded
array, and then re-added the drive that had been removed.
I don't know if re-adding the same drive that was removed would cause the
bug I saw.

For now, my array is back to actually trying to store the backup I had meant
for it, and the drives seems stable now that I fixed the power issue.

Does someone else want to try? :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
