From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Date: Fri, 8 Oct 2010 09:16:54 -0400
Message-ID: <20101008131654.GJ4804@think>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008072749.GB7831@lst.de>
 <20101008075001.GT4681@dastard>
 <20101008081714.GB1728@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101008081714.GB1728@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 08, 2010 at 10:17:14AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 06:50:01PM +1100, Dave Chinner wrote:
> > > There's no need to lock a normal 32-bit variable for readers.
> > 
> > Ok, but will need a memory barrier instead?
> 
> Isn't spin_unlock supposed to be one?  I'll need some of the locking
> experts to shime in.

Not really a locking expert, but the locking operations are supposed to
have an implicit barrier.

-chris

