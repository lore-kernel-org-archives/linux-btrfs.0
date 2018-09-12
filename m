Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726906AbeILW3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 18:29:50 -0400
Date: Wed, 12 Sep 2018 19:24:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/36] btrfs: dump block_rsv whe dumping space info
Message-ID: <20180912172414.GN2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-9-josef@toxicpanda.com>
 <20180911231145.GE26631@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911231145.GE26631@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 04:11:45PM -0700, Omar Sandoval wrote:
> On Tue, Sep 11, 2018 at 01:57:39PM -0400, Josef Bacik wrote:
> > For enospc_debug having the block rsvs is super helpful to see if we've
> > done something wrong.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/extent-tree.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index a3baa16d456f..1cf66a92829b 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -7918,6 +7918,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
> >  	return ret;
> >  }
> >  
> > +static void dump_block_rsv(struct btrfs_fs_info *fs_info,
> > +			   struct btrfs_block_rsv *rsv)
> > +{
> > +	spin_lock(&rsv->lock);
> > +	btrfs_info(fs_info, "%d: size %llu reserved %llu\n",

no "\n" for the message helpers

> > +		   rsv->type, (unsigned long long)rsv->size,
> > +		   (unsigned long long)rsv->reserved);

u64 does  not need the (unsigned long long) typecast since long.

> How about passing a string name for each of these instead of an ID which
> we have to cross-reference with the source?

Agreed, this would be better. As this is a debugging stuff, we can use
macros to simplify it like:

#define		DUMP_BLOCK_RSV(fs_info, rsv_name)		\
do {								\
	struct btrfs_block_rsv *__rsv = &(fs_info)->rsv_name;	\
	spin_lock(&__rsv->lock);				\
	btrfs_info((fs_info), #rsv_name ": size ...");		\
	spin_unlock(&__rsv->lock);				\
} while(0)

and use as

DUMP_BLOCK_RSV(fs_info, global_block_rsv);

The name of the block reserve name remains greppable.
