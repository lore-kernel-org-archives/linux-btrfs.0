Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19853 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755834AbaCLAgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 20:36:06 -0400
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add missing kfree in btrfs_destroy_workqueue
Date: Wed, 12 Mar 2014 00:34:45 +0000
Message-ID: <531FABE6.6090008@cn.fujitsu.com>
References: <1394548304-8741-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1394548304-8741-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 11 Mar 2014 14:31:44 +0000, Filipe David Borba Manana wrote:
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/async-thread.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 00623dd..66532b8 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -315,6 +315,7 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue *wq)
>  	if (wq->high)
>  		__btrfs_destroy_workqueue(wq->high);
>  	__btrfs_destroy_workqueue(wq->normal);
> +	kfree(wq);
>  }
>  
>  void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max)
Thanks for finding out the missing kfree.
That's my fault....

Qu.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
