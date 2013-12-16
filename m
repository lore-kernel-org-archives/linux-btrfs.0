Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3LPK0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 05:26:18 -0500
Date: Mon, 16 Dec 2013 18:26:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Btrfs: avoid building inode cache repeatly
Message-ID: <20131216102601.GC30413@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
 <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
 <52AEC221.70708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52AEC221.70708@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 05:04:33PM +0800, Miao Xie wrote:
> On 	mon, 16 Dec 2013 15:25:33 +0800, Liu Bo wrote:
> > Inode cache is similar to free space cache and in fact shares the same
> > code, however, we don't load inode cache unless we're about to allocate
> > inode id, then there is a case where we only commit the transaction during
> > other operations, such as snapshot creation, we now update fs roots' generation
> > to the new transaction id, after that when we want to load the inode cache,
> > we'll find that it's not valid thanks to the mismatch of generation, and we
> > have to push btrfs-ino-cache thread to build inode cache from disk, and
> > this operation is sometimes time-costing.
> > 
> > So to fix the above, we load inode cache into memory during reading fs root.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: fix race issue pointed by Miao.
> > 
> >  fs/btrfs/disk-io.c   | 3 +++
> >  fs/btrfs/inode-map.c | 6 ++++++
> >  fs/btrfs/inode-map.h | 1 +
> >  fs/btrfs/root-tree.c | 3 +++
> >  4 files changed, 13 insertions(+)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 8072cfa..59af2aa 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1630,6 +1630,9 @@ again:
> >  		}
> >  		goto fail;
> >  	}
> > +
> > +	btrfs_start_ino_caching(root);
> > +
> >  	return root;
> >  fail:
> >  	free_fs_root(root);
> > diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> > index ab485e5..f23b0df 100644
> > --- a/fs/btrfs/inode-map.c
> > +++ b/fs/btrfs/inode-map.c
> > @@ -179,6 +179,12 @@ static void start_caching(struct btrfs_root *root)
> >  	BUG_ON(IS_ERR(tsk)); /* -ENOMEM */
> >  }
> >  
> > +void btrfs_start_ino_caching(struct btrfs_root *root)
> > +{
> > +	if (root)
> > +		start_caching(root);
> > +}
> 
> We are sure root is not NULL, so this check is unnecessary.
> 
> I dipped into the problem, I don't think loading inode cache during reading
> fs root is a good way to fix this problem, because in some cases, we read
> the fs/file root, but we don't want to allocate/free the inode id.
> 
> I think we can add a flag, which is used to mark if the fs/file root has inode
> id cache. We can set the flag when we reading the fs/file root. If the flag is
> set but we don't allocate/free the inode id from/to the inode id cache, we set
> the generation in the space cache header to 0, which can avoid loading a invalid
> inode cache, and then clear the flag. How about this idea?

That's same with the current code.

If we don't allocate/free inode ids, @root->cached remains BTRFS_CACHE_NO, and
btrfs_save_ino_cache will set inode cache's generation to 0.

So the problem of rebuilding inode cache repeatly is not loading an invalid
ino-cache.

btrfs_save_ino_cache() cleanup a valid inode cache during transaction commit
because of options INODE_MAP, and find that inode cache is not even loaded
during that committed transaction, and it just skip writing out inode cache.
Next time when we're allocating inode ids, we load the inode cache and find it
is there but already outdated so that we have to rebuild another one same with
the previous cache.

To fit what you concerned, btrfs_save_ino_cache() reminds us that only fs tree
and subvol/snap need ino cache, so I think adding a check like that is enough
to filter out those fs/file roots where we don't want to allocate/free inode
ids, eg. data reloc root.

-liubo
