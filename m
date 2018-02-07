Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbeBHCWX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 21:22:23 -0500
Date: Wed, 7 Feb 2018 14:57:35 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
Message-ID: <20180207225735.GA15305@dhcp-10-159-246-77.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <1489ba8a-8cac-1a25-3dc5-9274bc96b5ef@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1489ba8a-8cac-1a25-3dc5-9274bc96b5ef@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 06, 2018 at 09:28:14AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年02月06日 07:15, Liu Bo wrote:
> > Btrfs tries its best to tolerate write errors, but kind of silently
> > (except some messages in kernel log).
> > 
> > For raid1 and raid10, this is usually not a problem because there is a
> > copy as backup, while for parity based raid setup, i.e. raid5 and
> > raid6, the problem is that, if a write error occurs due to some bad
> > sectors, one horizonal stripe becomes degraded and the number of write
> > errors it can tolerate gets reduced by one, now if two disk fails,
> > data may be lost forever.
> > 
> > One way to mitigate the data loss pain is to expose 'bad chunks',
> > i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> > to relocate the whole chunk and get the full raid6 protection again
> > (if the relocation works).
> > 
> > This introduces 'bad_chunks' in btrfs's per-fs sysfs directory.  Once
> > a chunk of raid5 or raid6 becomes degraded, it will appear in
> > 'bad_chunks'.
> 
> Sysfs looks good.
> 
> Although other systems uses their own interface to handle their status.
> Mdadm uses /proc/mdstat to show such status, LVM uses lvdisplay/lvs.
>

It's more like badblocks in md, instead of /proc/mdstat.

> So here comes to a new sys-fs interface.
> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > - In this patch, 'bad chunks' is not persistent on disk, but it can be
> >   added if it's thought to be a good idea.
> 
> IHMO such bad chunks list can be built using existing dev status at
> mount time.
>

What dev status offers is counters, but here chunk info. is needed if
we want balance to do relocation.  I'll think harder about how to use
it.

> Although using dev status may cause extra problems like false alerts.
> 
> > - This is lightly tested, comments are very welcome.
> 
> Just checked the code, there are 2 concerns:
> 
> 1) The way to remove bad chunk
>    Currently it can only be removed when the chunk is removed.
>    If any transient write error happened, the bad chunk will just be
>    there forever (if not removed)
>

The fundamental assumption about write error is that filesystem should
not get any transient write error, as the underlying layers in IO
stack should do their best to get rid of transient write error.
(probably I should add this to the patch log.)

So once we get a bad chunk, there is a real IO error, for now what I
can think of is to use balance to create a new chunk to hold
everything in the bad chunk and the new chunk has the full raid
protection.

>    It seems to cause false alert.
> 
>    And extra logic to determine if it's a real bad chunk in kernel seems
>    a little complex and less flex.
>    (Maybe an interface to info userspace where problem happens is more
>     flex?)
>

It depends on what users care about, when raid6 is in use, I think
users would care how many disk failures btrfs could tolerate at any
point, about bad chunks whether it's true or false, probably they
don't care, they might think it'd help a lot if some operations could
be done to get the system back to the protect level they want.

> 2) Bad chunk is only added when writing
>    Read routine should also be able to detect bad chunks, with better
>    accuracy.
>

Do you mean a read error should also report bad chunk?
Or am I misunderstanding your point?

Typically read failure would trigger reconstruction and a write for
correction will be issued, then we could get bad chunks if correction
write fails.

