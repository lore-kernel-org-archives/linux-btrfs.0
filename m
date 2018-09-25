Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23811 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726021AbeIYHA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 03:00:57 -0400
Subject: Re: [PATCH 1/2] btrfs: Use NAME_MAX to replace intermediate number of
 BTRFS_NAME_LEN
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180925000626.15474-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <77b230ed-8564-9474-5074-aae06b119f0d@cn.fujitsu.com>
Date: Tue, 25 Sep 2018 09:03:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180925000626.15474-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/25/18 8:06 AM, Qu Wenruo wrote:
> Since we're following the name size limit of linux, just use NAME_MAX.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/ctree.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 53af9f5253f4..5ab6d1f6e055 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -65,7 +65,7 @@ struct btrfs_ordered_sum;
>    * we can actually store much bigger names, but lets not confuse the rest
>    * of linux
>    */
> -#define BTRFS_NAME_LEN 255
> +#define BTRFS_NAME_LEN NAME_MAX
>   
>   /*
>    * Theoretical limit is larger, but we keep this down to a sane
> 
