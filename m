Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53891 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbeBBLld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 06:41:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8872CAECF
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 11:41:32 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs-progs: volumes: Allow find_free_dev_extent() to
 return maximum hole size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-6-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>
Date: Fri, 2 Feb 2018 13:41:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180202081929.15162-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.02.2018 10:19, Qu Wenruo wrote:
> Just as kernel find_free_dev_extent(), allow it to return maximum hole
> size for us to build device list for later chunk allocator rework.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  volumes.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/volumes.c b/volumes.c
> index b47ff1f392b5..f4009ffa7c9e 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -516,10 +516,10 @@ out:
>  }
>  
>  static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
> -				u64 *start)
> +				u64 *start, u64 *len)
>  {
>  	/* FIXME use last free of some kind */
> -	return find_free_dev_extent_start(device, num_bytes, 0, start, NULL);
> +	return find_free_dev_extent_start(device, num_bytes, 0, start, len);

Why do we need the free_dev_extent() wrapper over free_dev_extent_start
at all?
>  }
>  
>  static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
> @@ -543,7 +543,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>  	 * is responsible to make sure it's free.
>  	 */
>  	if (!convert) {
> -		ret = find_free_dev_extent(device, num_bytes, start);
> +		ret = find_free_dev_extent(device, num_bytes, start, NULL);
>  		if (ret)
>  			goto err;
>  	}
>
