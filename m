Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795728057;
	b=blooC+6fhvwAjrEHil5/GSyFj5y6pWBnTnJLy1I9YGV8Z3BzYZi21jhw3LQwDdPZys1v
	 YXjMqXXIiGdClGRhOSl/RND0HitN1/QWJE4NZ5lsho88827RJPmYIO+VmANmV4RW/viS2
	 lScHJCjwXli033jjWkim7oKxKIeyYIBqAd3aH8RMqNiVRtzBFTCxucv4n7Ll10YopjAC0
	 F5bNfYVk1HEOyFmjBq/Kpwuc7a8y84Qh7J7ubYFY88TXJ+C6iyS3zFpGwRSHQVSCsKihF
	 Q3qDrYLZCYGkvpTuoTCEuiwX/BFXVtYq4PsYRzeRgseoEHeumhAdmOIlpYJeFHbo9FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795728057;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=H74XReHquXFHYXYmCJoSEVHWtChoeBhqUlFPNQb3/wk=;
	b=FfcbDOGdjGUybQHTODG2FHmXmpe5lvlrHOAmkn4cRtkIbG+Q4h9lIM9us/i/nFfrIG6j
	 Dg1Wg7hHS9qcvAuIwtREBYbrCuPqHci676wAT7GitZ+2pRVKgyCPzSuAO5mJL0btZDXO0
	 cyozpHR5tl1MXMdA1iTuioHg9AzSHBNl0DinhNIMIMuMO+G8GJBB3+p6egD1lMe9TFyrg
	 WFneNKiOgpzAdjbtY8+SgCYOqGA6TrTHw4WC7eq6eAs424ydpn7Ti1c/xOmU0xtv8dI5B
	 BasP7ot9P32O9p9oWPjd0XvWnjCERS6xMT2w2eoRNgDOhDF1S3AwOjNF5pLQw25YjwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GH9uiWAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37762606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GH9uiWAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27041F000C1;
	Thu, 26 Nov 2026 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728057;
	bh=H74XReHquXFHYXYmCJoSEVHWtChoeBhqUlFPNQb3/wk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GH9uiWAzox8JtYGbWXetFWHxTWPxzrgT2YrW2B/aFIJE8udcEE7ahntKUrdGDJmyH
	 /2Y00Uw4hffedURvcx7Pm5oUCYcO+VKG/ZBih/Y2cZEcs4IVNgW5qU12Aje32hfcWl
	 BSzPvwJH3As2syAuMktViAP35NwCauN3OSeCP4Rs6XYEzv7MZbkdTjnugPtV/A63cu
	 R2NLCqY4D/YfsOk96zEzxhy4pUjMCI1TXqoqyO+7oZ1WiXJicQSch36Yhu5B7+SdyW
	 JD4cjMNUAQi/hYSqwf2fsE6LDxM7iAUhIcYV1dpbJ9kDc3+7PwMXqPjgVN1ks+ADMp
	 a8zGzNbaE86XQ==
Message-ID: <c736ab6c-eb70-483a-ad3b-e0e3bc31da29@kernel.org>
Date: Fri, 27 Nov 2026 06:20:54 +0900
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] btrfs: zoned: allocate a new block-group per file
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126132820.570379-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 22:28, Johannes Thumshirn wrote:
> On zoned filesystems all data writers share the first active block-group
> with free space, so extents of parallel writers interleave. This is
> causing high fragmentation in the filesystem, that also potentially
> increases the need for garbage collection.
> 
> If the allocation hint doesn't hit an active block-group with enough
> space, e.g. for a new file or after its block-group filled up, and an
> active zone can be spared, allocate from an empty block-group instead.
> If no zone can be spared, spread allocations round-robin over the active
> block-groups. Never finish a zone for this.
> 
> On an expample null_blk device with 64M zones, max 12 active zones this
> results in:
> 
> Test                          files/zone   extents/file
> 5 parallel O_DIRECT writers   5.0 -> 1.09  966 -> 74
> 4 files appended round-robin  4.0 -> 1.0   192 -> 3
> 
> Buffered parallel writers improve less (4.45 -> 3.09 files per zone):
> block-groups with a leftover smaller than the next allocation keep their
> active zone.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/extent-tree.c       | 36 ++++++++++++++++++++++++++++++------
>  fs/btrfs/extent-tree.h       |  3 +++
>  fs/btrfs/zoned.c             | 31 +++++++++++++++++++++++++++++++
>  fs/btrfs/zoned.h             |  7 +++++++
>  include/trace/events/btrfs.h | 12 ++++++++----
>  5 files changed, 79 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0541b38129e5..7169f296a523 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3766,6 +3766,11 @@ enum btrfs_loop_type {
>  	LOOP_NO_EMPTY_SIZE,
>  };
>  
> +static inline bool want_fresh(const struct find_free_extent_ctl *ffe_ctl)

