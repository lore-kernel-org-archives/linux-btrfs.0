From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix our reservations for updating an inode when
 completing io V3
Date: Fri, 11 Nov 2011 07:52:57 -0500
Message-ID: <20111111125257.GF4435@shiny>
References: <1320965827-1324-1-git-send-email-josef@redhat.com>
 <20111111122836.GX12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111111122836.GX12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 11, 2011 at 01:28:36PM +0100, David Sterba wrote:
> On Thu, Nov 10, 2011 at 05:57:07PM -0500, Josef Bacik wrote:
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -2699,8 +2699,8 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
> >  				    size_t pg_offset, u64 start, u64 end,
> >  				    int create);
> >  int btrfs_update_inode(struct btrfs_trans_handle *trans,
> > -			      struct btrfs_root *root,
> > -			      struct inode *inode);
> > +		       struct btrfs_root *root, struct inode *inode,
> > +		       int fallback);
> 
> Can you please add a helper __btrfs_update_inode which takes the
> argument, leave btrfs_update_inode as is and add
> btrfs_update_inode_fallback for the '1' case?
> 
> So you don't change every callsite of btrfs_update_inode and just those 4
> which need _fallback variant (the rest is 29, quite a lot).

I reworked this last night since I already have v2.  See my for-linus
branch.

-chris
