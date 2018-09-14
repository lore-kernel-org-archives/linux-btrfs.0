Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbeINMnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 08:43:17 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58CD1AE98
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 07:30:05 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: convert: Make read_disk_extent() return more
 meaningful -EIO other -1
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180914072505.15916-1-wqu@suse.com>
 <20180914072505.15916-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <00482e71-cc8d-dda8-e0df-2e569ddedab1@suse.com>
Date: Fri, 14 Sep 2018 10:30:03 +0300
MIME-Version: 1.0
In-Reply-To: <20180914072505.15916-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.09.2018 10:25, Qu Wenruo wrote:
> When pread64() returns value smaller than expected, it normally means
> EIO, so just return -EIO to replace the intermediate number.
> So when IO fails, we should be able to get more meaningful error number
> of than EPERM.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  convert/source-fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/convert/source-fs.c b/convert/source-fs.c
> index b6d08370428a..5660a22cc652 100644
> --- a/convert/source-fs.c
> +++ b/convert/source-fs.c
> @@ -201,7 +201,7 @@ int read_disk_extent(struct btrfs_root *root, u64 bytenr,
>  	ret = 0;
>  fail:
>  	if (ret > 0)
> -		ret = -1;
> +		ret = -EIO;
>  	return ret;
>  }
>  
> 
