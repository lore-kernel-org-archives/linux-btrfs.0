Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbBJS3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 13:29:04 -0500
Message-ID: <54DA4DE8.4070701@redhat.com>
Date: Tue, 10 Feb 2015 12:28:56 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 09/16] Btrfs-progs: Introduce metadump_v2
References: <1423512199-16552-1-git-send-email-jbacik@fb.com> <1423512199-16552-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-10-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/9/15 2:03 PM, Josef Bacik wrote:
> The METADUMP super flag makes us skip doing the chunk tree reading which isn't
> helpful for the new restore since we have a valid chunk tree.  But we still want
> to have a way for the kernel to know that this is a metadump restore so it
> doesn't do things like verify data checksums.  We also want to skip some of the
> device extent checks in fsck since those will obviously not match.  Thanks,

coverity points out that the "metadump_v2" flag is never set to anything but 0.

# git show 797a937e | grep metadump_v2
    Btrfs-progs: Introduce metadump_v2
+	int metadump_v2 = 0;
+		    (!metadump_v2 &&
+	if (metadump_v2)
# 

is that ... intentional?

-Eric


> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  btrfs-image.c | 3 +++
>  cmds-check.c  | 9 +++++++--
>  ctree.h       | 1 +
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index ea85542..feb4a62 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -1455,6 +1455,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
>  	struct btrfs_chunk *chunk;
>  	struct btrfs_disk_key *disk_key;
>  	struct btrfs_key key;
> +	u64 flags = btrfs_super_flags(super);
>  	u32 new_array_size = 0;
>  	u32 array_size;
>  	u32 cur = 0;
> @@ -1510,6 +1511,8 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
>  	if (mdres->clear_space_cache)
>  		btrfs_set_super_cache_generation(super, 0);
>  
> +	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
> +	btrfs_set_super_flags(super, flags);
>  	btrfs_set_super_sys_array_size(super, new_array_size);
>  	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
>  
> diff --git a/cmds-check.c b/cmds-check.c
> index 2163823..ffdfbf2 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -7426,6 +7426,7 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
>  	u64 devid;
>  	u64 offset;
>  	u64 length;
> +	int metadump_v2 = 0;
>  	int i;
>  	int ret = 0;
>  
> @@ -7438,7 +7439,8 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
>  					       cache);
>  		if (chunk_rec->length != block_group_rec->offset ||
>  		    chunk_rec->offset != block_group_rec->objectid ||
> -		    chunk_rec->type_flags != block_group_rec->flags) {
> +		    (!metadump_v2 &&
> +		     chunk_rec->type_flags != block_group_rec->flags)) {
>  			if (!silent)
>  				fprintf(stderr,
>  					"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) mismatch with block group[%llu, %u, %llu]: offset(%llu), objectid(%llu), flags(%llu)\n",
> @@ -7472,6 +7474,9 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
>  		ret = 1;
>  	}
>  
> +	if (metadump_v2)
> +		return ret;
> +
>  	length = calc_stripe_length(chunk_rec->type_flags, chunk_rec->length,
>  				    chunk_rec->num_stripes);
>  	for (i = 0; i < chunk_rec->num_stripes; ++i) {
> @@ -7538,7 +7543,7 @@ int check_chunks(struct cache_tree *chunk_cache,
>  					 cache);
>  		err = check_chunk_refs(chunk_rec, block_group_cache,
>  				       dev_extent_cache, silent);
> -		if (err)
> +		if (err < 0)
>  			ret = err;
>  		if (err == 0 && good)
>  			list_add_tail(&chunk_rec->list, good);
> diff --git a/ctree.h b/ctree.h
> index 2d2988b..be30cb6 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -309,6 +309,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>  #define BTRFS_HEADER_FLAG_RELOC			(1ULL << 1)
>  #define BTRFS_SUPER_FLAG_SEEDING		(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP		(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2		(1ULL << 34)
>  
>  #define BTRFS_BACKREF_REV_MAX		256
>  #define BTRFS_BACKREF_REV_SHIFT		56
> 

