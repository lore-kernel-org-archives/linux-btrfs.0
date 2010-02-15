From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 11:42:55 -0500
Message-ID: <20100215164255.GG11057@think>
References: <4B7300BE.5000909@hp.com>
 <20100212192804.GE4191@localhost.localdomain>
 <4B77521F.2060105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B77521F.2060105@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to both Jim and Josef for their time on this one.  More comments
below.

On Sat, Feb 13, 2010 at 08:30:07PM -0500, jim owens wrote:
> Josef Bacik wrote:
> >On Wed, Feb 10, 2010 at 01:53:50PM -0500, jim owens wrote:
> >>+	/* traditional 512-byte device sector alignment is the
> >>+	 * minimum required. if they have a larger sector disk
> >>+	 * (possibly multiple sizes in the filesystem) and need
> >>+	 * a larger alignment for this I/O, we just fail later. +	 */
> >>+	if (offset & 511)
> >>+		return -EINVAL;
> >>+
> >>+	/* check memory alignment, blocks cannot straddle pages.
> >>+	 * allow 0-length vectors which are questionable but seem legal.
> >>+	 */
> >>+	for (seg = 0; seg < nr_segs; seg++) {
> >>+		if (iov[seg].iov_len && ((unsigned long)iov[seg].iov_base & 511))
> >>+			return -EINVAL;
> >>+		if (iov[seg].iov_len & 511)
> >>+			return -EINVAL;
> >>+		done += iov[seg].iov_len;
> >>+	}
> >
> >Lets try and keep to what everybody else does and just limit it based on
> >blocksize.  That way we can stay consistent with the rest of the fs's, and we
> >don't have an ugly magic number.
> 
> The problem that I did not explain in my comment is that other fs's
> get the blocksize from 1 device bdi, which usually will be 512.  But
> the btrfs bdi covers all volumes and gives the btrf logical 4096 size.
> If we do what is done in direct-io.c then we only allow access on 4k
> (or in the future larger logical) boundaries.

We can record the smallest alignment while scanning the devices and just
use that.  In general 4K is good enough, although some other database
company might be more worried about smaller numbers.

> 
> While the hard-code is ugly, at least you see it without chasing
> some silly #define.  As I said in my [00], I think we need to go
> to whatever the device supports because people expect that directio
> works in 512 byte multiples.
> 
> This 512-byte stuff dictates a bunch of coding throughout, but I
> felt it was important to do it.  If people really think logical
> fs block size is the way to go, we can delete code.
> 
> Note that my "smaller than a logical block" decision also gates
> code which I did to allow something like a raid 1 where 1 device
> is 512 byte blocks and the other has 4k blocks.  This should work
> fine for cache I/O so I wanted to make it work here too.
> 
> On the other hand, if they make a mixed raid5, any 512-byte access
> to an extent on a 4k drive will be caught as an error (your later
> comment where you think I don't need the check) but any extent
> on the 512-byte disk can be read at the 512-byte boundary.  This
> might be confusing to users but strictly follows directio rules.
> 
> >>+	diocb->rw = rw;
> >>+	diocb->kiocb = kiocb;
> >>+ 	diocb->start = offset;
> >>+	diocb->begin = offset;
> >>+	diocb->terminate = offset + done;
> >
> >This is more of a preference and less of a technical issue, but it would be nice
> >to be able to clean this stuff up so we don't have a bunch of fields that all
> >carry the same information.
> 
> I wanted to do a cleanup... but I was under intense time pressure to
> get (what I though was) a complete working version up to the list.
> Now I have some more time so I'll take a stab at it.
> 
> >>+	diocb->inode = inode;
> >>+	diocb->blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
> >>+
> >
> >We can just take this out of the inode, no sense in carrying blocksize around by
> >itself.
> 
> This is one of those performance trade-offs. I did that because it cuts
> 2 derefs for each time blocksize is used... and there are 31 of them by
> my count.  I am trading 4 bytes of extra memory for less instructions.
> It really would not be 62 instructions because the compiler probably
> will optimize some of them away. We don't go nuts about number of
> instructions like some kernel subsystems, so if people want it the other
> way, I'm fine changing it.

When this kind of optimization matters for btrfs, we'll all be retired
and on the beach ;)  I'd just make a helper that pulls the block size
out of the inode.

