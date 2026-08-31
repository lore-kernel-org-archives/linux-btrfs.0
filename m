Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810BD37DEBB
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 22:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214148; cv=none; b=uUxmGyuBioI8UErEmYQoHm58ZYm7+Wx15UXTw8NqGkk74ewjZ8FnQNfjl+1oiEeryhWYVDEXmJUN9AHj/eOURbjIL7g3hg4KGa0ttMIxeg8R6LPcbEwYFCiHUfwLbIUkU8RYnwrrRCCy8HnJkL9HDVfGeihv35OHHdxRPpqJvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214148; c=relaxed/simple;
	bh=6ReJc4mBZcTY53AgrnLeDlUjdUZyZbzs0qcOCSkMKRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xal0u+Hfbf4lqCtmNw+RwNFUo+Ftr0GtlQZKu3sYdraRb+/DL7VdC5+1TvJvknn2jyL/4NyYFbeGFK+0UcuYAjOd8Ma28N5ioPTOcZNWrQJ3+XVbA/adeCmGbtCfMq4oGr5Ac8S3uQ3rs3/0F3FKzs534CzS3uP9zbdgLgZYNc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=UMmPXeDw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=k/NlsJzH; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="UMmPXeDw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="k/NlsJzH"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 7FD78EC024D;
	Mon, 31 Aug 2026 18:09:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 31 Aug 2026 18:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788214145; x=1788300545; bh=cmtOGIl1Cd
	GU3uymyNHcoIkInxisO1F7tLmFGpcXDWI=; b=UMmPXeDwofXp9j4geI6rcWNdgz
	Wm+dfzVMz3bzWRziXoVmEMcHWHXa7NDrT2Rj89uKEox9ycFlo1ZcqqG4syHGXrku
	dduk9DTJ7g0rdXF+9wPSSg1S2fw6fLw9pSNJ3UCWarKzekLUluYad8QMboEMRjdI
	6wKV6xl/SpE6PiVyS9qtMoLQt/Z+pZgTNy/Bw2uqmHU4wGBMEiEsiH08od65GLOX
	gR7LMt/wudbGsOa9uLZmJ3r27i+Z9pmnNOUR5HkoUvOHVoxqcVYNzILlG5z2+jCQ
	cPNwq/JDgnFLRpuEPQnmK+IFCXpPJKj3xJWxoeCWAJPSiDC5/J5dHpgMenFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788214145; x=1788300545; bh=cmtOGIl1CdGU3uymyNHcoIkInxisO1F7tLm
	FGpcXDWI=; b=k/NlsJzHg2LVeYOolr9BxcTp3RaZZfBXLqcxUb9hcl4oIvVj2Bp
	3JRzaUmf5Nw700BMdsDvi2KetnMTUuFNz+Xj5KnjcxM3HE5z0poXS5eH3Pwahm5f
	KC6EIMItMHbUMjw73+cNP37kYPolm5iVmQJfVJQhTABUTd9zE24kXHlkPwFX1Qjk
	kvtIdeW3SDCAVN2Qqx20sX2upBhVHIRAP+WkAmoPrRSWX5PrliD1smZVgqcZ0Tj+
	XeJta8Db9d2aGsqvI+2AzvWFtl/p7DpcfYOwv8qOaRvbaV0uF/1Df7EhJCyxKaE3
	gI28+FpZQD3mlGxdBb/kqKMOYtWh3oAAbwg==
X-ME-Sender: <xms:gfuVajbx8njBa3ofEUxE-ocl1TSo8Ehk7-_1tDMuT8pA7GJ7o96Khg>
    <xme:gfuVap0vwafSAp9luongH0paGeSeNBRtqZ3mEHwfRCv2-nTOiGiYnr2qBP5Ipe2w0
    L422d1Fo-wV81FvPp52jg4xbJ7Y5jd2y_JzeODi4NovYGd43WJWc3dD>
