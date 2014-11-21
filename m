Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58037 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828AbaKUKMg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 05:12:36 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so2785474pdj.37
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 02:12:36 -0800 (PST)
Date: Fri, 21 Nov 2014 02:12:33 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] btrfs: implement swap file support
Message-ID: <20141121101233.GA21814@mew>
References: <cover.1416219974.git.osandov@osandov.com>
 <20141117154817.GA25670@infradead.org>
 <20141119072235.GA6541@mew>
 <20141121100657.GD8866@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141121100657.GD8866@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 21, 2014 at 02:06:57AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 18, 2014 at 11:22:35PM -0800, Omar Sandoval wrote:
> > Here's a nice little bit of insanity I put together in that direction --
> > consider it a discussion point more than a patch. It does two things:
> > 
> > - Uses an ITER_BVEC iov_iter to do direct_IO for swap_readpage. This makes
> >   swap_readpage a synchronous operation, but I think that's the best we can do
> >   with the existing interface.
> 
> Note that ->read_iter for direct-io supports async I/O in general.  By
> resurrecting some of the older attempts to do in-kernel aio this could
> be made async easily.
> 
> > - Unless I'm missing something, there don't appear to be any instances of
> >   ITER_BVEC | READ in the kernel, so the dio path doesn't know not to dirty
> >   pages it gets that way. Dave Kleikamp and Ming Lei each previously submitted
> >   patches doing this as part of adding an aio_kernel interface. (The NFS direct
> >   I/O implementation doesn't know how to deal with these either, so this patch
> >   actually breaks the only existing user of this code path, but in the interest
> >   of keeping the patch short, I didn't try to fix it :)
> 
> Right, we'd need to look into.  Bonus points of allowing this as a zero
> copy read.
> 
> 
> Btw, in the long run I would much prefer killing of the current horrible
> swap using bmap path in favor of an enhanced direct I/O path.
Looks like I just raced on your email and sent a v2 of my patch series before
seeing this response :) I'll take a closer look at this tomorrow, thanks for
getting back to me.

-- 
Omar
