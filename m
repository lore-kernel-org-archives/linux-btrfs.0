From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 15:43:21 -0500 (EST)
Message-ID: <20100226204321.AC6A640974@viridian.itc.virginia.edu>
References: <20100226190915.GI12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226190915.GI12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

> > 
> > Yes, the array has a writeback cache.
> 
> Ok, this would be my top suspect then, especially if it had to be
> powered off to reset it.  The errors you sent look like some IO just
> didn't happen, which the btrfs code goes to great length to
> detect and complain about.
> 

While the arrays were powered off in both cases, it was well after the
original problem was observed, so I would have expected the array to
flush the cache by then.

In any event, the biggest issue is that I'm left with a totally
unrecoverable filesystem.  On these filesystems I can live with
"something strange happened and you lost some files", but in this case
it's "something strange happened you lost 1TB".

-- 
Bill