X-ME-Received: <xmr:gfuVajVcQj2oRUH6L1G3_PkQzNGnH-n7NqGd1wR1K4VTX8GThQsoBnWfQD_AZWfd65UJBU2T90RS7PMWepFUCR7Yars>
X-ME-Proxy-Cause: dmFkZTFEApo1oFNeOCaa+cfzO0L33x33Q5Hd3Ut4ZzoPpQDPvQn81sArrDcO5brf/ZQaMr
    2xWiDxkwVJlhC/IsV5c++DOZd7Ez5J/kWRfVE+d07D6oHQdXImLp+YiqslnZxIA8nZyXT+
    vfmi4sWSGWodmJbkn0AmXCRLwKlHFUcRSHW2sgO2E/IlmXrGP2SseU293CCsqYqSlZsNio
    N70A2sn44fZaolq9R8K8G+oLuLd4JaocrxKIVA/POQc1lhnjArk+/PbcE6vqriaRdLt82F
    NfF2/x+cdcqQ0Jn79eInclbGtKNZ3fsMtJss2hcwWncIXXBvdGXOzcIwn5PDIWTCbylub1
    xFSeiivfiPktUcayj29B3gtOp36GqmHsOIRVNclp1Lzjh4Sx/fedTwnqmpo5af76wFQUpA
    jX1kC7NkII8tuBYo7oh1lm64q6g6cOYVArKg7Eb4+HF0JMG9SL8+PZA/ASbmch3geIxFtq
    qRbWt1h0BLwMA9Pr5vqjVeZZMObKqzyAGuxWA2eA7U6JJySRVpwB8iJB8a4RY3+UWFYOE3
    pqaCW4szSwyMgOPj9SbMGcmg/QBRJ97CwH4iE0JrBOBCZK1QjjCUusTpk9jiQShFSdEIiX
    9PgDVxYfsfX90ad17lsxE/TUph+tTXQqbC2F4SyLnlkFOpoXzd8VQDLyGt7g
X-ME-Proxy: <xmx:gfuVajVkv5OfC2RXtpwpYse-g-UabfY21t8E3OVWgZ-2LrqztIztMg>
    <xmx:gfuVaifEwp3-ppAPWbNmoqE2w1AM20nw2J3CJRxKVYwV-hkWhnggvA>
    <xmx:gfuVasUPrtiiKkes6NPFoYM4uh80MfU7GmwDKA1GxPWIYS6-yWpo3A>
    <xmx:gfuVare-tnEalANE3ps6zRXa9whYET9thmUbUwjWB3dFWjnMPhSV-g>
    <xmx:gfuVakhP2y1gkKERiaE0sGLYWz9e2gYGRKrQJ4O3PYbtuq4OauNlqF6p>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 18:09:04 -0400 (EDT)
Date: Mon, 31 Aug 2026 15:08:25 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, ZhengYuan Huang <gality369@gmail.com>
Subject: Re: [PATCH] btrfs: tree-checker: reject file extent items for
 special files
Message-ID: <20260831220825.GF325502@zen.localdomain>
References: <b2dd29edaf1c476df248eb433ec2edf1771bcb96.1787029007.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2dd29edaf1c476df248eb433ec2edf1771bcb96.1787029007.git.wqu@suse.com>

