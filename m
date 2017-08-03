Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751739AbdHCPCS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 11:02:18 -0400
Subject: Re: [PATCH] Btrfs: avoid unnecessarily locking inode when clearing a
 range
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20170727185255.5122-1-fdmanana@kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <e19d649f-8ee6-fade-f4d9-c303a2e01fcc@fb.com>
Date: Thu, 3 Aug 2017 11:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <20170727185255.5122-1-fdmanana@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/27/2017 02:52 PM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the range being cleared was not marked for defrag and we are not
> about to clear the range from the defrag status, we don't need to
> lock and unlock the inode.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks Filipe, looks like it goes all the way back to:

commit 47059d930f0e002ff851beea87d738146804726d
Author: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Date:   Thu Jul 3 18:22:07 2014 +0800

     Btrfs: make defragment work with nodatacow option

I can't see how the inode lock is required here.

Reviewed-by: Chris Mason <clm@fb.com>

-chris

> ---
>   fs/btrfs/inode.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index eb495e956d53..51c45c0a8553 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1797,10 +1797,11 @@ static void btrfs_clear_bit_hook(void *private_data,
>   	u64 len = state->end + 1 - state->start;
>   	u32 num_extents = count_max_extents(len);
>   
> -	spin_lock(&inode->lock);
> -	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
> +	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
> +		spin_lock(&inode->lock);
>   		inode->defrag_bytes -= len;
> -	spin_unlock(&inode->lock);
> +		spin_unlock(&inode->lock);
> +	}
>   
>   	/*
>   	 * set_bit and clear bit hooks normally require _irqsave/restore
> 
