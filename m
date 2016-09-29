Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47787 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933853AbcI2RhC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 13:37:02 -0400
Date: Thu, 29 Sep 2016 19:37:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: raid56: Add support for raid5 to
 calculate any stripe
Message-ID: <20160929173700.GF5531@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160928083004.17860-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160928083004.17860-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 28, 2016 at 04:30:03PM +0800, Qu Wenruo wrote:
> Add a new function raid5_gen_result() to calculate raid5 parity or
> recover data stripe.
> 
> Since now that raid6.c handles both raid5 and raid6, rename it to
> raid56.c.

Please split changes in this patch to the following:
- rename the file
- error handling of memory allocation failures
- the actual fix

A test would be very velcome, for all the cases the code handles, 2
devices, and more. But I'm not sure if we have support for that in the
testing suite.

> @@ -107,3 +108,47 @@ void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
>  	}
>  }
>  
> +static void xor_range(void *src, void *dst, size_t size)
> +{
> +	while (size) {
> +		*(unsigned long *) dst ^= *(unsigned long *) src;

This could lead to unaligned access, please update the types and
possibly add some sanity checks (alignemnt, length).

> +		src += sizeof(unsigned long);
> +		dst += sizeof(unsigned long);
> +		size -= sizeof(unsigned long);
> +	}
> +}
> +
> +/*
> + * Generate desired data/parity for RAID5
> + *
> + * @nr_devs:	Total number of devices, including parity
> + * @stripe_len:	Stripe length
> + * @data:	Data, with special layout:
> + * 		data[0]:	 Data stripe 0
> + * 		data[nr_devs-2]: Last data stripe
> + * 		data[nr_devs-1]: RAID5 parity
> + * @dest:	To generate which data. should follow above data layout
> + */
> +int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data)
> +{
> +	int i;
> +	char *buf = data[dest];
> +
> +	if (dest >= nr_devs || nr_devs < 2) {
> +		error("invalid parameter for %s", __func__);
> +		return -EINVAL;
> +	}
> +	/* Quich hack, 2 devs RAID5 is just RAID1, no need to calculate */

This is not a hack IMO, it could be a shortcut, a special case, an
optimization.

> +	if (nr_devs == 2) {
> +		memcpy(data[dest], data[1 - dest], stripe_len);
> +		return 0;
> +	}
> +	/* Just in case */

Such comment is not very helpful.

> +	memset(buf, 0, stripe_len);
> +	for (i = 0; i < nr_devs; i++) {
> +		if (i == dest)
> +			continue;
> +		xor_range(data[i], buf, stripe_len);
> +	}
> +	return 0;
> +}
> diff --git a/volumes.c b/volumes.c
> index da79751..718e67c 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -2108,12 +2108,14 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
>  {
>  	struct extent_buffer **ebs, *p_eb = NULL, *q_eb = NULL;
>  	int i;
> -	int j;
>  	int ret;
>  	int alloc_size = eb->len;
> +	void **pointers;

I see you're moving existing code, so if you're going to fix the types,
please do that in a separate patch as well.

> -	ebs = kmalloc(sizeof(*ebs) * multi->num_stripes, GFP_NOFS);
> -	BUG_ON(!ebs);
> +	ebs = malloc(sizeof(*ebs) * multi->num_stripes);
> +	pointers = malloc(sizeof(void *) * multi->num_stripes);
> +	if (!ebs || !pointers)
> +		return -ENOMEM;
>  
>  	if (stripe_len > alloc_size)
>  		alloc_size = stripe_len;
> @@ -2143,12 +2145,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
>  			q_eb = new_eb;
>  	}
>  	if (q_eb) {
> -		void **pointers;
> -
> -		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes,
> -				   GFP_NOFS);
> -		BUG_ON(!pointers);
> -
>  		ebs[multi->num_stripes - 2] = p_eb;
>  		ebs[multi->num_stripes - 1] = q_eb;
>  
> @@ -2159,17 +2155,14 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
>  		kfree(pointers);
>  	} else {
>  		ebs[multi->num_stripes - 1] = p_eb;
> -		memcpy(p_eb->data, ebs[0]->data, stripe_len);
> -		for (j = 1; j < multi->num_stripes - 1; j++) {
> -			for (i = 0; i < stripe_len; i += sizeof(u64)) {
> -				u64 p_eb_data;
> -				u64 ebs_data;
> -
> -				p_eb_data = get_unaligned_64(p_eb->data + i);
> -				ebs_data = get_unaligned_64(ebs[j]->data + i);
> -				p_eb_data ^= ebs_data;
> -				put_unaligned_64(p_eb_data, p_eb->data + i);
> -			}
> +		for (i = 0; i < multi->num_stripes; i++)
> +			pointers[i] = ebs[i]->data;
> +		ret = raid5_gen_result(multi->num_stripes, stripe_len,
> +				multi->num_stripes - 1, pointers);
> +		if (ret < 0) {
> +			free(ebs);
> +			free(pointers);
> +			return ret;
>  		}
>  	}
>  
> @@ -2180,7 +2173,8 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
>  			kfree(ebs[i]);
>  	}
>  
> -	kfree(ebs);
> +	free(ebs);
> +	free(pointers);
>  
>  	return 0;