> > 
> >  fs/btrfs/ctree.h       |  8 +++++++
> >  fs/btrfs/disk-io.c     |  2 ++
> >  fs/btrfs/extent-tree.c | 13 +++++++++++
> >  fs/btrfs/raid56.c      | 59 ++++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/btrfs/sysfs.c       | 26 ++++++++++++++++++++++
> >  fs/btrfs/volumes.c     | 15 +++++++++++--
> >  fs/btrfs/volumes.h     |  2 ++
> >  7 files changed, 121 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 13c260b..08aad65 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -1101,6 +1101,9 @@ struct btrfs_fs_info {
> >  	spinlock_t ref_verify_lock;
> >  	struct rb_root block_tree;
> >  #endif
> > +
> > +	struct list_head bad_chunks;
> 
> Rbtree may be better here.
> 
> Since iterating a list to remove bad chunk can sometimes be slow.
>

At the point I wrote the patch, I thought bad chunk should be rare
case so list search is fine, but now I'm not sure.

> > +	seqlock_t bc_lock;
> >  };
> >  
> >  static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
> > @@ -2568,6 +2571,11 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
> >  
> >  /* extent-tree.c */
> >  
> > +struct btrfs_bad_chunk {
> > +	u64 chunk_offset;
> 
> It would be better to have chunk_size to info user.
> Just chunk start won't tell user how serious the problem is.
>

Hmm, I don't understand what extra value chunk_size can offer.

> And according to the code, any write error makes the chunk marked as
> bad, no matter if the error can be tolerant.
> 
> It would be better if we have different error type, bad for error
> intolerant, while degraded for some something tolerant.
>

Let me see..

If the error cannot be tolerated, -EIO would be received by userspace
applications and data is already lost, even balance would not make any
difference.  In this case, seems bad chunk doesn't make sense.

If the error can be tolerated, btrfs just carries on and userspace
applications are not aware of this error, then balance can help regain
the full raid protection.

So it makes sense, we can add a tag to tell whether it's tolerable or
not.

Thanks a lot for the comments.

Thanks,

-liubo

> > +	struct list_head list;
> > +};
> > +
> >  enum btrfs_inline_ref_type {
> >  	BTRFS_REF_TYPE_INVALID =	 0,
> >  	BTRFS_REF_TYPE_BLOCK =		 1,
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index a8ecccf..061e7f94 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2568,6 +2568,8 @@ int open_ctree(struct super_block *sb,
> >  	init_waitqueue_head(&fs_info->async_submit_wait);
> >  
> >  	INIT_LIST_HEAD(&fs_info->pinned_chunks);
> > +	INIT_LIST_HEAD(&fs_info->bad_chunks);
> > +	seqlock_init(&fs_info->bc_lock);
> >  
> >  	/* Usable values until the real ones are cached from the superblock */
> >  	fs_info->nodesize = 4096;
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 2f43285..3ca7cb4 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -9903,6 +9903,19 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
> >  		kobject_del(&space_info->kobj);
> >  		kobject_put(&space_info->kobj);
> >  	}
> > +
> > +	/* Clean up bad chunks. */
> > +	write_seqlock_irq(&info->bc_lock);
> > +	while (!list_empty(&info->bad_chunks)) {
> > +		struct btrfs_bad_chunk *bc;
> > +
> > +		bc = list_first_entry(&info->bad_chunks,
> > +				      struct btrfs_bad_chunk, list);
> > +		list_del_init(&bc->list);
> > +		kfree(bc);
> > +	}
> > +	write_sequnlock_irq(&info->bc_lock);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index a7f7925..e960247 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -888,14 +888,19 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
> >  }
> >  
> >  /*
> > - * end io function used by finish_rmw.  When we finally
> > - * get here, we've written a full stripe
> > + * end io function used by finish_rmw.  When we finally get here, we've written
> > + * a full stripe.
> > + *
> > + * Note that this is not under interrupt context as we queued endio to workers.
> >   */
> >  static void raid_write_end_io(struct bio *bio)
> >  {
> >  	struct btrfs_raid_bio *rbio = bio->bi_private;
> >  	blk_status_t err = bio->bi_status;
> >  	int max_errors;
> > +	u64 stripe_start = rbio->bbio->raid_map[0];
> > +	struct btrfs_fs_info *fs_info = rbio->fs_info;
> > +	int err_cnt;
> >  
> >  	if (err)
> >  		fail_bio_stripe(rbio, bio);
> > @@ -908,12 +913,58 @@ static void raid_write_end_io(struct bio *bio)
> >  	err = BLK_STS_OK;
> >  
> >  	/* OK, we have read all the stripes we need to. */
> > +	err_cnt = atomic_read(&rbio->error);
> >  	max_errors = (rbio->operation == BTRFS_RBIO_PARITY_SCRUB) ?
> >  		     0 : rbio->bbio->max_errors;
> >  	if (atomic_read(&rbio->error) > max_errors)
> >  		err = BLK_STS_IOERR;
> >  
> >  	rbio_orig_end_io(rbio, err);
> > +
> > +	/*
> > +	 * If there is any error, this stripe is a degraded one, so is the whole
> > +	 * chunk, expose this chunk info to sysfs.
> > +	 */
> > +	if (unlikely(err_cnt)) {
> > +		struct btrfs_bad_chunk *bc;
> > +		struct btrfs_bad_chunk *tmp;
> > +		struct extent_map *em;
> > +		unsigned long flags;
> > +
> > +		em = get_chunk_map(fs_info, stripe_start, 1);
> > +		if (IS_ERR(em))
> > +			return;
> > +
> > +		bc = kzalloc(sizeof(*bc), GFP_NOFS);
> > +		/* If allocation fails, it's OK. */
> > +		if (!bc) {
> > +			free_extent_map(em);
> > +			return;
> > +		}
> > +
> > +		write_seqlock_irqsave(&fs_info->bc_lock, flags);
> > +		list_for_each_entry(tmp, &fs_info->bad_chunks, list) {
> > +			if (tmp->chunk_offset != em->start)
> > +				continue;
> > +
> > +			/*
> > +			 * Don't bother if this chunk has already been recorded.
> > +			 */
> > +			write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
> > +			kfree(bc);
> > +			free_extent_map(em);
> > +			return;
> > +		}
> > +
> > +		/* Add new bad chunk to list. */
> > +		bc->chunk_offset = em->start;
> > +		free_extent_map(em);
> > +
> > +		INIT_LIST_HEAD(&bc->list);
> > +		list_add(&bc->list, &fs_info->bad_chunks);
> > +
> > +		write_sequnlock_irqrestore(&fs_info->bc_lock, flags);
> > +	}
> >  }
> >  
> >  /*
> > @@ -1320,6 +1371,8 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
> >  		bio->bi_end_io = raid_write_end_io;
> >  		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> >  
> > +		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
> > +
> >  		submit_bio(bio);
> >  	}
> >  	return;
> > @@ -2465,6 +2518,8 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
> >  		bio->bi_end_io = raid_write_end_io;
> >  		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> >  
> > +		btrfs_bio_wq_end_io(rbio->fs_info, bio, BTRFS_WQ_ENDIO_RAID56);
> > +
> >  		submit_bio(bio);
> >  	}
> >  	return;
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index a28bba8..0baaa33 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -490,12 +490,38 @@ static ssize_t quota_override_store(struct kobject *kobj,
> >  
> >  BTRFS_ATTR_RW(, quota_override, quota_override_show, quota_override_store);
> >  
> > +static ssize_t btrfs_bad_chunks_show(struct kobject *kobj,
> > +				     struct kobj_attribute *a, char *buf)
> > +{
> > +	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> > +	struct btrfs_bad_chunk *bc;
> > +	int len = 0;
> > +	unsigned int seq;
> > +
> > +	/* read lock please */
> > +	do {
> > +		seq = read_seqbegin(&fs_info->bc_lock);
> > +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> > +			len += snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
> > +					bc->chunk_offset);
> > +			/* chunk offset is u64 */
> > +			if (len >= PAGE_SIZE)
> > +				break;
> > +		}
> > +	} while (read_seqretry(&fs_info->bc_lock, seq));
> > +
> > +	return len;
> > +}
> > +
> > +BTRFS_ATTR(, bad_chunks, btrfs_bad_chunks_show);
> > +
> >  static const struct attribute *btrfs_attrs[] = {
> >  	BTRFS_ATTR_PTR(, label),
> >  	BTRFS_ATTR_PTR(, nodesize),
> >  	BTRFS_ATTR_PTR(, sectorsize),
> >  	BTRFS_ATTR_PTR(, clone_alignment),
> >  	BTRFS_ATTR_PTR(, quota_override),
> > +	BTRFS_ATTR_PTR(, bad_chunks),
> >  	NULL,
> >  };
> >  
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index a256842..d71f11a 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -2803,8 +2803,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
> >  	return ret;
> >  }
> >  
> > -static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> > -					u64 logical, u64 length)
> > +struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> > +				 u64 logical, u64 length)
> >  {
> >  	struct extent_map_tree *em_tree;
> >  	struct extent_map *em;
> > @@ -2840,6 +2840,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
> >  	u64 dev_extent_len = 0;
> >  	int i, ret = 0;
> >  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> > +	struct btrfs_bad_chunk *bc;
> >  
> >  	em = get_chunk_map(fs_info, chunk_offset, 1);
> >  	if (IS_ERR(em)) {
> > @@ -2916,6 +2917,16 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
> >  	}
> >  
> >  out:
> > +	write_seqlock_irq(&fs_info->bc_lock);
> > +	list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> > +		if (bc->chunk_offset == chunk_offset) {
> > +			list_del_init(&bc->list);
> > +			kfree(bc);
> > +			break;
> > +		}
> > +	}
> > +	write_sequnlock_irq(&fs_info->bc_lock);
> > +
> >  	/* once for us */
> >  	free_extent_map(em);
> >  	return ret;
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index ff15208..4e846ba 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -396,6 +396,8 @@ static inline enum btrfs_map_op btrfs_op(struct bio *bio)
> >  	}
> >  }
> >  
> > +struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
> > +				 u64 logical, u64 length);
> >  int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
> >  				   u64 end, u64 *length);
> >  void btrfs_get_bbio(struct btrfs_bio *bbio);
> > 
> 



