Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39368 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab3EWUdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 16:33:40 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 10A719A067A
	for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 14:33:40 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <519E71E0.2060301@itwm.fraunhofer.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <knl3ke$n7t$1@ger.gmane.org>
 <20130523131118.4907.45217@localhost.localdomain>
 <519E1821.5070507@itwm.fraunhofer.de>
 <20130523133418.4907.21116@localhost.localdomain>
 <519E6F04.5000900@itwm.fraunhofer.de>
 <20130523193741.4907.41422@localhost.localdomain>
 <519E71E0.2060301@itwm.fraunhofer.de>
Message-ID: <20130523203337.4907.25234@localhost.localdomain>
Subject: Re: raid6: rmw writes all the time?
Date: Thu, 23 May 2013 16:33:37 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Bernd Schubert (2013-05-23 15:45:36)
> On 05/23/2013 09:37 PM, Chris Mason wrote:
> > Quoting Bernd Schubert (2013-05-23 15:33:24)
> >> Btw, any chance to generally use chunksize/chunklen instead of stripe,
> >> such as the md layer does it? IMHO it is less confusing to use
> >> n-datadisks * chunksize = stripesize.
> > 
> > Definitely, it will become much more configurable.
> 
> Actually I meant in the code. I'm going to write a patch during the weekend.

The btrfs raid code refers to stripes because a chunk is a very large
(~1GB) slice of a set of drives that we allocate into raid levels. 

We have full stripes and device stripes, I'm afraid there are so many
different terms in other projects that it is hard to pick something clear.

> 
> > 
> >>
> >>>
> >>> Using buffered writes makes it much more likely the VM will break up the
> >>> IOs as they go down.  The btrfs writepages code does try to do full
> >>> stripe IO, and it also caches stripes as the IO goes down.  But for
> >>> buffered IO it is surprisingly hard to get a 100% hit rate on full
> >>> stripe IO at larger stripe sizes.
> >>
> >> I have not found that part yet, somehow it looks like as if writepages
> >> would submit single pages to another layer. I'm going to look into it
> >> again during the weekend. I can reserve the hardware that long, but I
> >> think we first need to fix striped writes in general.
> > 
> > The VM calls writepages and btrfs tries to suck down all the pages that
> > belong to the same extent.  And we try to allocate the extents on
> > boundaries.  There is definitely some bleeding into rmw when I do it
> > here, but overall it does well.
> > 
> > But I was using 8 drives.  I'll try with 12.
> 
> Hmm, I already tried with 10 drives (8+2), doesn't make a difference for
> RMW.

My benchmarks were on flash, so the rmw I was seeing may not have had as
big an impact.

-chris

