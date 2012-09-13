Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40816 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2IMMhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 08:37:23 -0400
Date: Thu, 13 Sep 2012 08:37:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: delay block group item insertion
Message-ID: <20120913123720.GB12994@localhost.localdomain>
References: <1347473053-3158-1-git-send-email-jbacik@fusionio.com>
 <20120913013205.GA12929@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120913013205.GA12929@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2012 at 07:32:05PM -0600, Liu Bo wrote:
> On Wed, Sep 12, 2012 at 02:04:13PM -0400, Josef Bacik wrote:
> > So we have lots of places where we try to preallocate chunks in order to
> > make sure we have enough space as we make our allocations.  This has
> > historically meant that we're constantly tweaking when we should allocate a
> > new chunk, and historically we have gotten this horribly wrong so we way
> > over allocate either metadata or data.  To try and keep this from happening
> > we are going to make it so that the block group item insertion is done out
> > of band at the end of a transaction.  This will allow us to create chunks
> > even if we are trying to make an allocation for the extent tree.  With this
> > patch my enospc tests run faster (didn't expect this) and more efficiently
> > use the disk space (this is what I wanted).  Thanks,
> >
> 
> I'm afraid this does not perform good enough in normal case, here is the
> compilebench test:
> 
> # cat btrfs-makej/result-4k
> intial create total runs 30 avg 51.99 MB/s (user 0.50s sys 0.85s)
> compile total runs 30 avg 98.45 MB/s (user 0.12s sys 0.38s)
> read compiled tree total runs 3 avg 19.89 MB/s (user 1.55s sys 3.07s)
> delete compiled tree total runs 30 avg 12.15 seconds (user 0.66s sys 2.15s)
> 
> # cat btrfs-josef-makej/result
> intial create total runs 30 avg 49.79 MB/s (user 0.52s sys 0.87s)
> compile total runs 30 avg 70.01 MB/s (user 0.14s sys 0.44s)
> read compiled tree total runs 3 avg 18.46 MB/s (user 1.57s sys 3.16s)
> delete compiled tree total runs 30 avg 13.88 seconds (user 0.67s sys 2.18s)
> 
> And the blktrace shows that it makes us do more seeks in create and
> compile section.
> 
> The patch overall looks clean and good though.
> 

Yeah mostly what I'm looking for is more efficient metadata chunk allocation,
and I expected it to have a performance impact somwhere (I just never hit one in
my ENOSPC tests).  This drop is within reason for me and I'm willing to eat a
slight performance drop to not allocate an entire disk with metadata ;).
Thanks,

Josef
