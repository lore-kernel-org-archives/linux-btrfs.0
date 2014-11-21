Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaKUKG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 05:06:58 -0500
Date: Fri, 21 Nov 2014 02:06:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] btrfs: implement swap file support
Message-ID: <20141121100657.GD8866@infradead.org>
References: <cover.1416219974.git.osandov@osandov.com>
 <20141117154817.GA25670@infradead.org>
 <20141119072235.GA6541@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141119072235.GA6541@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 18, 2014 at 11:22:35PM -0800, Omar Sandoval wrote:
> Here's a nice little bit of insanity I put together in that direction --
> consider it a discussion point more than a patch. It does two things:
> 
> - Uses an ITER_BVEC iov_iter to do direct_IO for swap_readpage. This makes
>   swap_readpage a synchronous operation, but I think that's the best we can do
>   with the existing interface.

Note that ->read_iter for direct-io supports async I/O in general.  By
resurrecting some of the older attempts to do in-kernel aio this could
be made async easily.

> - Unless I'm missing something, there don't appear to be any instances of
>   ITER_BVEC | READ in the kernel, so the dio path doesn't know not to dirty
>   pages it gets that way. Dave Kleikamp and Ming Lei each previously submitted
>   patches doing this as part of adding an aio_kernel interface. (The NFS direct
>   I/O implementation doesn't know how to deal with these either, so this patch
>   actually breaks the only existing user of this code path, but in the interest
>   of keeping the patch short, I didn't try to fix it :)

Right, we'd need to look into.  Bonus points of allowing this as a zero
copy read.


Btw, in the long run I would much prefer killing of the current horrible
swap using bmap path in favor of an enhanced direct I/O path.
