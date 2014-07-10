Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaGJHee (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 03:34:34 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9B02B3EE0BD
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:34:32 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AB024AC07E3
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:34:31 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 432E71DB8032
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:34:31 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 43D16692785
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 16:34:30 +0900 (JST)
Message-ID: <53BE4200.1080707@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 16:34:24 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs-progs: Fix wrong indent in btrfs-progs.
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com> <1404961513-14614-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404961513-14614-3-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/10 12:05), Qu Wenruo wrote:
> When editing cmds-filesystem.c, I found cmd_filesystem_df() uses 7
> spaces as indent instead of 1 tab (or 8 spaces). which makes indent
> quite embarrassing.
> Such problem is especillay hard to detect when reviewing patches,
> since the leading '+' makes a tab only 7 spaces long, makeing 7 spaces
> look the same with a tab.
> 
> This patch fixes all the 7 spaces indent.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   cmds-filesystem.c | 79 +++++++++++++++++++++++++++----------------------------
>   ctree.h           | 15 ++++++-----
>   utils.c           | 10 +++----
>   3 files changed, 52 insertions(+), 52 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 4b2d27e..0a9b62a 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -114,23 +114,23 @@ static const char * const filesystem_cmd_group_usage[] = {
>   };
>   
>   static const char * const cmd_filesystem_df_usage[] = {
> -       "btrfs filesystem df <path>",
> -       "Show space usage information for a mount point",
> -       NULL
> +	"btrfs filesystem df <path>",
> +	"Show space usage information for a mount point",
> +	NULL
>   };
>   
>   static void print_df(struct btrfs_ioctl_space_args *sargs)
>   {
> -       u64 i;
> -       struct btrfs_ioctl_space_info *sp = sargs->spaces;
> -
> -       for (i = 0; i < sargs->total_spaces; i++, sp++) {
> -               printf("%s, %s: total=%s, used=%s\n",
> -                       group_type_str(sp->flags),
> -                       group_profile_str(sp->flags),
> -                       pretty_size(sp->total_bytes),
> -                       pretty_size(sp->used_bytes));
> -       }
> +	u64 i;
> +	struct btrfs_ioctl_space_info *sp = sargs->spaces;
> +
> +	for (i = 0; i < sargs->total_spaces; i++, sp++) {
> +		printf("%s, %s: total=%s, used=%s\n",
> +		       group_type_str(sp->flags),
> +		       group_profile_str(sp->flags),
> +		       pretty_size(sp->total_bytes),
> +		       pretty_size(sp->used_bytes));
> +	}
>   }
>   
>   static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
> @@ -183,33 +183,32 @@ static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
>   
>   static int cmd_filesystem_df(int argc, char **argv)
>   {
> -       struct btrfs_ioctl_space_args *sargs = NULL;
> -       int ret;
> -       int fd;
> -       char *path;
> -       DIR *dirstream = NULL;
> -
> -       if (check_argc_exact(argc, 2))
> -               usage(cmd_filesystem_df_usage);
> -
> -       path = argv[1];
> -
> -       fd = open_file_or_dir(path, &dirstream);
> -       if (fd < 0) {
> -               fprintf(stderr, "ERROR: can't access '%s'\n", path);
> -               return 1;
> -       }
> -       ret = get_df(fd, &sargs);
> -
> -       if (!ret && sargs) {
> -               print_df(sargs);
> -               free(sargs);
> -       } else {
> -               fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
> -       }
> -
> -       close_file_or_dir(fd, dirstream);
> -       return !!ret;
> +	struct btrfs_ioctl_space_args *sargs = NULL;
> +	int ret;
> +	int fd;
> +	char *path;
> +	DIR *dirstream = NULL;
> +
> +	if (check_argc_exact(argc, 2))
> +		usage(cmd_filesystem_df_usage);
> +
> +	path = argv[1];
> +
> +	fd = open_file_or_dir(path, &dirstream);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access '%s'\n", path);
> +		return 1;
> +	}
> +	ret = get_df(fd, &sargs);
> +	if (!ret && sargs) {
> +		print_df(sargs);
> +		free(sargs);
> +	} else {
> +		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
> +	}
> +
> +	close_file_or_dir(fd, dirstream);
> +	return !!ret;
>   }
>   
>   static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
> diff --git a/ctree.h b/ctree.h
> index 35d3633..83d85b3 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -939,10 +939,10 @@ struct btrfs_block_group_cache {
>   };
>   
>   struct btrfs_extent_ops {
> -       int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
> -		           u64 hint_byte, struct btrfs_key *ins);
> -       int (*free_extent)(struct btrfs_root *root, u64 bytenr,
> -		          u64 num_bytes);
> +	int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
> +			    u64 hint_byte, struct btrfs_key *ins);
> +	int (*free_extent)(struct btrfs_root *root, u64 bytenr,
> +			   u64 num_bytes);
>   };
>   
>   struct btrfs_device;
> @@ -2117,9 +2117,10 @@ BTRFS_SETGET_STACK_FUNCS(stack_qgroup_limit_rsv_exclusive,
>   static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
>   						    struct btrfs_item *e)
>   {
> -       unsigned long offset;
> -       offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
> -       return btrfs_item_size(eb, e) - offset;
> +	unsigned long offset;
> +
> +	offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
> +	return btrfs_item_size(eb, e) - offset;
>   }
>   
>   /* this returns the number of file bytes represented by the inline item.
> diff --git a/utils.c b/utils.c
> index 07173ee..356bdce 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1485,15 +1485,15 @@ char *__strncpy__null(char *dest, const char *src, size_t n)
>    */
>   static int check_label(const char *input)
>   {
> -       int len = strlen(input);
> +	int len = strlen(input);
>   
> -       if (len > BTRFS_LABEL_SIZE - 1) {
> +	if (len > BTRFS_LABEL_SIZE - 1) {
>   		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
>   			input, BTRFS_LABEL_SIZE - 1);
> -               return -1;
> -       }
> +		return -1;
> +	}
>   
> -       return 0;
> +	return 0;
>   }
>   
>   static int set_label_unmounted(const char *dev, const char *label)
> 