On Tue, Aug 18, 2026 at 02:27:11PM +0930, Qu Wenruo wrote:
> File extent items are only utilized by regular files or symlinks, other
> files like directory/char/block/fifo/sock files should not have any file
> extent item.
> 
> Previously we were unable to reject such cases, as the inode item may not
> be in the same leaf.
> But we already have @prev_key in check_leaf_item(), this means we just
> need a new way to pass the mode of the previously hit inode item, then
> we can detect such problems.
> 
> Introduce a new and tiny helper structure, last_inode_info, to record
> the last hit inode number and its mode, and keep it across the whole
> leaf.
> Then if we hit a file extent item, and the inode item is in the same
> leaf, we can refer to that last_inode_info to determine if we need to
> reject the file extent item.
> 
> Now with the following corrupted fs tree, the kernel can safely reject
> the leaf:
> 
> 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
> 		generation 3 transid 9 size 12 nbytes 16384
> 		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
> 		sequence 1 flags 0x0(none)
> 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
> 		index 0 namelen 2 name: ..
> 	item 2 key (256 DIR_ITEM 496027801) itemoff 16075 itemsize 36
> 		location key (257 INODE_ITEM 0) type FILE
> 		transid 9 data_len 0 name_len 6
> 		name: foobar
> 	item 3 key (256 DIR_INDEX 2) itemoff 16039 itemsize 36
> 		location key (257 INODE_ITEM 0) type FILE
> 		transid 9 data_len 0 name_len 6
> 		name: foobar
> 	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
> 		generation 9 transid 9 size 8192 nbytes 8192
> 		block group 0 mode 60600 links 1 uid 0 gid 0 rdev 0
> 		                   ^^ This is BLK type, not REG.
> 		sequence 2 flags 0x0(none)
> 	item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
> 		index 2 namelen 6 name: foobar
> 	item 6 key (257 EXTENT_DATA 0) itemoff 15810 itemsize 53
> 		generation 9 type 1 (regular)
> 		extent data disk byte 13631488 nr 8192
> 		extent data offset 0 nr 8192 ram 8192
> 		extent compression 0 (none)
> 		extent encryption 0
> 
> With the patch, kernel will reject it with the following tree-checker
> errors:
> 
>  BTRFS critical (device loop0): corrupt leaf: root=5 block=30408704 slot=6 ino=257 file_offset=0, invalid file extent item, should not have any file extent for inode mode 060600
>  BTRFS error (device loop0): read time tree block corruption detected on logical 30408704 mirror 1
> 
> Reported-by: ZhengYuan Huang <gality369@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/20260817132051.267646-1-gality369@gmail.com/
> Assisted-by: LLM (for generating the corrupted image)
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 68 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 57 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 0ce91396b517..b0858f6c88e4 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -163,6 +163,12 @@ static void dir_item_err(const struct extent_buffer *eb, int slot,
>  	va_end(args);
>  }
>  
> +/* Record info for the last hit inode. */
> +struct last_inode_info {
> +	u64 ino;
> +	u32 mode;
> +};
> +
>  /*
>   * This functions checks prev_key->objectid, to ensure current key and prev_key
>   * share the same objectid as inode number.
> @@ -204,15 +210,47 @@ static bool check_prev_ino(struct extent_buffer *leaf,
>  		prev_key->objectid, key->objectid);
>  	return false;
>  }
> +
> +static bool check_last_inode_info(struct extent_buffer *leaf,
> +				  struct btrfs_key *key, int slot,
> +				  u8 fi_type,
> +				  const struct last_inode_info *last_inode)
> +{

This function name confused me as it doesn't refer to the fact that it
is in the context of checking an extent data item.

maybe something like "should_have_extent_data()" and do the error
logging in the caller when the result is unexpected?

> +	/* No inode item in this leaf. */
> +	if (last_inode->ino != key->objectid)
> +		return true;
> +	if (S_ISREG(last_inode->mode))
> +		return true;
> +	if (S_ISLNK(last_inode->mode)) {
> +		/* For symlink, the file extent item should always be inlined. */
> +		if (unlikely(fi_type != BTRFS_FILE_EXTENT_INLINE)) {
> +			file_extent_err(leaf, slot,
> +			"invalid file extent type, have %u expect %u for symlink",
> +					fi_type, BTRFS_FILE_EXTENT_INLINE);
> +			return false;
> +		}
> +		return true;
> +	}
> +	/*
> +	 * The remaining are special files, e.g. block/fifo files, which should
> +	 * not have any file extent.
> +	 */
> +	file_extent_err(leaf, slot, "file extent item not allowed for inode mode 0%o",
> +			last_inode->mode);
> +	return false;
> +}
> +
>  static int check_extent_data_item(struct extent_buffer *leaf,
>  				  struct btrfs_key *key, int slot,
> -				  struct btrfs_key *prev_key)
> +				  struct btrfs_key *prev_key,
> +				  const struct last_inode_info *last_inode)
>  {
>  	struct btrfs_fs_info *fs_info = leaf->fs_info;
>  	struct btrfs_file_extent_item *fi;
>  	u32 sectorsize = fs_info->sectorsize;
>  	u32 item_size = btrfs_item_size(leaf, slot);
>  	u64 extent_end;
> +	u8 fi_type;
>  
>  	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>  		file_extent_err(leaf, slot,
> @@ -243,15 +281,17 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>  				SZ_4K);
>  		return -EUCLEAN;
>  	}
> -	if (unlikely(btrfs_file_extent_type(leaf, fi) >=
> -		     BTRFS_NR_FILE_EXTENT_TYPES)) {
> +	fi_type = btrfs_file_extent_type(leaf, fi);
> +	if (unlikely(fi_type >= BTRFS_NR_FILE_EXTENT_TYPES)) {
>  		file_extent_err(leaf, slot,
>  		"invalid type for file extent, have %u expect range [0, %u]",
> -			btrfs_file_extent_type(leaf, fi),
> -			BTRFS_NR_FILE_EXTENT_TYPES - 1);
> +			fi_type, BTRFS_NR_FILE_EXTENT_TYPES - 1);
>  		return -EUCLEAN;
>  	}
>  
> +	if (unlikely(!check_last_inode_info(leaf, key, slot, fi_type, last_inode)))
> +		return -EUCLEAN;
> +
>  	/*
>  	 * Support for new compression/encryption must introduce incompat flag,
>  	 * and must be caught in open_ctree().
> @@ -270,7 +310,8 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>  			btrfs_file_extent_encryption(leaf, fi));
>  		return -EUCLEAN;
>  	}
> -	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
> +
> +	if (fi_type == BTRFS_FILE_EXTENT_INLINE) {
>  		/* Inline extent must have 0 as key offset */
>  		if (unlikely(key->offset)) {
>  			file_extent_err(leaf, slot,
> @@ -1206,7 +1247,8 @@ static int check_dev_item(struct extent_buffer *leaf,
>  }
>  
>  static int check_inode_item(struct extent_buffer *leaf,
> -			    struct btrfs_key *key, int slot)
> +			    struct btrfs_key *key, int slot,
> +			    struct last_inode_info *last_inode)

Isn't it more like cur_inode?

>  {
>  	struct btrfs_fs_info *fs_info = leaf->fs_info;
>  	struct btrfs_inode_item *iitem;
> @@ -1291,6 +1333,8 @@ static int check_inode_item(struct extent_buffer *leaf,
>  			ro_flags);
>  		return -EUCLEAN;
>  	}
> +	last_inode->ino = key->objectid;
> +	last_inode->mode = mode;
>  	return 0;
>  }
>  
> @@ -2319,14 +2363,15 @@ static int check_free_space_bitmap(struct extent_buffer *leaf,
>  static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>  						    struct btrfs_key *key,
>  						    int slot,
> -						    struct btrfs_key *prev_key)
> +						    struct btrfs_key *prev_key,
> +						    struct last_inode_info *last_inode)
>  {
>  	int ret = 0;
>  	struct btrfs_chunk *chunk;
>  
>  	switch (key->type) {
>  	case BTRFS_EXTENT_DATA_KEY:
> -		ret = check_extent_data_item(leaf, key, slot, prev_key);
> +		ret = check_extent_data_item(leaf, key, slot, prev_key, last_inode);
>  		break;
>  	case BTRFS_EXTENT_CSUM_KEY:
>  		ret = check_csum_item(leaf, key, slot, prev_key);
> @@ -2356,7 +2401,7 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>  		ret = check_dev_extent_item(leaf, key, slot, prev_key);
>  		break;
>  	case BTRFS_INODE_ITEM_KEY:
> -		ret = check_inode_item(leaf, key, slot);
> +		ret = check_inode_item(leaf, key, slot, last_inode);
>  		break;
>  	case BTRFS_ROOT_ITEM_KEY:
>  		ret = check_root_item(leaf, key, slot);
> @@ -2404,6 +2449,7 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
>  enum btrfs_tree_block_status __btrfs_check_leaf(struct extent_buffer *leaf)
>  {
>  	struct btrfs_fs_info *fs_info = leaf->fs_info;
> +	struct last_inode_info last_inode = { 0 };
>  	/* No valid key type is 0, so all key should be larger than this key */
>  	struct btrfs_key prev_key = {0, 0, 0};
>  	struct btrfs_key key;
> @@ -2539,7 +2585,7 @@ enum btrfs_tree_block_status __btrfs_check_leaf(struct extent_buffer *leaf)
>  		}
>  
>  		/* Check if the item size and content meet other criteria. */
> -		ret = check_leaf_item(leaf, &key, slot, &prev_key);
> +		ret = check_leaf_item(leaf, &key, slot, &prev_key, &last_inode);
>  		if (unlikely(ret != BTRFS_TREE_BLOCK_CLEAN))
>  			return ret;
>  
> -- 
> 2.54.0
> 
