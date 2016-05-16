Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbcEPRWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 13:22:18 -0400
Date: Mon, 16 May 2016 10:24:01 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] Btrfs: replace BUG_ON with WARN in merge_bio
Message-ID: <20160516172400.GA11100@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-5-git-send-email-bo.li.liu@oracle.com>
 <20160516084438.GB511@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160516084438.GB511@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 16, 2016 at 10:44:38AM +0200, David Sterba wrote:
> On Fri, May 13, 2016 at 05:07:00PM -0700, Liu Bo wrote:
> > We have two BUG_ON in merge_bio, but since it can gracefully return errors
> > to callers, use WARN_ONCE to give error information and don't leave a
> > possible panic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent_io.c | 1 -
> >  fs/btrfs/inode.c     | 6 ++++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index e601e0f..99286d1 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2746,7 +2746,6 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
> >  	if (tree->ops && tree->ops->merge_bio_hook)
> >  		ret = tree->ops->merge_bio_hook(rw, page, offset, size, bio,
> >  						bio_flags);
> > -	BUG_ON(ret < 0);
> >  	return ret;
> >  
> >  }
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 5874562..3a989e3 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -1827,8 +1827,10 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
> >  	map_length = length;
> >  	ret = btrfs_map_block(root->fs_info, rw, logical,
> >  			      &map_length, NULL, 0);
> > -	/* Will always return 0 with map_multi == NULL */
> > -	BUG_ON(ret < 0);
> > +	if (ret < 0) {
> > +		WARN_ONCE(ret < 0, KERN_ERR "ret = %d\n", ret);
> 
> btrfs_map_block is quite verbose about the errors so it's not needed to
> print it here.

OK.

> 
> Otherwise I'm not sure if all paths that go through the merge hook
> handle errors, eg. in btrfs_submit_compressed_read or _write. Some code
> is skipped if merge hook returns nonzero. But, the code expects either 0
> or 1, and when the BUG_ON(ret < 0) is removed suddenly the 'ret < 0' can
> be returned. Unexpected.

Right now btrfs_merge_bio_hook() only returns 1 or 0 and marks (ret < 0) as
 BUG_ON.

But compress code is ready to handle the error,

btrfs_submit_compressed_read/write() {
	...
	ret = merge_bio_hook()
	if (ret || bio_add_page()) {
		ret = btrfs_map_bio();
		BUG_ON(ret);
		...
	}
	...
}

So ret < 0 is handled, if there's any errors from merge_bio_hook(), it submits
 the current bio, so the way is sane to me.

The other consumer of merge_bio is submit_extent_page(), where it's OK
to return errors and callers are ready to handle them.

> 
> It's IMO better to push up the BUG_ON error handling only one caller at
> a time. That way it's easier to review the callgraph and call paths.

merge_bio() is a wrapper for tree->ops->merge_bio_hook(), which is the
same thing with btrfs_merge_bio_hook().  It makes no sense if we just
look at BUG_ON in btrfs_merge_bio_hook but keep BUG_ON() in merge_bio().

Thanks,

-liubo
