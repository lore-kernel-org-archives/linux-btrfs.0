Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727421AbeGSNbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:31:16 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95E72ACE3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 12:48:14 +0000 (UTC)
Date: Thu, 19 Jul 2018 14:48:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: drop extent_io_ops::merge_bio_hook callback
Message-ID: <20180719124807.GL26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531996240.git.dsterba@suse.com>
 <0e2c838370aab0b2da788a4c88174ec50979fc4c.1531996240.git.dsterba@suse.com>
 <b898f92f-5c5f-3709-97f8-66ce8a94dc19@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b898f92f-5c5f-3709-97f8-66ce8a94dc19@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 03:02:58PM +0300, Nikolay Borisov wrote:
> On 19.07.2018 14:05, David Sterba wrote:
> > The data and metadata callback implementation both use the same
> > function. We can remove the call indirection completely.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/compression.c | 10 +++-------
> >  fs/btrfs/disk-io.c     |  2 --
> >  fs/btrfs/extent_io.c   |  4 ++--
> >  fs/btrfs/extent_io.h   |  3 ---
> >  fs/btrfs/inode.c       |  5 ++---
> >  5 files changed, 7 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> > index 70dace47258b..9bfa66592aa7 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -299,7 +299,6 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
> >  	struct bio *bio = NULL;
> >  	struct compressed_bio *cb;
> >  	unsigned long bytes_left;
> > -	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> >  	int pg_index = 0;
> >  	struct page *page;
> >  	u64 first_byte = disk_start;
> > @@ -338,9 +337,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
> >  		page = compressed_pages[pg_index];
> >  		page->mapping = inode->i_mapping;
> >  		if (bio->bi_iter.bi_size)
> > -			submit = io_tree->ops->merge_bio_hook(page, 0,
> > -							   PAGE_SIZE,
> > -							   bio, 0);
> > +			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE, bio, 0);
> >  
> >  		page->mapping = NULL;
> >  		if (submit || bio_add_page(bio, page, PAGE_SIZE, 0) <
> > @@ -622,9 +619,8 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
> >  		page->index = em_start >> PAGE_SHIFT;
> >  
> >  		if (comp_bio->bi_iter.bi_size)
> > -			submit = tree->ops->merge_bio_hook(page, 0,
> > -							PAGE_SIZE,
> > -							comp_bio, 0);
> > +			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE,
> > +					comp_bio, 0);
> >  
> >  		page->mapping = NULL;
> >  		if (submit || bio_add_page(comp_bio, page, PAGE_SIZE, 0) <
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index d6c04933abbc..31ab764cf4e3 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -4527,8 +4527,6 @@ static const struct extent_io_ops btree_extent_io_ops = {
> >  	/* mandatory callbacks */
> >  	.submit_bio_hook = btree_submit_bio_hook,
> >  	.readpage_end_io_hook = btree_readpage_end_io_hook,
> > -	/* note we're sharing with inode.c for the merge bio hook */
> > -	.merge_bio_hook = btrfs_merge_bio_hook,
> >  	.readpage_io_failed_hook = btree_io_failed_hook,
> >  	.set_range_writeback = btrfs_set_range_writeback,
> >  
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index f7a138278f16..55a845621f85 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2784,8 +2784,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
> >  		else
> >  			contig = bio_end_sector(bio) == sector;
> >  
> > -		if (tree->ops && tree->ops->merge_bio_hook(page, offset,
> > -					page_size, bio, bio_flags))
> > +		if (tree->ops && btrfs_merge_bio_hook(page, offset, page_size,
> > +						      bio, bio_flags))
> 
> While this is correct I dislike having the if (tree->ops ) check. So
> under what conditions do we NOT have the tree->ops set? Looking at the
> code it seems we are setting it everytime we create an inode in
> btrfs_create. We also set it for symlinks (btrfs_symlink) and a tmp file
> (btrfs_tmpfile). Strangely enough in btrfs_read_locked_inode we only set
> it for regular files (S_IFREG).

That's correct. I did not notice setting extent_io ops in the symlink
and tmpfile functions and found only the weirdness in
btrfs_read_locked_inode, but it looks like we can drop the tree->ops
completely.

> submit_extent_page seems to be called for both metadata but as we no
> longer distinguish between eb merge_hook and data merge_hook perhaps the
> tree->ops could be killed as well ?

I have WIP patches that replace the callbacks that touch the callsites
doing the tree->ops checks, so I'll keep it mind that there are more
cleanups to be done.
