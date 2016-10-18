Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8462 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757006AbcJRBjj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 21:39:39 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: Add a command to show bg info
To: Divya Indi <divya.indi@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
CC: <ashish.samant@oracle.com>, <bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d9e5bee8-d865-840d-11e4-74f98c34282e@cn.fujitsu.com>
Date: Tue, 18 Oct 2016 09:39:32 +0800
MIME-Version: 1.0
In-Reply-To: <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/18/2016 08:35 AM, Divya Indi wrote:
> Add a new subcommand to btrfs inspect-internal
>
> btrfs inspect-internal bg_analysis <path>
> Gives information about all the block groups.
>
> Signed-off-by: Divya Indi <divya.indi@oracle.com>
> Reviewed-by: Ashish Samant <ashish.samant@oracle.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  cmds-inspect.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 114 insertions(+), 0 deletions(-)
>
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index f435ea9..0e2f15a 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -147,6 +147,118 @@ static int get_bg_info(int fd, struct btrfs_ioctl_search_args *bg_args,
>  	}
>  	return ret;
>  }
> +
> +static const char * const cmd_inspect_bg_analysis_usage[] = {
> +	"btrfs inspect-internal bg_analysis <path> ",
> +	"Get information about all block groups",

What about get bg info for given range, and not all?

I think it's just several new parameters, as your design is capable to 
handle that.

> +	"",
> +	"",
> +	NULL
> +};
> +
> +static int cmd_inspect_bg_analysis(int argc, char **argv)
> +{
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_args bg_args;
> +	struct btrfs_ioctl_search_header *header;
> +	struct btrfs_ioctl_search_header *bg_header;
> +	struct btrfs_ioctl_search_key *sk;
> +	struct btrfs_ioctl_search_key *bg_sk;
> +	struct btrfs_block_group_item *bg;
> +	struct btrfs_chunk *chunk;
> +	unsigned long off = 0;
> +	unsigned long bg_off = 0;
> +	DIR *dirstream = NULL;
> +	int fd;
> +	int i;
> +	int ret = 0;
> +	u64 used;
> +	u64 flags;
> +	char bg_type[32] = {0};
> +
> +	if (check_argc_exact(argc, 2))
> +		usage(cmd_inspect_bg_analysis_usage);
> +
> +	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
> +	if (fd < 0)
> +		return 1;
> +
> +	memset(&args, 0, sizeof(args));
> +	sk = &args.key;
> +	sk->min_offset = sk->min_transid = 0;
> +	sk->max_offset = sk->max_transid = (u64)-1;
> +	printf("%20s%20s%20s%20s\n", "Type", "Start", "Len", "Used");
> +	while (1) {
> +
> +		/* Walk through the chunk tree and retrieve all the chunks */
> +		ret = get_chunks(fd, &args);
> +		if (ret < 0)
> +			goto out;
> +
> +		/*
> +		 * it should not happen.
> +		 */
> +		if (sk->nr_items == 0)
> +			break;
> +
> +		off = 0;
> +		memset(&bg_args, 0, sizeof(bg_args));
> +		bg_sk = &bg_args.key;
> +
> +		bg_sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
> +		bg_sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> +		bg_sk->max_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> +		bg_sk->min_transid =  0;
> +		bg_sk->max_transid = (u64)-1;
> +
> +		for (i = 0; i < sk->nr_items; i++) {
> +			header = (struct btrfs_ioctl_search_header *)(args.buf
> +								      + off);
> +			off += sizeof(*header);
> +			if (header->type == BTRFS_CHUNK_ITEM_KEY) {
> +				chunk = (struct btrfs_chunk *)
> +					(args.buf + off);
> +
> +				/* For every chunk lookup an exact match(bg) in
> +				 * the extent tree and read its used values */
> +				ret = get_bg_info(fd, &bg_args, header->offset,
> +						  chunk->length);
> +				if (ret < 0)
> +					goto out;
> +
> +				/*
> +				 * it should not happen.
> +				 */
> +				if (bg_sk->nr_items == 0)
> +					continue;
> +
> +				bg_off = 0;
> +				bg_header = (struct btrfs_ioctl_search_header *)
> +					    (bg_args.buf + bg_off);
> +				bg_off += sizeof(*bg_header);
> +				bg = (struct btrfs_block_group_item *)
> +				     (bg_args.buf + bg_off);
> +
> +				used = btrfs_block_group_used(bg);
> +				memset(&bg_type, 0, 32);
> +				flags = btrfs_block_group_flags(bg);
> +				bg_flags_to_str(flags, bg_type);
> +				printf("%20s%20llu%20s%20s\n",
> +					bg_type,
> +					bg_header->objectid,
> +					pretty_size(bg_header->offset),
> +					pretty_size(used));

BTW, it would be quite handy if we can specify units.

> +			}
> +			off += header->len;
> +			sk->min_offset = header->offset + header->len;
> +		}
> +		sk->nr_items = 4096;
> +	}
> +out:
> +	close_file_or_dir(fd, dirstream);
> +	return ret;
> +}
> +
>  static const char * const cmd_inspect_inode_resolve_usage[] = {
>  	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
>  	"Get file system paths for the given inode",
> @@ -702,6 +814,8 @@ const struct cmd_group inspect_cmd_group = {
>  			0 },
>  		{ "min-dev-size", cmd_inspect_min_dev_size,
>  			cmd_inspect_min_dev_size_usage, NULL, 0 },
> +		{ "bg_analysis", cmd_inspect_bg_analysis,
> +			cmd_inspect_bg_analysis_usage, NULL, 0 },

Just naming preference, IMHO show-block-groups or dump-block-groups 
seems better for me.

Other part seems good.
Feel free to add my reviewed by tag.

Thanks,
Qu
>  		{ "dump-tree", cmd_inspect_dump_tree,
>  				cmd_inspect_dump_tree_usage, NULL, 0 },
>  		{ "dump-super", cmd_inspect_dump_super,
>


