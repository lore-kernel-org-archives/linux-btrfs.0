Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35414 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbeBBX2c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 18:28:32 -0500
Subject: Re: [PATCH 21/26] btrfs-progs: use libbtrfsutil for subvol show
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
References: <cover.1516991902.git.osandov@fb.com>
 <537f3ffac3eac01c6a36f613817f9c3f206ee568.1516991902.git.osandov@fb.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <fc3703b7-30cb-230b-7e3d-5efc33c456fb@mendix.com>
Date: Sat, 3 Feb 2018 00:18:02 +0100
MIME-Version: 1.0
In-Reply-To: <537f3ffac3eac01c6a36f613817f9c3f206ee568.1516991902.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/2018 07:41 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Now implemented with btrfs_util_subvolume_path(),
> btrfs_util_subvolume_info(), and subvolume iterators.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  cmds-subvolume.c | 150 ++++++++++++++++++++++++++++++++++++-------------------
>  utils.c          | 118 -------------------------------------------
>  utils.h          |   5 --
>  3 files changed, 99 insertions(+), 174 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index c5e03011..b969fc88 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
>
>
> [...]
>  	} else
>  		strcpy(tstr, "-");
>  	printf("\tCreation time: \t\t%s\n", tstr);
>  
> -	printf("\tSubvolume ID: \t\t%llu\n", get_ri.root_id);
> -	printf("\tGeneration: \t\t%llu\n", get_ri.gen);
> -	printf("\tGen at creation: \t%llu\n", get_ri.ogen);
> -	printf("\tParent ID: \t\t%llu\n", get_ri.ref_tree);
> -	printf("\tTop level ID: \t\t%llu\n", get_ri.top_id);
> +	printf("\tSubvolume ID: \t\t%" PRIu64 "\n", subvol.id);
> +	printf("\tGeneration: \t\t%" PRIu64 "\n", subvol.generation);
> +	printf("\tGen at creation: \t%" PRIu64 "\n", subvol.otransid);
> +	printf("\tParent ID: \t\t%" PRIu64 "\n", subvol.parent_id);
> +	printf("\tTop level ID: \t\t%" PRIu64 "\n", subvol.parent_id);
>  
> -	if (get_ri.flags & BTRFS_ROOT_SUBVOL_RDONLY)
> +	if (subvol.flags & BTRFS_ROOT_SUBVOL_RDONLY)
>  		printf("\tFlags: \t\t\treadonly\n");
>  	else
>  		printf("\tFlags: \t\t\t-\n");
>  
>  	/* print the snapshots of the given subvol if any*/
>  	printf("\tSnapshot(s):\n");
> -	filter_set = btrfs_list_alloc_filter_set();
> -	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
> -				(u64)(unsigned long)get_ri.uuid);
> -	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
>  
> -	fd = open_file_or_dir(fullpath, &dirstream1);
> -	if (fd < 0) {
> -		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
> -		goto out;
> +	err = btrfs_util_f_create_subvolume_iterator(fd,
> +						     BTRFS_FS_TREE_OBJECTID,
> +						     0, &iter);
> +
> [...]
When you have enough subvolumes in a filesystem, let's say 100000 (yes,
that sometimes happens), the current btrfs sub list is quite unusable,
which is kind of expected. But, currently, sub show is also unusable
because it still starts loading a list of all subvolumes to be able to
print the 'snapshots, if any'.

So I guess that this new sub show will at least print the info first and
then use the iterator and start crawling through the list, which can be
interrupted? At least you get the relevant info first then. :-)

-- 
Hans van Kranenburg