This is a really bad name... I want fresh beer, but I am guessing that is not
what this is reporting :)

> +{
> +	return ffe_ctl->want_fresh && ffe_ctl->loop <= LOOP_ALLOC_CHUNK;
> +}
> +
>  static inline void
>  btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
>  {
> @@ -4068,7 +4073,8 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
>  
>  	/* Check RO and no space case before trying to activate it */
>  	spin_lock(&block_group->lock);
> -	if (block_group->ro || btrfs_zoned_bg_is_full(block_group)) {
> +	if (block_group->ro || btrfs_zoned_bg_is_full(block_group) ||
> +	    (want_fresh(ffe_ctl) && block_group->alloc_offset)) {
>  		ret = 1;
>  		/*
>  		 * May need to clear fs_info->{treelog,data_reloc}_bg.
> @@ -4102,6 +4108,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
>  	       fs_info->data_reloc_bg == 0);
>  
>  	if (block_group->ro ||
> +	    (want_fresh(ffe_ctl) && block_group->alloc_offset) ||
>  	    (!ffe_ctl->for_data_reloc &&
>  	     test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags))) {
>  		ret = 1;
> @@ -4259,6 +4266,13 @@ static int can_allocate_chunk_zoned(struct btrfs_fs_info *fs_info,
>  	if (!(ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA))
>  		return 0;
>  
> +	if (ffe_ctl->want_fresh) {
> +		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags))
> +			return 0;
> +		else
> +			return 1;

		return !btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags);
?

At the very least, drop the else please.

Also, how is btrfs_can_spare_active_zone() and btrfs_can_activate_zone() differ?
The function names kind of suggest they are doing the same thing. So cannot we
get just one function being defined to test if we can activate a zone that is
not already active, that is, a free empty zone?

Otherwise, this makes everything a lot more complicated here and hard to follow.

> +	}
> +
>  	/* If we can activate new zone, just allocate a chunk and use it */
>  	if (btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
>  		return 0;
> @@ -4530,13 +4544,22 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
>  	}
>  
>  	if (list_entry_is_head(block_group, &fs_info->zone_active_bgs,
> -				active_bg_list))
> -		block_group = fallback;
> +				active_bg_list)) {
> +		if (btrfs_can_spare_active_zone(fs_info, ffe_ctl->flags)) {
> +			ffe_ctl->want_fresh = true;
> +			block_group = NULL;
> +		} else {
> +			block_group = fallback;
> +			if (block_group)
> +				list_move_tail(&block_group->active_bg_list,
> +					       &fs_info->zone_active_bgs);
> +		}
> +	}
>  
> -	if (block_group)
> -		ffe_ctl->hint_byte = block_group->start;
> +	ffe_ctl->hint_byte = block_group ? block_group->start : 0;
>  
> -	trace_prepare_allocation_zoned(fs_info, hint, block_group);
> +	trace_prepare_allocation_zoned(fs_info, hint, block_group,
> +				       ffe_ctl->want_fresh);
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  
>  	return 0;
> @@ -4609,6 +4632,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
>  	ffe_ctl->cached = 0;
>  	ffe_ctl->max_extent_size = 0;
>  	ffe_ctl->total_free_space = 0;
> +	ffe_ctl->want_fresh = false;
>  	ffe_ctl->found_offset = 0;
>  	ffe_ctl->policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
>  	ffe_ctl->size_class = btrfs_calc_block_group_size_class(ffe_ctl->num_bytes);
> diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
> index ff330d4896d6..50e0a16d2d8d 100644
> --- a/fs/btrfs/extent-tree.h
> +++ b/fs/btrfs/extent-tree.h
> @@ -87,6 +87,9 @@ struct find_free_extent_ctl {
>  
>  	/* Size class of block groups to prefer in early loops */
>  	enum btrfs_block_group_size_class size_class;
> +
> +	/* Allocate a fresh block-group */
> +	bool want_fresh;
>  };
>  
>  enum btrfs_inline_ref_type {
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 216ca214d26a..4670db6a4fc8 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -67,6 +67,8 @@
>  
>  #define SUPER_INFO_SECTORS	((u64)BTRFS_SUPER_INFO_SIZE >> SECTOR_SHIFT)
>  
> +#define BTRFS_ZONED_GC_SPARE_ZONES	1 /* XXX: This needs a bump when zgc-final is merged */
> +
>  static void wait_eb_writebacks(struct btrfs_block_group *block_group);
>  static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written);
>  
> @@ -2721,6 +2723,35 @@ void btrfs_zone_finish_relocated(struct btrfs_block_group *block_group)
>  			   block_group->start, ret);
>  }
>  
> +bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags)
> +{
> +	struct btrfs_device *device;
> +	const int needed = (flags & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
> +	bool ret = false;
> +
> +	if (test_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags))
> +		return false;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices, dev_list) {
> +		struct btrfs_zoned_device_info *zinfo = device->zone_info;
> +
> +		if (!device->bdev || !zinfo || !zinfo->max_active_zones ||
> +		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
> +			continue;
> +
> +		if (atomic_read(&zinfo->active_zones_left) >=
> +		    READ_ONCE(zinfo->reserved_active_zones) + needed +
> +		    BTRFS_ZONED_GC_SPARE_ZONES) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
>  {
>  	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
> diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
> index 2225090839f3..2c17c31437ca 100644
> --- a/fs/btrfs/zoned.h
> +++ b/fs/btrfs/zoned.h
> @@ -103,6 +103,7 @@ int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_fin
>  void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
>  int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num_bytes);
>  void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq);
> +bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info, u64 flags);
>  
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  struct zone_info;
> @@ -299,6 +300,12 @@ static inline int btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct s
>  	return 0;
>  }
>  
> +static inline bool btrfs_can_spare_active_zone(struct btrfs_fs_info *fs_info,
> +					       u64 flags)
> +{
> +	return false;
> +}
> +
>  #endif
>  
>  static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 1378e697a46f..830927b185a4 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -2244,15 +2244,17 @@ TRACE_EVENT(btrfs_find_free_extent_have_block_group,
>  TRACE_EVENT(prepare_allocation_zoned,
>  
>  	TP_PROTO(const struct btrfs_fs_info *fs_info,
> -		 u64 hint_byte, const struct btrfs_block_group *block_group),
> +		 u64 hint_byte, const struct btrfs_block_group *block_group,
> +		 bool want_fresh),
>  
> -	TP_ARGS(fs_info, hint_byte, block_group),
> +	TP_ARGS(fs_info, hint_byte, block_group, want_fresh),
>  
>  	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	hint_byte		)
>  		__field(	u64,	bg_start		)
>  		__field(	u64,	bg_flags		)
>  		__field(	bool,	hit			)
> +		__field(	bool,	want_fresh		)
>  	),
>  
>  	TP_fast_assign_btrfs(fs_info,
> @@ -2262,12 +2264,14 @@ TRACE_EVENT(prepare_allocation_zoned,
>  		__entry->hit		= block_group && in_range(hint_byte,
>  						block_group->start,
>  						block_group->length);
> +		__entry->want_fresh	= want_fresh;
>  	),
>  
> -	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d",
> +	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d want_fresh=%d",
>  			__entry->hint_byte, __entry->bg_start, __entry->bg_flags,
>  			__print_flags((unsigned long)__entry->bg_flags, "|",
> -				BTRFS_GROUP_FLAGS), __entry->hit)
> +				BTRFS_GROUP_FLAGS), __entry->hit,
> +			__entry->want_fresh)
>  );
>  
>  DECLARE_EVENT_CLASS(btrfs__reserve_extent,


-- 
Damien Le Moal
Western Digital Research
