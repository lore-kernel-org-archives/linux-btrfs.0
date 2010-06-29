From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] btrfs: make code reachable in btrfs_insert_some_items()
Date: Mon, 28 Jun 2010 21:04:05 -0400
Message-ID: <20100629010405.GU1993@think>
References: <20100628111726.GI19184@bicker>
 <4C294512.8070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C294512.8070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 29, 2010 at 08:57:54AM +0800, Miao Xie wrote:
> Hi,
> 
> on 2010-6-28 19:17, Dan Carpenter wrote:
> > The break was in front of the "nr = i" assignment so that was never hit.
> 
> This bug has been fixed a month ago, and the patch has been merged into the
> btrfs-unstable tree.

This was one that we took out to keep the pull request down to the
critical fixes.  That function actually isn't called, I'll just remove
it.

-chris

> 
>   http://marc.info/?l=linux-btrfs&m=127434036913484&w=2
> 
> Thanks
> Miao
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 0d1d966..ceb8ad2 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
> >  	for (i = 0; i < nr; i++) {
> >  		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
> >  		    BTRFS_LEAF_DATA_SIZE(root)) {
> > -			break;
> >  			nr = i;
> > +			break;
> >  		}
> >  		total_data += data_size[i];
> >  		total_size += data_size[i] + sizeof(struct btrfs_item);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
