Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755287AbcJ1PoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:44:09 -0400
Date: Fri, 28 Oct 2016 17:44:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Divya Indi <divya.indi@oracle.com>
Cc: linux-btrfs@vger.kernel.org, ashish.samant@oracle.com,
        bo.li.liu@oracle.com
Subject: Re: [PATCH 1/3] btrfs-progs: Generic functions to retrieve chunks
 and their bg info
Message-ID: <20161028154406.GK12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 05:35:13PM -0700, Divya Indi wrote:
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
> +
> +/* Walking through the chunk tree to retrieve chunks. */

No empty newline.

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

Please don't do multiple asignments in one statement.

> +	sk->nr_items = 4096;
> +
> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, chunk_args);
> +	e = errno;

This is useless asignment, I've removed it from the code, please don't
reintrduce it.

> +	if (ret < 0) {
> +		fprintf(stderr, "ret %d error '%s'\n", ret,
> +				strerror(e));
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

Same here.

> +
> +	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, bg_args);
> +	e = errno;
> +	if (ret < 0) {
> +		fprintf(stderr, "ret %d error '%s'\n", ret,
> +				strerror(e));

Please take a look how the error messages are constructed when the tree
search ioctl fails, there are enough examples in the code.

> +	}
> +	return ret;
> +}
>  static const char * const cmd_inspect_inode_resolve_usage[] = {
>  	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
>  	"Get file system paths for the given inode",

Actually, I'm not sure if such functions should exist at all, as they
only hide the search ioctl but don't do any validation of the returned
keys and data.
