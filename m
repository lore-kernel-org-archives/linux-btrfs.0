Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57901 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab2GMKcZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jul 2012 06:32:25 -0400
Date: Fri, 13 Jul 2012 06:32:22 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH v2] Btrfs: improve multi-thread buffer read
Message-ID: <20120713103222.GE30128@shiny>
References: <1342059231-20301-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120712180402.GA30128@shiny>
 <4FFF8D5F.7030303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFF8D5F.7030303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2012 at 08:52:15PM -0600, Liu Bo wrote:
> On 07/12/2012 02:04 PM, Chris Mason wrote:
> > I like this patch, its a  big improvement for just a little timing
> > change.  Instead of doing the kmalloc of this struct, can you please
> > change it to put a pagevec on the stack.
> > 
> > The model would be:
> > 
> > add a page to the pagevec array
> > if pagevec full
> > 	launch all the readpages
> > 
> > This lets you avoid the kmalloc, and it is closer to how we solve
> > similar problems in other parts of the kernel.
> > 
> 
> 
> Yeah, but there is something different.
> 
> Actually my first attempt is doing this with struct pagevec, but pagevec has
> a PAGEVEC_SIZE, which is limited to 14.
> 
> That means that at the worst case, we batch only 14 pages in a bio to submit.
> 
> However, a bio is able to contains at most 128 pages with my devices, that's the
> reason why I turn to kmalloc another struct.
> 
> Here is some performance number:
>           w/o patch      w pvec patch     w kmalloc patch
>         -------------   --------------  ---------------
> READ:      745MB/s         880MB/s          987MB/s
> 
> 
> So what do you think about it?  I'm ok with both.

Lets go with the pagevec.  This particular workload (multiple threads
hammering big reads on the same range) is very specific.  The pagevec
gets us half way there, but won't add extra cost in any other workloads.

-chris

