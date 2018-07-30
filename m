Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbeG3Pv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 11:51:27 -0400
Subject: Re: [PATCH] btrfs: backref.c: Use ERR_CAST() to return error code
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1532568195.git.misono.tomohiro@jp.fujitsu.com>
 <936a6171-4c1e-2bda-af79-9be9ebe6a8fd@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <38f87e6c-dd40-7631-0a78-ee9fbe25c3b1@suse.com>
Date: Mon, 30 Jul 2018 17:16:11 +0300
MIME-Version: 1.0
In-Reply-To: <936a6171-4c1e-2bda-af79-9be9ebe6a8fd@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.07.2018 04:22, Misono Tomohiro wrote:
> Use ERR_CAST() instead of void * to make meaning clear.
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/backref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 7ce0b5f9e99e..9f231bbccb1e 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -2231,7 +2231,7 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
>  
>  	fspath = init_data_container(total_bytes);
>  	if (IS_ERR(fspath))
> -		return (void *)fspath;
> +		return ERR_CAST(fspath);
>  
>  	ifp = kmalloc(sizeof(*ifp), GFP_KERNEL);
>  	if (!ifp) {
> 
