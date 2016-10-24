Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64962 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755302AbcJXDFC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 23:05:02 -0400
Subject: Re: [PATCH 1/4] btrfs-progs: Fix memory leak in
 write_raid56_with_parity
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
References: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <323dcc3a-0378-49d2-57ad-a94ee2c07e00@cn.fujitsu.com>
Date: Mon, 24 Oct 2016 11:04:49 +0800
MIME-Version: 1.0
In-Reply-To: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/24/2016 10:43 AM, Qu Wenruo wrote:
> Ebs and pointers are allocated, but if any of the allocation failed, we
> should free the allocated memory.
>
> Reported-by: David Sterba <dsterba@suse.cz>
> Resolves-Coverity-CID: 1296749

Sorry, wrong CID here,
Correct ones are:
Resolves-Coverity-CID: 1374101
Resolves-Coverity-CID: 1374100


> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  volumes.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/volumes.c b/volumes.c
> index a7abd92..f687b0d 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -2120,8 +2120,11 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
>
>  	ebs = malloc(sizeof(*ebs) * multi->num_stripes);
>  	pointers = malloc(sizeof(*pointers) * multi->num_stripes);
> -	if (!ebs || !pointers)
> +	if (!ebs || !pointers) {
> +		free(ebs);
> +		free(pointers);
>  		return -ENOMEM;
> +	}
>
>  	if (stripe_len > alloc_size)
>  		alloc_size = stripe_len;
>


