From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: set task state with schedule_timeout_uninterruptible()
Date: Tue, 27 Jul 2010 11:41:20 +0800
Message-ID: <4C4E5560.9060905@cn.fujitsu.com>
References: <1280132864-8266-1-git-send-email-segooon@gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: kernel-janitors@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Tejun Heo <tj@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280132864-8266-1-git-send-email-segooon@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 26 Jul 2010 12:27:43 +0400, Kulikov Vasiliy wrote:
> worker_loop() uses schedule_timeout() without setting state to
> STATE_(UN)INTERRUPTIBLE. As it is called in cycle without checking of
> pending signals, use schedule_timeout_uninterruptible().
> 
> Signed-off-by: Kulikov Vasiliy<segooon@gmail.com>
> ---
>   fs/btrfs/async-thread.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 7ec1409..54eb070 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -362,7 +362,7 @@ again:
>   				 * worker->working is still 1, so nobody
>   				 * is going to try and wake us up
>   				 */
> -				schedule_timeout(1);
> +				schedule_timeout_uninterruptible(1);

I found there is the same problem in the other place of the btrfs,
could you fix them?

Thanks!
Miao

>   				smp_mb();
>   				if (!list_empty(&worker->pending) ||
>   				    !list_empty(&worker->prio_pending))
