Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13175 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753375AbbHUJ1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 05:27:47 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Byongho Lee'" <bhlee.kernel@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <1440147112-62543-1-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1440147112-62543-1-git-send-email-bhlee.kernel@gmail.com>
Subject: RE: [PATCH v2] btrfs-progs: fix memory leaks in error path
Date: Fri, 21 Aug 2015 17:27:11 +0800
Message-ID: <016701d0dbf3$8f556aa0$ae003fe0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Zhao Lei <zhaolei@cn.fujitsu.com>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Byongho Lee
> Sent: Friday, August 21, 2015 4:52 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH v2] btrfs-progs: fix memory leaks in error path
> 
> This patch includes below fixes in error path:
> 1. fix memory leaks if realloc() fails
> 2. add missing call free_history() before return error in scrub_read_file()
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
> ---
> changelog:
> v2:
>   Add one more fix for memory leak when realloc() fails by Zhao Lei's comment.
> ---
>  btrfs-list.c |  8 ++++++++
>  cmds-scrub.c | 18 ++++++++++++++----
>  cmds-send.c  |  7 ++++++-
>  qgroup.c     |  8 ++++++++
>  4 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c index 875a89dc4ef0..d54de61aec01 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -254,11 +254,15 @@ static int btrfs_list_setup_comparer(struct
> btrfs_list_comparer_set **comp_set,
>  	BUG_ON(set->ncomps > set->total);
> 
>  	if (set->ncomps == set->total) {
> +		void *tmp;
> +
>  		size = set->total + BTRFS_LIST_NCOMPS_INCREASE;
>  		size = sizeof(*set) + size * sizeof(struct btrfs_list_comparer);
> +		tmp = set;
>  		set = realloc(set, size);
>  		if (!set) {
>  			fprintf(stderr, "memory allocation failed\n");
> +			free(tmp);
>  			exit(1);
>  		}
> 
> @@ -1232,11 +1236,15 @@ int btrfs_list_setup_filter(struct
> btrfs_list_filter_set **filter_set,
>  	BUG_ON(set->nfilters > set->total);
> 
>  	if (set->nfilters == set->total) {
> +		void *tmp;
> +
>  		size = set->total + BTRFS_LIST_NFILTERS_INCREASE;
>  		size = sizeof(*set) + size * sizeof(struct btrfs_list_filter);
> +		tmp = set;
>  		set = realloc(set, size);
>  		if (!set) {
>  			fprintf(stderr, "memory allocation failed\n");
> +			free(tmp);
>  			exit(1);
>  		}
> 
> diff --git a/cmds-scrub.c b/cmds-scrub.c index 5a85dc473c94..91cf67841849
> 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -502,12 +502,16 @@ again:
>  		}
>  		return p;
>  	}
> -	if (avail == -1)
> +	if (avail == -1) {
> +		free_history(p);
>  		return ERR_PTR(-errno);
> +	}
>  	avail += old_avail;
> 
>  	i = 0;
>  	while (i < avail) {
> +		void *tmp;
> +
>  		switch (state) {
>  		case 0: /* start of file */
>  			ret = scrub_kvread(&i,
> @@ -534,11 +538,17 @@ again:
>  				continue;
>  			}
>  			++curr;
> +			tmp = p;
>  			p = realloc(p, (curr + 2) * sizeof(*p));
> -			if (p)
> -				p[curr] = malloc(sizeof(**p));
> -			if (!p || !p[curr])
> +			if (!p) {
> +				free_history(tmp);
>  				return ERR_PTR(-errno);
> +			}
> +			p[curr] = malloc(sizeof(**p));
> +			if (!p[curr]) {
> +				free_history(p);
> +				return ERR_PTR(-errno);
> +			}
>  			memset(p[curr], 0, sizeof(**p));
>  			p[curr + 1] = NULL;
>  			++state;
> diff --git a/cmds-send.c b/cmds-send.c
> index a0b7f95fa23a..95fd4aaacbf8 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -174,11 +174,16 @@ out:
> 
>  static int add_clone_source(struct btrfs_send *s, u64 root_id)  {
> +	void *tmp;
> +
> +	tmp = s->clone_sources;
>  	s->clone_sources = realloc(s->clone_sources,
>  		sizeof(*s->clone_sources) * (s->clone_sources_count + 1));
> 
> -	if (!s->clone_sources)
> +	if (!s->clone_sources) {
> +		free(tmp);
>  		return -ENOMEM;
> +	}
>  	s->clone_sources[s->clone_sources_count++] = root_id;
> 
>  	return 0;
> diff --git a/qgroup.c b/qgroup.c
> index dc04b033b145..327abd645f16 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -465,12 +465,16 @@ int btrfs_qgroup_setup_comparer(struct
> btrfs_qgroup_comparer_set  **comp_set,
>  	BUG_ON(set->ncomps > set->total);
> 
>  	if (set->ncomps == set->total) {
> +		void *tmp;
> +
>  		size = set->total + BTRFS_QGROUP_NCOMPS_INCREASE;
>  		size = sizeof(*set) +
>  		       size * sizeof(struct btrfs_qgroup_comparer);
> +		tmp = set;
>  		set = realloc(set, size);
>  		if (!set) {
>  			fprintf(stderr, "memory allocation failed\n");
> +			free(tmp);
>  			exit(1);
>  		}
> 
> @@ -836,12 +840,16 @@ int btrfs_qgroup_setup_filter(struct
> btrfs_qgroup_filter_set **filter_set,
>  	BUG_ON(set->nfilters > set->total);
> 
>  	if (set->nfilters == set->total) {
> +		void *tmp;
> +
>  		size = set->total + BTRFS_QGROUP_NFILTERS_INCREASE;
>  		size = sizeof(*set) + size * sizeof(struct btrfs_qgroup_filter);
> 
> +		tmp = set;
>  		set = realloc(set, size);
>  		if (!set) {
>  			fprintf(stderr, "memory allocation failed\n");
> +			free(tmp);
>  			exit(1);
>  		}
>  		memset(&set->filters[set->total], 0,
> --
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

