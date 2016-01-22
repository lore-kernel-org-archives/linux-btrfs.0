Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4536 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbcAVBec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 20:34:32 -0500
Date: Thu, 21 Jan 2016 20:34:19 -0500
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: async-thread: Fix a use-after-free error for trace
Message-ID: <20160122013419.7zejmkam2cwgzs5d@floor.thefacebook.com>
References: <1453426118-11198-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1453426118-11198-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 09:28:38AM +0800, Qu Wenruo wrote:
> Parameter of trace_btrfs_work_queued() can be freed in its workqueue.
> So no one use use that pointer after queue_work().
> 
> Fix the user-after-free bug by move the trace line before queue_work().
> 
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/async-thread.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 88d9af3..5fb60ea 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -328,8 +328,8 @@ static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
>  		list_add_tail(&work->ordered_list, &wq->ordered_list);
>  		spin_unlock_irqrestore(&wq->list_lock, flags);
>  	}
> -	queue_work(wq->normal_wq, &work->normal_work);
>  	trace_btrfs_work_queued(work);
> +	queue_work(wq->normal_wq, &work->normal_work);
>  }

Thanks

-chris
