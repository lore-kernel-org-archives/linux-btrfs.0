Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18836 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3IIGQF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 02:16:05 -0400
Date: Mon, 9 Sep 2013 14:15:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v6 5/5] Btrfs: online data deduplication
Message-ID: <20130909061541.GA2134@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
 <1375950946-5470-6-git-send-email-bo.li.liu@oracle.com>
 <20130902161942.GC23113@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130902161942.GC23113@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On Mon, Sep 02, 2013 at 06:19:42PM +0200, David Sterba wrote:
> I wanted to only comment on the ioctl and interface to userspace bits,
> but found more things to comment in the kernel code.

Sorry for the late reply(I'm out for vacation these days).

> 
> On Thu, Aug 08, 2013 at 04:35:45PM +0800, Liu Bo wrote:
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -94,6 +95,9 @@ struct btrfs_ordered_sum;
> >  /* for storing balance parameters in the root tree */
> >  #define BTRFS_BALANCE_OBJECTID -4ULL
> >  
> > +/* dedup tree(experimental) */
> > +#define BTRFS_DEDUP_TREE_OBJECTID 9ULL
> 
> 9 now conflicts with the uuid tree, when you update the patch, please
> put the dedup tree definition right next after the uuid tree.
> 
> I've noticed that the lockdep annotation is also missing from disk-io.c)
> and the symbolic tree name in include/trace/events/btrfs.h as well.

Good point, I just saw that uuid tree has been merged into -next.

> 
> > +enum btrfs_dedup_type {
> > +	BTRFS_DEDUP_SHA256 = 0,
> > +	BTRFS_DEDUP_LAST = 1,
> > +};
> > +
> > +static int btrfs_dedup_lens[] = { 4, 0 };
> > +static int btrfs_dedup_sizes[] = { 32, 0 };	/* 256bit, 32bytes */
> 
> This is a bit confusing, what's the difference between 'len' and 'size'
> here.

Hmm, I admit that it's ugly, as we want to store the last 64bit of
256bit hash value as key.offset, an array of u64[4] is used and
the last 64bit will be array[3], any better ideas will be appreciated.

> 
> > +struct btrfs_dedup_item {
> > +	__le64 len;	/* disk length of dedup range */
> > +	u8 type;
> > +	u8 compression;
> > +	u8 encryption;
> > +	__le16 other_encoding; /* spare for later use */
> > +
> > +	/* hash/fingerprints go here */
> > +} __attribute__ ((__packed__));
> > +
> > +struct btrfs_dedup_hash {
> > +	/* hash algorithm */
> > +	int type;
> > +	u64 bytenr;
> > +	u64 num_bytes;
> > +	int compression;
> 
> Layout of this structure is a bit suboptimal, there is a 4 byte hole
> after type and compression, and you can use u8 types for both, but as
> this would leave another 6b hole after, using ints is ok, so the final
> layout should preferrably look like
> 
> {
> 	u64 bytenr;
> 	u64 num_bytes;
> 	int type;
> 	int compression;
> 
> 	u64 hash[];
> };

Looks good, will update it.

> 
> > +
> > +	/* last field is a variable length array of dedup hash */
> > +	u64 hash[];
> > +};
> > +
> > @@ -1967,6 +2027,7 @@ struct btrfs_ioctl_defrag_range_args {
> >  #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
> >  #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
> >  #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
> > +#define BTRFS_MOUNT_DEDUP		(1 << 24)
> >  
> >  #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
> >  #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2184,6 +2194,8 @@ int open_ctree(struct super_block *sb,
> >  	atomic64_set(&fs_info->tree_mod_seq, 0);
> >  	fs_info->sb = sb;
> >  	fs_info->max_inline = 8192 * 1024;
> > +	fs_info->dedup_bs = 8192;
> > +	fs_info->dedup_type = BTRFS_DEDUP_SHA256;
> >  	fs_info->metadata_ratio = 0;
> >  	fs_info->defrag_inodes = RB_ROOT;
> >  	fs_info->free_chunk_space = 0;
> > @@ -2282,6 +2294,7 @@ int open_ctree(struct super_block *sb,
> >  	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> >  	mutex_init(&fs_info->dev_replace.lock_management_lock);
> >  	mutex_init(&fs_info->dev_replace.lock);
> > +	mutex_init(&fs_info->dedup_ioctl_mutex);
> >  
> >  	spin_lock_init(&fs_info->qgroup_lock);
> >  	mutex_init(&fs_info->qgroup_ioctl_lock);
> > @@ -2457,6 +2470,14 @@ int open_ctree(struct super_block *sb,
> >  		goto fail_alloc;
> >  	}
> >  
> > +	fs_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
> 
> Isn't this supposed to use fs_info->dedup_type somehow? This is harcoded
> to sha256 and it's the only one available now, but when the defines and
> variables are there, please do use them

Okay.

> 
> > +	if (IS_ERR(fs_info->dedup_driver)) {
> > +		pr_info("Cannot load sha256 driver\n");
> > +		err = PTR_ERR(fs_info->dedup_driver);
> > +		fs_info->dedup_driver = NULL;
> > +		goto fail_alloc;
> > +	}
> > +
> >  	btrfs_init_workers(&fs_info->generic_worker,
> >  			   "genwork", 1, NULL);
> >  
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -1102,8 +1102,16 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
> >  		key.offset = parent;
> >  	} else {
> >  		key.type = BTRFS_EXTENT_DATA_REF_KEY;
> > -		key.offset = hash_extent_data_ref(root_objectid,
> > -						  owner, offset);
> > +
> > +		/*
> > +		 * we've not got the right offset and owner, so search by -1
> > +		 * here.
> > +		 */
> > +		if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID)
> > +			key.offset = -1;
> 
> offset is u64

Okay.

> 
> > +		else
> > +			key.offset = hash_extent_data_ref(root_objectid,
> > +							  owner, offset);
> >  	}
> >  again:
> >  	recow = 0;
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > +static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
> > +			    struct page *locked_page, u64 start, u64 end,
> > +			    get_extent_t *get_extent, int mode,
> > +			    struct btrfs_dedup_hash *hash)
> > +{
> > +	int page_started = 0;
> > +	unsigned long nr_written = 0;
> > +	int ret;
> > +
> > +	lock_extent(tree, start, end);
> > +
> > +	/* allocate blocks */
> > +	ret = cow_file_range_dedup(inode, locked_page, start, end,
> > +				   &page_started, &nr_written, 0, hash);
> > +
> > +	/* JDM XXX */
> 
> What? :)

