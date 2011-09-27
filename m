From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 07/21] Btrfs: add basic infrastructure for selective
 balancing
Date: Tue, 27 Sep 2011 20:28:50 +0300
Message-ID: <20110927172850.GA21419@zambezi.lan>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
 <1314129722-31601-8-git-send-email-idryomov@gmail.com>
 <20110927130241.GA22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110927130241.GA22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 27, 2011 at 03:02:41PM +0200, David Sterba wrote:
> On Tue, Aug 23, 2011 at 11:01:48PM +0300, Ilya Dryomov wrote:
> > This allows to have a separate set of filters for each chunk type
> > (data,meta,sys).  The code however is generic and switch on chunk type
> > is only done once.
> > 
> > This commit also adds a type filter: it allows to balance for example
> > meta and system chunks w/o touching data ones.
> > 
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  fs/btrfs/volumes.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/btrfs/volumes.h |   12 +++++++++
> >  2 files changed, 76 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 0e4a276..95c6310 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2175,6 +2175,30 @@ static void unset_restripe_control(struct btrfs_fs_info *fs_info)
> >  	kfree(rctl);
> >  }
> >  
> > +static int should_restripe_chunk(struct btrfs_root *root,
> > +				 struct extent_buffer *leaf,
> > +				 struct btrfs_chunk *chunk, u64 chunk_offset)
> > +{
> > +	struct restripe_control *rctl = root->fs_info->restripe_ctl;
> > +	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
> > +	struct btrfs_restripe_args *rargs = NULL;
> > +
> > +	/* type filter */
> > +	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
> > +	      (rctl->flags & BTRFS_RESTRIPE_TYPE_MASK))) {
> > +		return 0;
> > +	}
> > +
> > +	if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
> > +		rargs = &rctl->data;
> > +	else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
> > +		rargs = &rctl->sys;
> > +	else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
> > +		rargs = &rctl->meta;
> 
> what's the point of setting local variable 'rargs' without using or
> returning it?

rargs is being used later in the series, it is passed to every filter
function.  It's kind of hard to review, but that way I can break the
thing into logical chunks and describe each of them.

Thanks,

		Ilya
