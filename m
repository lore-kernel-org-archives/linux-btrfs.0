Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728149AbeIUXpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 19:45:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A9D7AF4A
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 17:55:38 +0000 (UTC)
Subject: Re: [PATCH] btrfs: use common helper instead of open coding a bit
 test
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20180921122634.12138-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aa879b44-21ca-4fe5-e52a-ab20f4a1f6be@suse.com>
Date: Fri, 21 Sep 2018 20:55:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180921122634.12138-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.09.2018 15:26, David Sterba wrote:
> The helper does the same math and we take care about the special case
> when flags is 0 too.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 909c578506ee..26eb388db343 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3691,7 +3691,7 @@ static int alloc_profile_is_valid(u64 flags, int extended)
>  		return !extended; /* "0" is valid for usual profiles */
>  
>  	/* true if exactly one bit set */
> -	return (flags & (flags - 1)) == 0;
> +	return is_power_of_2(flags);
>  }
>  
>  static inline int balance_need_close(struct btrfs_fs_info *fs_info)
> 