I'm going to just clean it up as it comes from the origial code and I
don't know what it is, either :-)

> 
> > +
> > +	/*
> > +	 * if page_started, cow_file_range inserted an
> > +	 * inline extent and took care of all the unlocking
> > +	 * and IO for us.  Otherwise, we need to submit
> > +	 * all those pages down to the drive.
> > +	 */
> > +	if (!page_started && !ret)
> > +		extent_write_locked_range(tree, inode, start, end, get_extent,
> > +					  mode);
> > +	else if (ret)
> > +		unlock_page(locked_page);
> > +
> > +	return ret;
> > +}
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -361,6 +362,8 @@ static match_table_t tokens = {
> >  	{Opt_check_integrity_including_extent_data, "check_int_data"},
> >  	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
> >  	{Opt_fatal_errors, "fatal_errors=%s"},
> > +	{Opt_dedup_bs, "dedup_bs=%s"},
> > +	{Opt_dedup, "dedup"},
> 
> What's the expected usage? You have the ioctl to enable/disable dedup
> for that, so if it's enabled via a mount option it is equivalent to
> calling the 'dedup enable' after mount, ok?
> 

Not true, there're two stages we need -- dedup ioctl is used to create/delete
dedup tree, while dedup mount options is to enable/disable the dedup feature,
that is, if we don't mount with the options, dedup won't happen on writes.

> I think dedup is kind of similar to quotas, you enable them and want
> them to be persistent once enabled, or disabled upon an explicit
> request.
> 
> Setting the blocksize via mount option looks more like a temporary
> solution before we have persistent per-object properties, here it would
> be eg. "filesystem.dedup_block_size".

So the goal is that we need a flexible way to enable/disable dedup
feature.

It's true that the dedup tree is similar to quota tree -- it's persistent
once it's created, but the difference is that dedup happens on every
write and we usually don't want it to be in default use.

> 
> But once the mount option is there, it's much harder to remove it so we
> should not introduce it at all. For now I suggest to add another mode
> for the dedup ioctl to set the block size.

I agree, it's tradeoff though.

> 
> Another question is whether to enable different block sizes for
> different subvolumes, then this should be reflected in the ioctl
> interface.
> 

Yeh, I'm planning to do this after all the dedup mechanism is built up :)

> 
> >  	{Opt_err, NULL},
> >  };
> >  
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -374,6 +374,10 @@ struct btrfs_ioctl_get_dev_stats {
> >  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> >  };
> >  
> > +/* deduplication control ioctl modes */
> > +#define BTRFS_DEDUP_CTL_REG 1
> > +#define BTRFS_DEDUP_CTL_UNREG 2
> 
> And the whole point of my mail was to tell you that for consistency with
> the userspace tools I suggest to rename the ioctl defines to
> 
> BTRFS_DEDUP_CTL_REG -> BTRFS_DEDUP_CTL_ENABLE
> BTRFS_DEDUP_CTL_UNREG -> BTRFS_DEDUP_CTL_DISABLE
> 
> but it turned out to be a bit longer :)
> 

Thanks for all the comments!

-liubo

> > +
> >  #define BTRFS_QUOTA_CTL_ENABLE	1
> >  #define BTRFS_QUOTA_CTL_DISABLE	2
> >  #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
