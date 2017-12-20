Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58197 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754425AbdLTH7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 02:59:53 -0500
Subject: Re: [PATCH v2] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com
References: <20171220051329.17413-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ba7b9776-8348-5381-3b20-e1807d8d8eda@suse.com>
Date: Wed, 20 Dec 2017 09:59:50 +0200
MIME-Version: 1.0
In-Reply-To: <20171220051329.17413-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.12.2017 07:13, Qu Wenruo wrote:
> btrfs_qgroup_inherit structure has two members, num_ref_copies and
> num_excl_copies, to info btrfs kernel modules to inherit (copy)
> rfer/excl numbers at snapshot/subvolume creation time.
> 
> Since qgroup number is already hard to maintain for multi-level qgroup
> scenario, allowing user to manually manipulate qgroup inherit is quite
> easy to screw up qgroup numbers.
> 
> Although btrfs-progs supports such inheritance specification, the
> options are hidden from user and not documented.
> So there is no need to allow user to manually specify inheritance in
> kernel.
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Overall I'm ok with the patch but I'd like to hear the opinion of other
developer about whether we can rename the fields.

> ---
> changelog:
> v2:
>   Don't return -ENOTTY, but just ignoring value set in
>   num_ref/excl_copies, suggested by Nikolay.
>   Don't modify the UAPI members, but add comment to deprecate them,
>   suggested by Omar.
>   And add Omar as first reporter.
> ---
>  fs/btrfs/qgroup.c          | 54 +++++++++++++---------------------------------
>  include/uapi/linux/btrfs.h |  4 ++--
>  2 files changed, 17 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 168fd03ca3ac..42c6b35d8d7f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2158,9 +2158,22 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (inherit) {
> +		/*
> +		 * num_excl/rfer_copies indicate how many qgroup pairs needs
> +		 * to be manually inherited (copy rfer or excl from src
> +		 * qgroup to dst, along with qgroup relationship added)
> +		 *
> +		 * Allowing user to manipulate inheritance can easily cause
> +		 * problem in multi-level qgroup scenario.
> +		 * And the ioctl interface is hidden in btrfs-progs for a long
> +		 * time, deprecate them should not be a big problem.
> +		 *
> +		 * Here we just ignore any value set in num_excl/rfer_copies,
> +		 * and only handles qgroup relationship specified by
> +		 * @num_qgroups.
> +		 */
>  		i_qgroups = (u64 *)(inherit + 1);
> -		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
> -		       2 * inherit->num_excl_copies;
> +		nums = inherit->num_qgroups;
>  		for (i = 0; i < nums; ++i) {
>  			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
>  
> @@ -2286,43 +2299,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
>  		++i_qgroups;
>  	}
>  
> -	for (i = 0; i <  inherit->num_ref_copies; ++i, i_qgroups += 2) {
> -		struct btrfs_qgroup *src;
> -		struct btrfs_qgroup *dst;
> -
> -		if (!i_qgroups[0] || !i_qgroups[1])
> -			continue;
> -
> -		src = find_qgroup_rb(fs_info, i_qgroups[0]);
> -		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
> -
> -		if (!src || !dst) {
> -			ret = -EINVAL;
> -			goto unlock;
> -		}
> -
> -		dst->rfer = src->rfer - level_size;
> -		dst->rfer_cmpr = src->rfer_cmpr - level_size;
> -	}
> -	for (i = 0; i <  inherit->num_excl_copies; ++i, i_qgroups += 2) {
> -		struct btrfs_qgroup *src;
> -		struct btrfs_qgroup *dst;
> -
> -		if (!i_qgroups[0] || !i_qgroups[1])
> -			continue;
> -
> -		src = find_qgroup_rb(fs_info, i_qgroups[0]);
> -		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
> -
> -		if (!src || !dst) {
> -			ret = -EINVAL;
> -			goto unlock;
> -		}
> -
> -		dst->excl = src->excl + level_size;
> -		dst->excl_cmpr = src->excl_cmpr + level_size;
> -	}
> -
>  unlock:
>  	spin_unlock(&fs_info->qgroup_lock);
>  out:
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index ce615b75e855..a10342d491bc 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -80,8 +80,8 @@ struct btrfs_qgroup_limit {
>  struct btrfs_qgroup_inherit {
>  	__u64	flags;
>  	__u64	num_qgroups;
> -	__u64	num_ref_copies;
> -	__u64	num_excl_copies;
> +	__u64	num_ref_copies;  /* DEPRECATED, will just be ignored */
> +	__u64	num_excl_copies; /* DEPRECATED, will just be ignored */
>  	struct btrfs_qgroup_limit lim;
>  	__u64	qgroups[0];
>  };
> 
