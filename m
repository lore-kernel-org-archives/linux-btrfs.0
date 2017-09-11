Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44724 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdIKOGi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 10:06:38 -0400
Date: Mon, 11 Sep 2017 07:06:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <20170911140623.vkjziug2eookrnyw@merlins.org>
References: <20170911052623.31999-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170911052623.31999-1-quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs-progs: Output time elapsed for each major tree it
 checked
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 02:26:23PM +0900, Qu Wenruo wrote:
> Marc reported that "btrfs check --repair" runs much faster than "btrfs
> check", which is quite weird.
> 
> This patch will add time elapsed for each major tree it checked, for
> both original mode and lowmem mode, so we can have a clue what's going
> wrong.
 
Thanks.
Sadly, as you may have seen in the other thread, after I ran clear_cache
to fix another bug, now check --repair takes around 3H is is slower than
regular check, as it's expected to be.
But next time I need to run check, I'll try check vs check --repair
again and report the times if they are weird.

In the meantime you can check in btrfs-progs WIP and maybe someone else
will get useful time data before I can again.

Thanks,
Marc

> Reported-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  cmds-check.c | 21 +++++++++++++++++++--
>  utils.h      | 24 ++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 006edbde..fee806cd 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -5318,13 +5318,16 @@ static int do_check_fs_roots(struct btrfs_fs_info *fs_info,
>  			  struct cache_tree *root_cache)
>  {
>  	int ret;
> +	struct timer timer;
>  
>  	if (!ctx.progress_enabled)
>  		fprintf(stderr, "checking fs roots\n");
> +	start_timer(&timer);
>  	if (check_mode == CHECK_MODE_LOWMEM)
>  		ret = check_fs_roots_v2(fs_info);
>  	else
>  		ret = check_fs_roots(fs_info, root_cache);
> +	printf("done in %d seconds\n", stop_timer(&timer));
>  
>  	return ret;
>  }
> @@ -11584,14 +11587,16 @@ out:
>  static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>  {
>  	int ret;
> +	struct timer timer;
>  
>  	if (!ctx.progress_enabled)
>  		fprintf(stderr, "checking extents\n");
> +	start_timer(&timer);
>  	if (check_mode == CHECK_MODE_LOWMEM)
>  		ret = check_chunks_and_extents_v2(fs_info);
>  	else
>  		ret = check_chunks_and_extents(fs_info);
> -
> +	printf("done in %d seconds\n", stop_timer(&timer));
>  	return ret;
>  }
>  
> @@ -12772,6 +12777,7 @@ int cmd_check(int argc, char **argv)
>  	int qgroups_repaired = 0;
>  	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
>  	int force = 0;
> +	struct timer timer;
>  
>  	while(1) {
>  		int c;
> @@ -12953,8 +12959,11 @@ int cmd_check(int argc, char **argv)
>  	if (repair)
>  		ctree_flags |= OPEN_CTREE_PARTIAL;
>  
> +	printf("opening btrfs filesystem\n");
> +	start_timer(&timer);
>  	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
>  				  chunk_root_bytenr, ctree_flags);
> +	printf("done in %d seconds\n", stop_timer(&timer));
>  	if (!info) {
>  		error("cannot open file system");
>  		ret = -EIO;
> @@ -13115,8 +13124,10 @@ int cmd_check(int argc, char **argv)
>  		else
>  			fprintf(stderr, "checking free space cache\n");
>  	}
> +	start_timer(&timer);
>  	ret = check_space_cache(root);
>  	err |= !!ret;
> +	printf("done in %d seconds\n", stop_timer(&timer));
>  	if (ret) {
>  		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
>  			error("errors found in free space tree");
> @@ -13140,18 +13151,22 @@ int cmd_check(int argc, char **argv)
>  	}
>  
>  	fprintf(stderr, "checking csums\n");
> +	start_timer(&timer);
>  	ret = check_csums(root);
>  	err |= !!ret;
> +	printf("done in %d seconds\n", stop_timer(&timer));
>  	if (ret) {
>  		error("errors found in csum tree");
>  		goto out;
>  	}
>  
> -	fprintf(stderr, "checking root refs\n");
>  	/* For low memory mode, check_fs_roots_v2 handles root refs */
>  	if (check_mode != CHECK_MODE_LOWMEM) {
> +		fprintf(stderr, "checking root refs\n");
> +		start_timer(&timer);
>  		ret = check_root_refs(root, &root_cache);
>  		err |= !!ret;
> +		printf("done in %d seconds\n", stop_timer(&timer));
>  		if (ret) {
>  			error("errors found in root refs");
>  			goto out;
> @@ -13186,8 +13201,10 @@ int cmd_check(int argc, char **argv)
>  
>  	if (info->quota_enabled) {
>  		fprintf(stderr, "checking quota groups\n");
> +		start_timer(&timer);
>  		ret = qgroup_verify_all(info);
>  		err |= !!ret;
> +		printf("done in %d seconds\n", stop_timer(&timer));
>  		if (ret) {
>  			error("failed to check quota groups");
>  			goto out;
> diff --git a/utils.h b/utils.h
> index d28a05a6..159487db 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -172,4 +172,28 @@ u64 rand_u64(void);
>  unsigned int rand_range(unsigned int upper);
>  void init_rand_seed(u64 seed);
>  
> +/* Utils to report time duration */
> +struct timer {
> +	time_t start;
> +};
> +
> +static inline void start_timer(struct timer *t)
> +{
> +	time(&t->start);
> +}
> +
> +/*
> + * Stop timer and return the time elapsed in int
> + *
> + * int should be large enough to "btrfs check" and avoid
> + * type converting.
> + */
> +static inline int stop_timer(struct timer *t)
> +{
> +	time_t end;
> +
> +	time(&end);
> +
> +	return (int)(difftime(end, t->start));
> +}
>  #endif
> -- 
> 2.14.1
> 
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
