Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3I0TKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 15:10:32 -0400
Date: Fri, 27 Sep 2013 12:10:29 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: calculate disk space that a subvol could
 free
Message-ID: <20130927191029.GX30372@lenny.home.zabbo.net>
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index de246ab..0f36cde 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -809,6 +809,7 @@ static int cmd_subvol_show(int argc, char **argv)
>  	int fd = -1, mntfd = -1;
>  	int ret = 1;
>  	DIR *dirstream1 = NULL, *dirstream2 = NULL;
> +	u64 freeable_bytes;
>  
>  	if (check_argc_exact(argc, 2))
>  		usage(cmd_subvol_show_usage);
> @@ -878,6 +879,8 @@ static int cmd_subvol_show(int argc, char **argv)
>  		goto out;
>  	}
>  
> +	freeable_bytes = get_subvol_freeable_bytes(fd);
> +
>  	ret = 0;
>  	/* print the info */
>  	printf("%s\n", fullpath);
> @@ -915,6 +918,8 @@ static int cmd_subvol_show(int argc, char **argv)
>  	else
>  		printf("\tFlags: \t\t\t-\n");
>  
> +	printf("\tUnshared space: \t%s\n",
> +		pretty_size(freeable_bytes));

There's no reason to have a local variable:

	printf("\tUnshared space: \t%s\n",
		pretty_size(get_subvol_freeable_bytes(fd));


>  	printf("\tSnapshot(s):\n");
>  	filter_set = btrfs_list_alloc_filter_set();
> diff --git a/utils.c b/utils.c
> index ccb5199..ca30485 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2062,3 +2062,157 @@ int lookup_ino_rootid(int fd, u64 *rootid)
>  
>  	return 0;
>  }
> +
> +/* gets the ref count for given extent
> + * 0 = didn't find the item
> + * n = number of references
> +*/
> +u64 get_extent_refcnt(int fd, u64 disk_blk)
> +{
> +	int ret = 0, i, e;
> +	struct btrfs_ioctl_search_args args;
> +	struct btrfs_ioctl_search_key *sk = &args.key;
> +	struct btrfs_ioctl_search_header sh;
> +	unsigned long off = 0;
> +
> +	memset(&args, 0, sizeof(args));
> +
> +	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
> +
> +	sk->min_type = BTRFS_EXTENT_ITEM_KEY;
> +	sk->max_type = BTRFS_EXTENT_ITEM_KEY;
> +
> +	sk->min_objectid = disk_blk;
> +	sk->max_objectid = disk_blk;
> +
> +	sk->max_offset = (u64)-1;
> +	sk->max_transid = (u64)-1;
> +
> +	while (1) {
> +		sk->nr_items = 4096;
> +
> +		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> +		e = errno;
> +		if (ret < 0) {
> +			fprintf(stderr, "ERROR: search failed - %s\n",
> +				strerror(e));
> +			return 0;
> +		}
> +		if (sk->nr_items == 0)
> +			break;
> +
> +		off = 0;
> +		for (i = 0; i < sk->nr_items; i++) {
> +			struct btrfs_extent_item *ei;
> +			u64 ref;
> +
> +			memcpy(&sh, args.buf + off, sizeof(sh));
> +			off += sizeof(sh);
> +
> +			if (sh.type != BTRFS_EXTENT_ITEM_KEY) {
> +				off += sh.len;
> +				continue;
> +			}
> +
> +			ei = (struct btrfs_extent_item *)(args.buf + off);
> +			ref = btrfs_stack_extent_refs(ei);
> +			return ref;
> +		}
> +		sk->min_objectid = sh.objectid;
> +		sk->min_offset = sh.offset;
> +		sk->min_type = sh.type;
> +		if (sk->min_offset < (u64)-1)
> +			sk->min_offset++;
> +		else if (sk->min_objectid < (u64)-1) {
> +			sk->min_objectid++;
> +			sk->min_offset = 0;
> +			sk->min_type = 0;
> +		} else
> +			break;
> +	}
> +	return 0;
> +}

These two fiddly functions only differ in the tree search and what they
do with each item.  So replace them with a function that takes a
description of the search and calls the caller's callback for each item.

typedef void (*item_func_t)(struct btrfs_key *key, void *data, void *arg);

int btrfs_for_each_item(int fd, min and max and junk,
			item_func_t func, void *arg);

u64 get_subvol_freeable_bytes(int fd)
{
	u64 size_bytes = 0;

	btrfs_for_each_item(fd, ...., sum_extents, &size_bytes);

	return size_bytes;
}

Etc.  You get the idea.

- z
