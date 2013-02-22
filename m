Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60541 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3BVI0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 03:26:36 -0500
Date: Fri, 22 Feb 2013 17:26:31 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: dsterba@suse.cz
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [PATCH v2] btrfs: use kmalloc for lzo de/compress buffer
Message-ID: <20130222082630.GA21294@Corona>
References: <1361174164-7182-1-git-send-email-kyungsik.lee@lge.com>
 <20130221134153.GD27541@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130221134153.GD27541@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 02:41:53PM +0100, David Sterba wrote:
> On Mon, Feb 18, 2013 at 04:56:04PM +0900, Kyungsik Lee wrote:
> > @@ -55,8 +55,9 @@ static struct list_head *lzo_alloc_workspace(void)
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
> > -	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
> > -	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
> > +	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
> > +	workspace->cbuf = kmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE),
> 
> This is still larger than usual page size and allocator may issue a
> warning, so if we want to use kmalloc (it's ~4.4k in size and likely to
> be available, but not always due to possible page fragmentation), the
> __GFP_NOWARN should be supplied and if the allocation fails fall back to
> vmalloc.
Right, there shoud be another fixed verson for this.

Thanks,
Kyungsik
