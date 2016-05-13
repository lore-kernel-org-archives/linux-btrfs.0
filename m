Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbcEMXzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 19:55:36 -0400
Date: Fri, 13 May 2016 16:57:17 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com
Subject: Re: [PATCH 2/2] Btrfs: add valid checks for chunk loading
Message-ID: <20160513235717.GC27734@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <1462212951-28113-2-git-send-email-bo.li.liu@oracle.com>
 <20160504135626.GV29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160504135626.GV29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 03:56:26PM +0200, David Sterba wrote:
> A few minor comments below
> 
> On Mon, May 02, 2016 at 11:15:51AM -0700, Liu Bo wrote:
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6206,27 +6206,23 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
> >  	return dev;
> >  }
> >  
> > -static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> > -			  struct extent_buffer *leaf,
> > -			  struct btrfs_chunk *chunk)
> > +/* Return -EIO if any error, otherwise return 0. */
> > +static int btrfs_check_chunk_valid(struct btrfs_root *root,
> > +				   struct extent_buffer *leaf,
> > +				   struct btrfs_chunk *chunk, u64 logical)
> >  {
> > -	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
> > -	struct map_lookup *map;
> > -	struct extent_map *em;
> > -	u64 logical;
> >  	u64 length;
> >  	u64 stripe_len;
> > -	u64 devid;
> > -	u8 uuid[BTRFS_UUID_SIZE];
> > -	int num_stripes;
> > -	int ret;
> > -	int i;
> > +	u16 num_stripes;
> > +	u16 sub_stripes;
> > +	u64 type;
> >  
> > -	logical = key->offset;
> >  	length = btrfs_chunk_length(leaf, chunk);
> >  	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> >  	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> > -	/* Validation check */
> > +	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> > +	type = btrfs_chunk_type(leaf, chunk);
> > +
> >  	if (!num_stripes) {
> >  		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
> >  			  num_stripes);
> > @@ -6237,24 +6233,70 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> >  			  "invalid chunk logical %llu", logical);
> >  		return -EIO;
> >  	}
> > +	if (btrfs_chunk_sector_size(leaf, chunk) != root->sectorsize) {
> > +		btrfs_err(root->fs_info, "invalid chunk sectorsize %llu",
> > +			  (unsigned long long)btrfs_chunk_sector_size(leaf,
> 
> type cast not necessry
> 
> > +								      chunk));
> > +		return -EIO;
> > +	}
> >  	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
> >  		btrfs_err(root->fs_info,
> >  			"invalid chunk length %llu", length);
> >  		return -EIO;
> >  	}
> > -	if (!is_power_of_2(stripe_len)) {
> > +	if (stripe_len != BTRFS_STRIPE_LEN) {
> 
> Again too strict. As mentined elsewhere, add a helper to validate
> stripe_len and use it so we don't open-code it.

I'm not sure I understand the comment about open-code, right now
the value must be BTRFS_STRIPE_LEN and we don't set any other value,
are we going to add a helper for just (stripe_len != BTRFS_STRIPE_LEN)?

I fixed other issues.

Thanks,

-liubo

> 
> >  		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
> >  			  stripe_len);
> >  		return -EIO;
> >  	}
> >  	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> > -	    btrfs_chunk_type(leaf, chunk)) {
> > +	    type) {
> >  		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
> >  			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
> >  			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> >  			  btrfs_chunk_type(leaf, chunk));
> >  		return -EIO;
> >  	}
> > +	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes == 0) ||
> > +	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> > +	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> > +	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 3) ||
> > +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> > +	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
> 
> I was looking if we could turn that into some generic checks using the
> btrfs_raid_array but seems that the tests do not make a uniform pattern,
> eg the DUP and SINGLE disguised as "mask == 0". As we don't add new
> profiles too often I'm ok with that version.
> 
> > +	     num_stripes != 1)) {
> > +		btrfs_err(root->fs_info, "Invalid num_stripes:sub_stripes %u:%u for profile %llu",
> 
> "invalid..." (no initial capital letter) and put the string on the next
> line so it does not exceed 80 cols
> 
> > +			  num_stripes, sub_stripes,
> > +			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> > +			  struct extent_buffer *leaf,
> > +			  struct btrfs_chunk *chunk)
> > +{
> > +	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
> > +	struct map_lookup *map;
> > +	struct extent_map *em;
> > +	u64 logical;
> > +	u64 length;
> > +	u64 stripe_len;
> > +	u64 devid;
> > +	u8 uuid[BTRFS_UUID_SIZE];
> > +	int num_stripes;
> > +	int ret;
> > +	int i;
> > +
> > +	logical = key->offset;
> > +	length = btrfs_chunk_length(leaf, chunk);
> > +	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> > +	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> > +	/* Validation check */
> 
> Redundant comment (from the time when the validation was not in a
> wrapper)
> 
> > +	ret = btrfs_check_chunk_valid(root, leaf, chunk, logical);
> > +	if (ret)
> > +		return ret;
> >  
> >  	read_lock(&map_tree->map_tree.lock);
> >  	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
> > @@ -6502,6 +6544,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
> >  	u32 array_size;
> >  	u32 len = 0;
> >  	u32 cur_offset;
> > +	u64 type;
> >  	struct btrfs_key key;
> >  
> >  	ASSERT(BTRFS_SUPER_INFO_SIZE <= root->nodesize);
> > @@ -6568,6 +6611,15 @@ int btrfs_read_sys_array(struct btrfs_root *root)
> >  				break;
> >  			}
> >  
> > +			type = btrfs_chunk_type(sb, chunk);
> > +			if ((type & BTRFS_BLOCK_GROUP_SYSTEM) == 0) {
> > +				printk(KERN_ERR
> > +	    "BTRFS: invalid chunk type %llu in sys_array at offset %u\n",
> > +					type, cur_offset);
> > +				ret = -EIO;
> > +				break;
> > +			}
> > +
> >  			len = btrfs_chunk_item_size(num_stripes);
> >  			if (cur_offset + len > array_size)
> >  				goto out_short_read;
> > -- 
> > 2.5.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
