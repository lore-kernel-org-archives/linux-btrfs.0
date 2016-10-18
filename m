Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40893 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933222AbcJRBe7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 21:34:59 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Generic functions to retrieve chunks and
 their bg info
To: Divya Indi <divya.indi@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
CC: <ashish.samant@oracle.com>, <bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <013540c9-61a0-e0f1-f763-29cc2ce703a6@cn.fujitsu.com>
Date: Tue, 18 Oct 2016 09:34:45 +0800
MIME-Version: 1.0
In-Reply-To: <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/18/2016 08:35 AM, Divya Indi wrote:
> An efficient alternative to retrieving block groups:
> get_chunks(): Walk the chunk tree to retrieve the chunks.
> get_bg_info(): For each retrieved chunk, lookup an exact match of block
> group in the extent tree.
>
> Signed-off-by: Divya Indi <divya.indi@oracle.com>
> Reviewed-by: Ashish Samant <ashish.samant@oracle.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  cmds-inspect.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 66 insertions(+), 0 deletions(-)
>
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index 4b7cea0..f435ea9 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -81,6 +81,72 @@ out:
>  	return !!ret;
>  }
>
> +static void bg_flags_to_str(u64 flags, char *ret)
> +{
> +	int empty = 1;
> +
> +	if (flags & BTRFS_BLOCK_GROUP_DATA) {
> +		empty = 0;
> +		strcpy(ret, "DATA");
> +	}
> +	if (flags & BTRFS_BLOCK_GROUP_METADATA) {
> +		if (!empty)
> +			strcat(ret, "|");
> +		strcat(ret, "METADATA");
> +	}
> +	if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
> +		if (!empty)
> +			strcat(ret, "|");
> +		strcat(ret, "SYSTEM");
> +	}
> +}

Check print-tree.c, it has the same function.
Just export it.

And it's stronger than your version, which can also output profiles.

> +
> +/* Walking through the chunk tree to retrieve chunks. */
> +
> +static int get_chunks(int fd, struct btrfs_ioctl_search_args *chunk_args)
> +{
> +	struct btrfs_ioctl_search_key *sk;
> +	int ret;
> +	int e;
> +
> +	sk = &chunk_args->key;
> +
> +	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
> +	sk->min_objectid = sk->max_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> +	sk->max_type = sk->min_type = BTRFS_CHUNK_ITEM_KEY;
> +	sk->nr_items = 4096;
> +
> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, chunk_args);
> +	e = errno;
> +	if (ret < 0) {
> +		fprintf(stderr, "ret %d error '%s'\n", ret,
> +				strerror(e));

Use error() function.

> +	}
> +	return ret;
> +}
> +
> +/* Given the objectid, find the block group item in the extent tree */
> +static int get_bg_info(int fd, struct btrfs_ioctl_search_args *bg_args,
> +		       u64 objectid, unsigned long length)
> +{
> +	struct btrfs_ioctl_search_key *bg_sk;
> +	int ret;
> +	int e;
> +
> +	bg_sk = &bg_args->key;
> +
> +	bg_sk->min_objectid = bg_sk->max_objectid = objectid;
> +	bg_sk->nr_items = 1;
> +	bg_sk->min_offset = bg_sk->max_offset = length;
> +
> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, bg_args);
> +	e = errno;
> +	if (ret < 0) {
> +		fprintf(stderr, "ret %d error '%s'\n", ret,
> +				strerror(e));

Same problem here.

> +	}
> +	return ret;
> +}
>  static const char * const cmd_inspect_inode_resolve_usage[] = {
>  	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
>  	"Get file system paths for the given inode",
>