> 
> >>+	diocb->umc.user_iov = iov;
> >>+	diocb->umc.work_iov = *iov;
> >
> >Really?  There has to be a better way to get this done.
> 
> Well, if you have an idea, let me know.  I know this stuff is ugly but
> I can not modify the input kiocb and I need to deal with the problem
> that the #%$^ multiple user memory vectors are only 512 byte aligned
> and are likely not on device extent boundaries anyway even if they
> are page aligned.
> 
> While I hope no application writer is insane enough to do it, the
> way the interface is designed, they could say read 16K and hand me
> 32 vectors with each being 512 bytes.
> 
> The only way to simplify memory handling is to be like direct-io.c
> and drive the top level by walking the user vectors.  But that would
> greatly suck for btrfs extent handling, particularly for compression.
> I chose to write ugly vector handling code to make the performance
> the best possible, which is to drive the top level by file extent.

I'm going to have to think harder on that one....there are lots of
tradeoffs to be had there.

> 
> >>+	if (is_sync_kiocb(diocb->kiocb)) {
> >>+		if (diocb->rw == READ)
> >>+			btrfs_dio_read(diocb);
> >>+		else
> >>+			btrfs_dio_write(diocb);
> >>+		done = btrfs_dio_wait(diocb);
> >>+
> >>+		btrfs_dio_free_diocb(diocb);
> >>+		return done;
> >>+	} else {
> >>+		diocb->submit.func = btrfs_dio_aio_submit;
> >>+		btrfs_queue_worker(&BTRFS_I(diocb->inode)->root->fs_info->
> >>+				submit_workers, &diocb->submit);
> >>+		return -EIOCBQUEUED;
> >>+	}
> >>+}
> >>+
> >
> >Again just a nit, but can we do a ret = done, ret = -EIOCBQUEUED and then have
> >
> >return ret;
> >
> >at the bottom of the function.  It just looks nicer.
> 
> I don't have a problem doing it in this instance, just don't expect
> consistency everywhere... sometimes it is easier to understand or
> more efficient or cleaner to have multiple returns.
> 
> >>+static void btrfs_dio_read(struct btrfs_diocb *diocb)
> >>+{
> >>+	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
> >>+	u64 end = diocb->terminate; /* copy because reaper changes it */
> >>+	u64 data_len;
> >>+	int err = 0;
> >>+	int loop = 0;
> >>+
> >>+	/* expand lock region to include what we read to validate
> >>checksum */ +	diocb->lockstart = diocb->start &
> >>~(diocb->blocksize-1);
> >>+	diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
> >>+
> >
> >Ok so we keep track of how much len we write in btrfs_dio_inline_read and such,
> >and those functions only modify lockstart by += len, so we ought to be able to
> >take lockstart and lockend out of the diocb and keep them local, and do
> >lockstart += len we get back from the individual read functions, and then unlock
> >the remaining if we have any at the end.
> 
> Hmm, lockend is easy to make local. I think lockstart has a problem because
> it does not match extent start or data start, but I'll check into
> it.
> 
> >>+getlock:
> >>+	mutex_lock(&diocb->inode->i_mutex);
> >>+		
> >
> >We don't need the i_mutex here.
> 
> I disagree, see following code.  If we don't hold the mutex then
> we can have a new writer between the ordered wait and i_size_read()
> so I would blow up if the file size was less than user-specified
> data_len at ordered wait but grows before I fetch the file size.
> I will not have flushed that new data to disk but will read it.

Using the extent lock should be enough.  File write doesn't use the
extent lock before changing i_size, but we do use the extent lock before
we actually add the metadata pointers.  The end result should be that if
someone races in during an O_DIRECT read, the read will find either extent
pointers for the old i_size (and return zeros like it should) or it will
find extent pointers for the new i_size and everything will be on disk.

We get this for free because we don't update the extent pointers until
the IO is done.

> 
> >>+	/* ensure writeout and btree update on everything
> >>+	 * we might read for checksum or compressed extents
> >>+	 */
> >>+	data_len = diocb->lockend + 1 - diocb->lockstart;
> >>+	err = btrfs_wait_ordered_range(diocb->inode, diocb->lockstart, data_len);
> >>+	if (err) {
> >>+		diocb->error = err;
> >>+		mutex_unlock(&diocb->inode->i_mutex);
> >>+		return;
> >>+	}
> >>+	data_len = i_size_read(diocb->inode);
> >>+	if (data_len < end)
> >>+		end = data_len;
> >>+	if (end <= diocb->start) {
> >>+		mutex_unlock(&diocb->inode->i_mutex);
> >>+		goto fail; /* 0 is returned past EOF */
> >>+	}
> >>+	if (!loop) {
> >>+		loop++;
> >>+		diocb->terminate = end;
> >>+		diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
> >>+	}
> >>+
> >>+	lock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
> >
> >Ok so between teh btrfs_wait_ordered_range and the lock_extent we could have had
> >another ordered extent come in, so here we should be checking to see if there is
> >an ordered extent, and if there is put it and go back to getlock.  Look at
> >btrfs_page_mkwrite() for an example of what I'm talking about.  It would
> >probably be good to move all the size read stuff under the lock_extent(), but I
> >couldn't quite figure out how to do it nicely, so either way.
> >
> >>+	mutex_unlock(&diocb->inode->i_mutex);
> 
> Holding the mutex elegantly fixes that whole problem
> because I am protecting everything from new writes.
> 

But, we're making the performance of the common case (parallel reads)
dramatically slower to close a small race.  Reads and writes are allowed
to race, and the results are allowed to be undefined.  The only
requirement is that we not return garbage (zeros, or good data only).

> >>+/* for consistent eof processing between inline/compressed/normal
> >>+ * extents, an unaligned eof gets special treatment, read into temp
> >>+ * and memcpy to user on completion the part that does not match
> >>+ * the users I/O alignment (for now always 511)
> >>+ */
> >>+static void btrfs_dio_eof_tail(u32 *filetail, int eof, struct btrfs_diocb *diocb)
> >>+{
> >>+	if (eof)
> >>+		*filetail &= 511;
> >>+	else
> >>+		*filetail = 0; /* aligned direct to user memory */ +}
> >
> >Again, blocksize alignment, not 512.
> 
> Again, feature decision required about blocksize.
> 
> >>+		/* device start and length may not be sector aligned or
> >>+		 * user memory address/length vectors may not be aligned
> >>+		 * on a device sector because device sector size is > 512.
> >>+		 * we might have different size devices in the filesystem,
> >>+		 * so retry all copies to see if any meet the alignment.
> >>+		 */
> >>+		iomask = bdev_logical_block_size(btrfs_map_stripe_bdev(extcb->em, dvn)) - 1;
> >>+		if ((extcb->diodev[dvn].physical & iomask) || (dev_left & iomask) ||
> >>+				(!temp_pages &&
> >>+				btrfs_dio_not_aligned(iomask, (u32)dev_left,
> >>+							&extcb->diocb->umc))) {
> >
> >The btrfs_dio_inline_read check doesn't seem necessary since we did the
> >alignment check in btrfs_direct_IO, you can just kill it.
> 
> Nope, I can only kill it if we say all devices are forced to be
> the same blocksize and we know what that is in btrfs_direct_IO.
> 
> >>+
> >>+static void btrfs_dio_put_next_in(struct bio_vec *vec,
> >>+				struct btrfs_dio_extcb *extcb)
> >>+{
> >>+	while (vec->bv_len) {
> >>+		unsigned int bv_len;
> >>+		if (extcb->bo_frag) {
> >>+			/* current bi_io_vec is part of this put-back */
> >>+			vec->bv_len += extcb->bo_frag;
> >>+			extcb->bo_frag = 0;
> >>+			/* else put-back begins at previous bi_io_vec or bio */
> >>+		} else if (extcb->bo_bvn) {
> >>+			extcb->bo_bvn--;
> >>+		} else {
> >>+			extcb->bo_now--;
> >>+			extcb->bo_bvn = extcb->order[extcb->bo_now]->bi_vcnt - 1;
> >>+		}
> >>+
> >>+		bv_len = extcb->order[extcb->bo_now]->bi_io_vec[extcb->bo_bvn].bv_len;
> >>+		if (vec->bv_len < bv_len) {
> >>+			extcb->bo_frag = vec->bv_len;
> >>+			vec->bv_len = 0;
> >>+			return;
> >>+		}
> >>+		vec->bv_len -= bv_len;
> >>+	}
> >>+}
> >
> >Again, this is all quite scary and is very fragile, I would hate to have to try
> >and figure out what was going wrong in here.  Is there a way we can do this less
> >complicated?
> 
> I'm afraid to tell you, but this is the simplified version.
> 
> I would hope not fragile, but it is scary.

Could you please have a few more pages of notes on how the workflow
works? ;) It'll help later on.

> 
> Again, this is all about those painful user memory addresses not being
> aligned with our logical blocks, so they can cross multiple devices
> and within 1 device bio they can cross 2 bio vecs because the user
> memory is only 512 byte aligned, not page-aligned, thus there is part
> of the block in one page and part in another page.  And if they do that,
> every logical block in the read is in 2 pages instead of 1... arrgh!
> It would all be so easy if we did not transfer into user memory or
> did not do checksums.
> 
> Other than only allowing logical block bounded transfers, I did not
> think of a solution to make it simple.  But ideas are always welcome.
> 
> >>+	/* ugly again - compressed extents can end with an implied hole */
> >>+	if (!extcb->error && extcb->icb.out_len != len) {
> >>+		while (extcb->umc.todo) {
> >>+			struct bio_vec uv;
> >>+			char *out;
> >>+
> >>+			extcb->error = btrfs_dio_get_user_bvec(&uv, &extcb->umc);
> >>+			if (extcb->error)
> >>+				goto fail;
> >>+			out = kmap_atomic(uv.bv_page, KM_USER0);
> >>+			memset(out + uv.bv_offset, 0, uv.bv_len);
> >>+			kunmap_atomic(out, KM_USER0);
> >
> >Umm, I'm just going to close my eyes and pretend this is necessary.
> 
> This one is another one I blame on Chris ;)
> 
> I found this wonderful surprise via fsx after getting past that other
> wonderful surprise with the inline in a large file.
> 
> But on the other hand, this tiny drop of ugly in my ocean of ugly
> is better than changing other parts of btrfs.
> 
> >>+static int btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb)
> >>+{
> >>+	extcb->icb.workspace = NULL;
> >>+	extcb->tmpbuf = NULL;
> >>+	extcb->tmpbuf_size = 0;
> >>+	return 0;
> >>+}
> >>+
> >
> >Can change this to just be a void
> 
> yes!!!, finally an easy one.
> 
> >>+/* submit kernel temporary pages for compressed read */
> >>+static int btrfs_dio_add_temp_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb,
> >>+				int dvn)
> >>+{
> >>+	while (extcb->diodev[dvn].vecs && *dev_left) {
> >>+		unsigned int pglen = min_t(long, *dev_left, PAGE_SIZE);
> >>+		struct page *page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
> >>+
> >>+		if (!page)
> >>+			return -ENOMEM;
> >>+		if (!bio_add_page(extcb->diodev[dvn].bio, page, pglen, 0)) {
> >>+			extcb->diodev[dvn].vecs = 0;
> >>+			page_cache_release(page);
> >>+			return 0;
> >>+		}
> >>+		extcb->csum_pg1 = page;
> >>+		extcb->iolen += pglen;
> >>+		extcb->diodev[dvn].physical += pglen;
> >>+		*dev_left -= pglen;
> >>+		extcb->diodev[dvn].vecs--;
> >>+	}
> >>+
> >>+	return 0;
> >>+}
> >
> >Ok so I assume this is you have all of the kmap horrors I keep seeing?  Is it
> >because we read the compressed data into these temporary pages, and then
> >uncompress the data into user pages?  I'd just like to know for my own
> >edification.
> 
> Yes, compression is the main use of the temp pages, to hold the compressed
> stuff which can be smaller or bigger than the actual user read.  I have to
> do the read from disk into the temp pages, which becomes the source to the
> zlib_inflate and the user memory is the output. The extra complication here
> is that we can be spanning devices, the "dvn", even for a small extent
> because it is packed into the chunk, so you might need 28k of compressed data
> but 12k is at the end of the dev0 stripe and 16k is at the beginning of the
> dev1 stripe.  The "extcb->csum_pg1 = page;" thing is for the other use of
> temp pages, to read the part of the logical block at the beginning or/and
> end of uncompressed reads that the user did not want so we can checksum it.

I think the temp buffer setup is the best place to start for
O_DIRECT + compressed.

-chris
