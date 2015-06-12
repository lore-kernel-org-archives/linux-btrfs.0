Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34360 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbFLIMd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 04:12:33 -0400
Received: by payr10 with SMTP id r10so18619786pay.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 01:12:32 -0700 (PDT)
Date: Fri, 12 Jun 2015 01:12:28 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, "'Miao Xie'" <miaoxie@huawei.com>,
        "'Philip'" <bugzilla@philip-seeger.de>
Subject: Re: [PATCH 4/4] Btrfs: fix device replace of a missing RAID 5/6
 device
Message-ID: <20150612081228.GA9641@mew>
References: <cover.1431330020.git.osandov@osandov.com>
 <70bee734f3393a069d259e7db87e3c86a535e726.1431330020.git.osandov@osandov.com>
 <005901d0a431$77c0a110$6741e330$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <005901d0a431$77c0a110$6741e330$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Zhaolei,

On Thu, Jun 11, 2015 at 06:29:15PM +0800, Zhao Lei wrote:
> Hi, Omar Sandoval
> 
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org
> > [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Omar Sandoval
> > Sent: Monday, May 11, 2015 3:58 PM
> > To: linux-btrfs@vger.kernel.org
> > Cc: Miao Xie; Philip; Omar Sandoval
> > Subject: [PATCH 4/4] Btrfs: fix device replace of a missing RAID 5/6 device
> > 
> > The original implementation of device replace on RAID 5/6 seems to have
> > missed support for replacing a missing device. When this is attempted, we end
> > up calling bio_add_page() on a bio with a NULL ->bi_bdev, which crashes when
> > we try to dereference it. This happens because
> > btrfs_map_block() has no choice but to return us the missing device because
> > RAID 5/6 don't have any alternate mirrors to read from, and a missing device
> > has a NULL bdev.
> > 
> > The idea implemented here is to handle the missing device case separately,
> > which better only happen when we're replacing a missing RAID
> > 5/6 device. We use the new BTRFS_RBIO_REBUILD_MISSING operation to
> > reconstruct the data from parity, check it with
> > scrub_recheck_block_checksum(), and write it out with
> > scrub_write_block_to_dev_replace().
> > 
> > Reported-by: Philip <bugzilla@philip-seeger.de>
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=96141
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> >  fs/btrfs/scrub.c | 145
> > +++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 135 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c index b94694d..a13f91a 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -125,6 +125,7 @@ struct scrub_block {
> >  		/* It is for the data with checksum */
> >  		unsigned int	data_corrected:1;
> >  	};
> > +	struct btrfs_work	work;
> >  };
> > 
> >  /* Used for the chunks with parity stripe such RAID5/6 */ @@ -2164,6
> > +2165,126 @@ again:
> >  	return 0;
> >  }
> > 
> > +static void scrub_missing_raid56_end_io(struct bio *bio, int error) {
> > +	struct scrub_block *sblock = bio->bi_private;
> > +	struct btrfs_fs_info *fs_info = sblock->sctx->dev_root->fs_info;
> > +
> > +	if (error)
> > +		sblock->no_io_error_seen = 0;
> > +
> > +	btrfs_queue_work(fs_info->scrub_workers, &sblock->work); }
> > +
> > +static void scrub_missing_raid56_worker(struct btrfs_work *work) {
> > +	struct scrub_block *sblock = container_of(work, struct scrub_block, work);
> > +	struct scrub_ctx *sctx = sblock->sctx;
> > +	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
> > +	unsigned int is_metadata;
> > +	unsigned int have_csum;
> > +	u8 *csum;
> > +	u64 generation;
> > +	u64 logical;
> > +	struct btrfs_device *dev;
> > +
> > +	is_metadata = !(sblock->pagev[0]->flags & BTRFS_EXTENT_FLAG_DATA);
> > +	have_csum = sblock->pagev[0]->have_csum;
> > +	csum = sblock->pagev[0]->csum;
> > +	generation = sblock->pagev[0]->generation;
> > +	logical = sblock->pagev[0]->logical;
> > +	dev = sblock->pagev[0]->dev;
> > +
> > +	if (sblock->no_io_error_seen) {
> > +		scrub_recheck_block_checksum(fs_info, sblock, is_metadata,
> > +					     have_csum, csum, generation,
> > +					     sctx->csum_size);
> > +	}
> > +
> > +	if (!sblock->no_io_error_seen) {
> > +		spin_lock(&sctx->stat_lock);
> > +		sctx->stat.read_errors++;
> > +		spin_unlock(&sctx->stat_lock);
> > +		printk_ratelimited_in_rcu(KERN_ERR
> > +			"BTRFS: I/O error rebulding logical %llu for dev %s\n",
> > +			logical, rcu_str_deref(dev->name));
> > +	} else if (sblock->header_error || sblock->checksum_error) {
> > +		spin_lock(&sctx->stat_lock);
> > +		sctx->stat.uncorrectable_errors++;
> > +		spin_unlock(&sctx->stat_lock);
> > +		printk_ratelimited_in_rcu(KERN_ERR
> > +			"BTRFS: failed to rebuild valid logical %llu for dev %s\n",
> > +			logical, rcu_str_deref(dev->name));
> > +	} else {
> > +		scrub_write_block_to_dev_replace(sblock);
> > +	}
> > +
> > +	scrub_block_put(sblock);

First of all, I tested a bit more and it looks like I need this here as
well:

+
+	if (sctx->is_dev_replace &&
+	    atomic_read(&sctx->wr_ctx.flush_all_writes)) {
+		mutex_lock(&sctx->wr_ctx.wr_lock);
+		scrub_wr_submit(sctx);
+		mutex_unlock(&sctx->wr_ctx.wr_lock);
+	}
+

I'll resend with this added once I get to the other bug you reported.

> > +	scrub_pending_bio_dec(sctx);
> > +}
> > +
> > +static void scrub_missing_raid56_pages(struct scrub_block *sblock) {
> > +	struct scrub_ctx *sctx = sblock->sctx;
> > +	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
> > +	u64 length = sblock->page_count * PAGE_SIZE;
> > +	u64 logical = sblock->pagev[0]->logical;
> > +	struct btrfs_bio *bbio;
> > +	struct bio *bio;
> > +	struct btrfs_raid_bio *rbio;
> > +	int ret;
> > +	int i;
> > +
> > +	ret = btrfs_map_sblock(fs_info, REQ_GET_READ_MIRRORS, logical,
> > &length,
> > +			       &bbio, 0, 1);
> > +	if (ret || !bbio || !bbio->raid_map)
> > +		goto bbio_out;
> > +
> > +	if (WARN_ON(!sctx->is_dev_replace ||
> > +		    !(bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK))) {
> > +		/*
> > +		 * We shouldn't be scrubbing a missing device. Even for dev
> > +		 * replace, we should only get here for RAID 5/6. We either
> > +		 * managed to mount something with no mirrors remaining or
> > +		 * there's a bug in scrub_remap_extent()/btrfs_map_block().
> > +		 */
> > +		goto bbio_out;
> > +	}
> > +
> > +	bio = btrfs_io_bio_alloc(GFP_NOFS, 0);
> > +	if (!bio)
> > +		goto bbio_out;
> > +
> > +	bio->bi_iter.bi_sector = logical >> 9;
> > +	bio->bi_private = sblock;
> > +	bio->bi_end_io = scrub_missing_raid56_end_io;
> > +
> > +	rbio = raid56_alloc_missing_rbio(sctx->dev_root, bio, bbio, length);
> > +	if (!rbio)
> > +		goto rbio_out;
> > +
> > +	for (i = 0; i < sblock->page_count; i++) {
> > +		struct scrub_page *spage = sblock->pagev[i];
> > +
> > +		raid56_add_scrub_pages(rbio, spage->page, spage->logical);
> > +	}
> > +
> > +	btrfs_init_work(&sblock->work, btrfs_scrub_helper,
> > +			scrub_missing_raid56_worker, NULL, NULL);
> > +	scrub_block_get(sblock);
> > +	scrub_pending_bio_inc(sctx);
> > +	raid56_submit_missing_rbio(rbio);
> > +	return;
> > +
> > +rbio_out:
> > +	bio_put(bio);
> > +bbio_out:
> > +	btrfs_put_bbio(bbio);
> > +	spin_lock(&sctx->stat_lock);
> > +	sctx->stat.malloc_errors++;
> > +	spin_unlock(&sctx->stat_lock);
> > +}
> > +
> >  static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
> >  		       u64 physical, struct btrfs_device *dev, u64 flags,
> >  		       u64 gen, int mirror_num, u8 *csum, int force, @@ -2227,19
> > +2348,23 @@ leave_nomem:
> >  	}
> > 
> >  	WARN_ON(sblock->page_count == 0);
> > -	for (index = 0; index < sblock->page_count; index++) {
> > -		struct scrub_page *spage = sblock->pagev[index];
> > -		int ret;
> > +	if (dev->missing) {
> > +		scrub_missing_raid56_pages(sblock);
> 
> Both non-raid56 and raid56 case have possibility run to here.
> 
> If it is a bad non-raid56 device, call scrub_missing_raid56_pages() for
> a non-raid56 device seems not suitable.
> 
> Since I hadn't read this patch carefully, please ignore if it is not
> a problem

I think the chunk from above should clarify:

+	if (WARN_ON(!sctx->is_dev_replace ||
+		    !(bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK))) {
+		/*
+		 * We shouldn't be scrubbing a missing device. Even for dev
+		 * replace, we should only get here for RAID 5/6. We either
+		 * managed to mount something with no mirrors remaining or
+		 * there's a bug in scrub_remap_extent()/btrfs_map_block().
+		 */
+		goto bbio_out;
+	}

btrfs_scrub_dev() errors out when you attempt to scrub a missing device:

	mutex_lock(&fs_info->fs_devices->device_list_mutex);
	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
	if (!dev || (dev->missing && !is_dev_replace)) {
		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
		return -ENODEV;
	}

So we can't get here for scrub. Now for replace, in scrub_stripe(), we
try to remap the block from the missing device:

			if (is_dev_replace)
				scrub_remap_extent(fs_info, extent_logical,
						   extent_len, &extent_physical,
						   &extent_dev,
						   &extent_mirror_num);

So now let's consider what will happen with replace on the different
RAID levels:

- For RAID 0, the filesystem can't even be mounted
- For RAID 1 and RAID 10, we can always remap the block to another
  mirror
- For RAID 5 and 6, this won't actually remap anything because there
  isn't another mirror! And that's what causes the bug that this patch
  series addresses

Also, consider that before this patch series, if we were to end up in
scrub_stripe() with a missing device, we would crash later when we do a
bio_add_page() on it, and I haven't seen any reports of that.

So I think that this is right, but please correct me if I'm wrong!

> Thanks
> Zhaolei

Thanks,
-- 
Omar
