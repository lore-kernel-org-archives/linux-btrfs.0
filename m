Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61009 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbaH2Sby (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 14:31:54 -0400
Message-ID: <5400C714.9030107@fb.com>
Date: Fri, 29 Aug 2014 14:31:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] Btrfs: implement repair function when direct
 read fails
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com> <1406625850-32168-12-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406625850-32168-12-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/29/2014 05:24 AM, Miao Xie wrote:
> This patch implement data repair function when direct read fails.
> 
> The detail of the implementation is:
> - When we find the data is not right, we try to read the data from the other
>   mirror.
> - After we get right data, we write it back to the corrupted mirror.
> - And if the data on the new mirror is still corrupted, we will try next
>   mirror until we read right data or all the mirrors are traversed.
> - After the above work, we set the uptodate flag according to the result.
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 08e65e9..56b1546 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -698,7 +719,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
>  
>  	fs_info = end_io_wq->info;
>  	end_io_wq->error = err;
> -	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
> +
> +	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
> +		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
> +				NULL);
> +	else
> +		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);

It's not clear why this one is using INIT_WORK instead of
btrfs_init_work, or why we're calling directly into queue_work instead
of btrfs_queue_work.  What am I missing?

-chris
