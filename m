Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35019 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbeHXV2S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 17:28:18 -0400
Date: Fri, 24 Aug 2018 10:52:32 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: set leave_spinning in btrfs_get_extent
Message-ID: <20180824175231.zjzwli7wcpjv3gi7@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534980978-91392-2-git-send-email-bo.liu@linux.alibaba.com>
 <1534981265-97557-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180824145949.GR24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180824145949.GR24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2018 at 04:59:49PM +0200, David Sterba wrote:
> On Thu, Aug 23, 2018 at 07:41:05AM +0800, Liu Bo wrote:
> > Unless it's going to read inline extents from btree leaf to page,
> > btrfs_get_extent won't sleep during the period of holding path lock.
> > 
> > This sets leave_spinning at first and sets path to blocking mode right
> > before reading inline extent if that's the case.  The benefit is that a
> > path in spinning mode typically has less impact (faster) on waiters
> > rather than that in blocking mode.
> > 
> > Also fixes the misalignment of the prototype, which is too trivial for
> > a single patch.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> > v2: send out the correct patch.
> > 
> >  fs/btrfs/ctree.h |  4 ++--
> >  fs/btrfs/inode.c | 14 +++++++++++---
> >  2 files changed, 13 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 1aeed3c0e949..00e506de70ba 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3177,8 +3177,8 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
> >  struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
> >  			 struct btrfs_root *root, int *was_new);
> >  struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> > -		struct page *page, size_t pg_offset,
> > -		u64 start, u64 end, int create);
> > +				    struct page *page, size_t pg_offset,
> > +				    u64 start, u64 end, int create);
> 
> Please don't add unrelated changes.
> 
> >  int btrfs_update_inode(struct btrfs_trans_handle *trans,
> >  			      struct btrfs_root *root,
> >  			      struct inode *inode);
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 10e86f7b5398..31d43355f052 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6787,9 +6787,9 @@ static noinline int uncompress_inline(struct btrfs_path *path,
> >   * This also copies inline extents directly into the page.
> >   */
> >  struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> > -		struct page *page,
> > -	    size_t pg_offset, u64 start, u64 len,
> > -		int create)
> > +				    struct page *page,
> > +				    size_t pg_offset, u64 start, u64 len,
> > +				    int create)
> 
> Ok, this looks ugly and the reformatting makes sense, both declaration
> and prototype, but please send it as a separate patch.

Sure.

Note that there're still some format issues introduced by the old
patch set of "inode -> btrfs_inode".

thanks,
-liubo
