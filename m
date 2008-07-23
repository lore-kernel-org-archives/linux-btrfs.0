From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Use do_div() instead of native 64-bit division in
	btrfs_ordered_sum_size()
Date: Wed, 23 Jul 2008 09:28:26 -0400
Message-ID: <1216819706.6932.146.camel@think.oraclecorp.com>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <20080723111309.GA19988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080723111309.GA19988@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-07-23 at 07:13 -0400, Christoph Hellwig wrote:
> Chris, can you please put this patch in?  Without it btrfs can't be
> loaded on 32bit platforms.
> 

I've pushed out a slightly different fix.  The ordered extents are based
on ram writeback, and so an unsigned long is enough.

-chris


