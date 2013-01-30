Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46784 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3A2LdC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 06:33:02 -0500
Received: by mail-pb0-f44.google.com with SMTP id wz12so231087pbc.17
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 03:33:01 -0800 (PST)
Message-ID: <5108932C.6030306@gmail.com>
Date: Tue, 29 Jan 2013 19:27:40 -0800
From: Wang Shilong <wangshilong1991@gmail.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: dsterba@suse.cz, gene@czarc.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/12] Btrfs-progs: move printing subvol list outside
 of btrfs_list_subvols
In-Reply-To: <1359442141-25498-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359442141-25498-3-git-send-email-anand.jain@oracle.com>

Hi,
> To improve the code reuse its better to have btrfs_list_subvols
> just return list of subvols witout printing
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  btrfs-list.c     | 28 ++++++++++++++++++----------
>  btrfs-list.h     |  2 +-
>  cmds-subvolume.c |  4 ++--
>  3 files changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/btrfs-list.c b/btrfs-list.c
> index cb42fbc..b404e1d 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -1439,15 +1439,11 @@ static void print_all_volume_info(struct root_lookup *sorted_tree,
>  	}
>  }
>  
> -int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
> -		       struct btrfs_list_comparer_set *comp_set,
> -		       int is_tab_result)
> +int btrfs_list_subvols(int fd, struct root_lookup *root_lookup)
>  {
> -	struct root_lookup root_lookup;
> -	struct root_lookup root_sort;
>  	int ret;
>  
> -	ret = __list_subvol_search(fd, &root_lookup);
> +	ret = __list_subvol_search(fd, root_lookup);
>  	if (ret) {
>  		fprintf(stderr, "ERROR: can't perform the search - %s\n",
>  				strerror(errno));
> @@ -1458,16 +1454,28 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
>  	 * now we have an rbtree full of root_info objects, but we need to fill
>  	 * in their path names within the subvol that is referencing each one.
>  	 */
> -	ret = __list_subvol_fill_paths(fd, &root_lookup);
> -	if (ret < 0)
> -		return ret;
> +	ret = __list_subvol_fill_paths(fd, root_lookup);
> +	return ret;
> +}
>  
> +int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
> +		       struct btrfs_list_comparer_set *comp_set,
> +		       int is_tab_result)
> +{
> +	struct root_lookup root_lookup;
> +	struct root_lookup root_sort;
> +	int ret;
> +
> +	ret = btrfs_list_subvols(fd, &root_lookup);
> +	if (ret)
> +		return ret;
>  	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
>  				 comp_set, fd);
>  
>  	print_all_volume_info(&root_sort, is_tab_result);
>  	__free_all_subvolumn(&root_lookup);
    Here we forget to free filter and comp_set before..i hope you can add it to your patchset..
    Maybe you can have patch 13...

    if (filter_set)
        btrfs_list_free_filter_set(filter_set);
    if (comp_set)
        btrfs_list_free_comparer_set(comp_set);

    Thanks,
    Wang
> -	return ret;
> +
> +	return 0;
>  }
>  
>  static int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
> diff --git a/btrfs-list.h b/btrfs-list.h
> index cde4b3c..71fe0f3 100644
> --- a/btrfs-list.h
> +++ b/btrfs-list.h
> @@ -98,7 +98,7 @@ int btrfs_list_setup_comparer(struct btrfs_list_comparer_set **comp_set,
>  			      enum btrfs_list_comp_enum comparer,
>  			      int is_descending);
>  
> -int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
> +int btrfs_list_subvols_print(int fd, struct btrfs_list_filter_set *filter_set,
>  		       struct btrfs_list_comparer_set *comp_set,
>  			int is_tab_result);
>  int btrfs_list_find_updated_files(int fd, u64 root_id, u64 oldest_gen);
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index e3cdb1e..c35dff7 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -406,7 +406,7 @@ static int cmd_subvol_list(int argc, char **argv)
>  					BTRFS_LIST_FILTER_TOPID_EQUAL,
>  					top_id);
>  
> -	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
> +	ret = btrfs_list_subvols_print(fd, filter_set, comparer_set,
>  				is_tab_result);
>  	if (ret)
>  		return 19;
> @@ -613,7 +613,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
>  	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_ROOTID,
>  				default_id);
>  
> -	ret = btrfs_list_subvols(fd, filter_set, NULL, 0);
> +	ret = btrfs_list_subvols_print(fd, filter_set, NULL, 0);
>  	if (ret)
>  		return 19;
>  	return 0;

