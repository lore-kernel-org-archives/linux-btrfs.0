Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43166 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeFFRv0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 13:51:26 -0400
Date: Wed, 6 Jun 2018 10:50:49 -0700
From: Matthew Wilcox <willy@infradead.org>
To: dsterba@suse.cz, Souptick Joarder <jrdr.linux@gmail.com>, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: btrfs: Change return type to vm_fault_t
Message-ID: <20180606175049.GB12439@bombadil.infradead.org>
References: <20180606142444.GA3806@jordon-HP-15-Notebook-PC>
 <20180606155347.GL3539@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180606155347.GL3539@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 05:53:47PM +0200, David Sterba wrote:
> On Wed, Jun 06, 2018 at 07:54:44PM +0530, Souptick Joarder wrote:
> > @@ -9009,7 +9007,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
> >  	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
> >  
> >  out_unlock:
> > -	if (!ret) {
> > +	if (!ret2) {
> >  		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
> >  		sb_end_pagefault(inode->i_sb);
> >  		extent_changeset_free(data_reserved);
> 
> 9013                 return VM_FAULT_LOCKED;
> 9014         }
> 9015         unlock_page(page);
> 9016 out:
> 9017         btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
> 9018         btrfs_delalloc_release_space(inode, data_reserved, page_start,
> 9019                                      reserved_space, (ret != 0));
> 
> I've noticed that there's 'ret' used on lines 9017 and 19, comparing to
> a raw number. Is this going to be ok once vm_fault_t is it's own type?
> 
> There's no corresponding define for 0 among the VM_FAULT_* values, I'd
> expect 0 to work interchangeably, similar to the blk_status_t type:
> 
> https://elixir.bootlin.com/linux/latest/source/include/linux/blk_types.h#L30
> 
> #define	BLK_STS_OK 0
> #define BLK_STS_NOTSUPP		((__force blk_status_t)1)
> #define BLK_STS_TIMEOUT		((__force blk_status_t)2)
> #define BLK_STS_NOSPC		((__force blk_status_t)3)
> ...
> 
> Your patch is otherwise ok, I'm just curious if this is something to
> watch for once vmfault type is switched.

Yes, sparse treats 0 specially for these kinds of types.  It goes back to
the original use of __bitwise to mean "this is a special-endian type",
but it's also meaningful for types which aren't _numbers_ so much as a
collection of bits.

By the way, do you really think it improves this function to use 'ret' and
'ret2' like this?  It's your code, and you're entitled to adopt whatever
stylistic preferences you like, but I personally find it easier to read
with 'err' being an errno and 'ret' being the vm_fault_t.
