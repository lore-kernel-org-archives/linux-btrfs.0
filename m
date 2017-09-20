Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38081 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdITMlH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 08:41:07 -0400
Subject: Re: [PATCH v2] fs:btrfs: return -ENOMEM on allocation failure.
To: Allen Pais <allen.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <1505888266-23526-1-git-send-email-allen.lkml@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d1348471-04e8-5aeb-3bd1-2d8b03a84a60@oracle.com>
Date: Wed, 20 Sep 2017 20:48:48 +0800
MIME-Version: 1.0
In-Reply-To: <1505888266-23526-1-git-send-email-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/20/2017 02:17 PM, Allen Pais wrote:
> v2: return -ENOMEM from btrfsic_dev_state_alloc() too.
> 
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> ---
>   fs/btrfs/check-integrity.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 7d5a9b5..9db1e76 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2913,7 +2913,7 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
>   	state = kvzalloc(sizeof(*state), GFP_KERNEL);
>   	if (!state) {
>   		pr_info("btrfs check-integrity: allocation failed!\n");
> -		return -1;
> +		return -ENOMEM;
>   	}
>   
>   	if (!btrfsic_is_initialized) {
> @@ -2945,7 +2945,7 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
>   		if (NULL == ds) {
>   			pr_info("btrfs check-integrity: kmalloc() failed!\n");
>   			mutex_unlock(&btrfsic_mutex);
> -			return -1;
> +			return -ENOMEM;
>   		}
>   		ds->bdev = device->bdev;
>   		ds->state = state;
> 
