Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30994 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbcD1OIy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:08:54 -0400
Subject: Re: [PATCH RFC v1.1 02/16] btrfs-progs: fsck: Introduce function to
 check data backref in extent tree
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-3-git-send-email-quwenruo@cn.fujitsu.com>
 <1461807819-29771-1-git-send-email-quwenruo@cn.fujitsu.com>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <26f85b88-d499-d236-43bf-4505d526b0a0@fb.com>
Date: Thu, 28 Apr 2016 10:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <1461807819-29771-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2016 09:43 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce a new function check_data_extent_item() to check if the
> corresponding data backref exists in extent tree.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> Changelog:
> v1.1:
>    Fix a typo which passed wrong parameter for hash_extent_data_ref()
>    Fix a generation mismatch condition, as for inband dedupe or reflink
>    case, file extent generation can be larger than extent item generation.
> ---
>  cmds-check.c  | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ctree.h       |   2 +
>  extent-tree.c |   2 +-
>  3 files changed, 155 insertions(+), 1 deletion(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 27fc26f..a6ea0fd 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -322,6 +322,7 @@ struct root_item_info {
>   */
>  #define MISSING_BACKREF	(1 << 0) /* Completely no backref in extent tree */
>  #define BAD_BACKREF	(1 << 1) /* Backref mismatch */
> +#define UNALIGNED_BYTES	(1 << 2) /* Some bytes are not aligned */
>
>  static void *print_status_check(void *p)
>  {
> @@ -8565,6 +8566,157 @@ out:
>  	return -err;
>  }
>
> +/*
> + * Check EXTENT_DATA item, mainly for its dbackref in extent tree
> + *
> + * Return <0 any error found and output error message
> + * Return 0 for no error found
> + */
> +static int check_extent_data_item(struct btrfs_root *root,
> +				  struct extent_buffer *eb, int slot)
> +{
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_path path;
> +	struct btrfs_root *extent_root = root->fs_info->extent_root;
> +	struct btrfs_key key;
> +	struct btrfs_key orig_key;
> +	struct btrfs_key found_key;
> +	struct extent_buffer *leaf;
> +	struct btrfs_extent_item *ei;
> +	struct btrfs_extent_inline_ref *iref;
> +	struct btrfs_extent_data_ref *dref;
> +	u64 owner;
> +	u64 file_extent_gen;
> +	u64 disk_bytenr;
> +	u64 disk_num_bytes;
> +	u64 extent_num_bytes;
> +	u64 extent_flags;
> +	u64 extent_gen;
> +	u32 item_size;
> +	unsigned long end;
> +	unsigned long ptr;
> +	int type;
> +	u64 ref_root;
> +	int found_dbackref = 0;
> +	int err = 0;
> +	int ret;
> +
> +	btrfs_item_key_to_cpu(eb, &orig_key, slot);
> +	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> +	file_extent_gen = btrfs_file_extent_generation(eb, fi);
> +
> +	/* Nothing to check for hole and inline data extents */
> +	if (btrfs_file_extent_type(eb, fi) == BTRFS_FILE_EXTENT_INLINE ||
> +	    btrfs_file_extent_disk_bytenr(eb, fi) == 0)
> +		return 0;
> +
> +	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
> +	disk_num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
> +	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
> +	/* Check unaligned disk_num_bytes and num_bytes */
> +	if (!IS_ALIGNED(disk_num_bytes, root->sectorsize)) {
> +		error("File extent [%llu, %llu] has unaligned disk num bytes: %llu, should be aligned to %u",
> +		      key.objectid, key.offset, disk_num_bytes,
> +		      root->sectorsize);
> +		err |= UNALIGNED_BYTES;
> +	} else
> +		data_bytes_allocated += disk_num_bytes;

Please use the standard kernel format of having

} else {
	//blah
}

for single lined else's combined with multi-line if's.  Once that is 
fixed you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
