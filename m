Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbcGLMCl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 08:02:41 -0400
Date: Tue, 12 Jul 2016 14:02:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160712120245.GA10595@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>

On Mon, Jul 11, 2016 at 10:21:35AM -0700, Liu Bo wrote:
> +		}
>  
>  		trans = btrfs_start_transaction(dev_root, 0);
> -		BUG_ON(IS_ERR(trans));
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			btrfs_info(fs_info,

This could be btrfs_info_in_rcu for clarity (using the rcu_string)

> +		 "%s:%d fails on btrfs_start_transaction() right after shrinking devivce %s (original size is %llu new size is %llu",
> +				   __func__, __LINE__,

I'm not sure the function and line is necessary, we don't use it
anywhere else. I'd suggest a slight modification:

		"resize: unable to start transaction after shrinking device %s (error %d), old size %llu, new size %llu"

> +				   rcu_str_deref(device->name), old_size,
> +				   old_size - size_to_free);
> +			goto error;
> +		}
>  
>  		ret = btrfs_grow_device(trans, device, old_size);
> -		BUG_ON(ret);
> +		if (ret) {
> +			btrfs_end_transaction(trans, dev_root);
> +			/* btrfs_grow_device never returns ret > 0 */
> +			WARN_ON(ret > 0);
> +			btrfs_info(fs_info,
> +		 "%s:%d fails on btrfs_grow_device() right after shrinking devivce %s (original size is %llu new size is %llu",

"resize: unable to grow device after shrinking device %s (error %d), old size %llu, new size %llu"
