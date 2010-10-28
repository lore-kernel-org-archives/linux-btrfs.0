From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [fnst-kernel 10816] Found several problems while reading btrfs
 code
Date: Thu, 28 Oct 2010 09:03:16 -0400
Message-ID: <20101028130316.GX27796@think>
References: <4CC7D75D.3050806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC7D75D.3050806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 27, 2010 at 03:40:13PM +0800, liubo wrote:
> Hi, Chris,
> 
> We've found several tiny problems while reading btrfs code.
> 
> These problems are mainly about uncheck return value or BUG_ON check. 
> They really have an impact on codes' quality, though they will not be 
> hit in normal cases.
> 
> Here comes some examples:
> 
> 1. memory allocation check
> May cause -ENOMEM, btrfs BUG_ON().
> 
> static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
> ...
>         path = btrfs_alloc_path();
>         BUG_ON(!path);

Yes we should either use GFP_NOFAIL or we should deal with the error
nicely.

> 
> 2. return value's BUG_ON() check
> 
> static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
> ...
>         if (btrfs_block_can_be_shared(root, buf)) {
>                 ret = btrfs_lookup_extent_info(trans, root, buf->start,
>                                                buf->len, &refs, &flags);
>                 BUG_ON(ret);
>                 BUG_ON(refs == 0);
> 
> 
> 
> Is there a plan to improve the above? 
> We are helpful on this:)

Definitely.  The first step is to find the errors that can just be
dealt with.  After that we need to make a way to force the FS into a
readonly state for the really impossible ones.

Both are very good projects ;)

-chris

