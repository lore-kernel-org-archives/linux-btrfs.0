Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754671AbaDHB1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 21:27:14 -0400
Message-ID: <534350AA.8030209@cn.fujitsu.com>
Date: Tue, 8 Apr 2014 09:28:10 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: Sergei Trofimovich <slyfox@gentoo.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix crash in remount(thread_pool=) case
References: <1396857346-24877-1-git-send-email-slyich@gmail.com>
In-Reply-To: <1396857346-24877-1-git-send-email-slyich@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


于 2014年04月07日 15:55, Sergei Trofimovich 写道:
> From: Sergei Trofimovich <slyfox@gentoo.org>
>
> Reproducer:
>      mount /dev/ubda /mnt
>      mount -oremount,thread_pool=42 /mnt
>
> Gives a crash:
>      ? btrfs_workqueue_set_max+0x0/0x70
>      btrfs_resize_thread_pool+0xe3/0xf0
>      ? sync_filesystem+0x0/0xc0
>      ? btrfs_resize_thread_pool+0x0/0xf0
>      btrfs_remount+0x1d2/0x570
>      ? kern_path+0x0/0x80
>      do_remount_sb+0xd9/0x1c0
>      do_mount+0x26a/0xbf0
>      ? kfree+0x0/0x1b0
>      SyS_mount+0xc4/0x110
>
> It's a call
>      btrfs_workqueue_set_max(fs_info->scrub_wr_completion_workers, new_pool_size);
> with
>      fs_info->scrub_wr_completion_workers = NULL;
>
> as scrub wqs get created only on user's demand.
>
> Patch skips not-created-yet workqueues.
>
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
> CC: Chris Mason <clm@fb.com>
> CC: Josef Bacik <jbacik@fb.com>
> CC: linux-btrfs@vger.kernel.org
>
> ---
>   fs/btrfs/async-thread.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index ecb5832..5a201d8 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -323,6 +323,8 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue *wq)
>   
>   void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max)
>   {
> +	if (!wq)
> +		return;
>   	wq->normal->max_active = max;
>   	if (wq->high)
>   		wq->high->max_active = max;
Oh, that's my fault. You got me.

Thanks for the patch.
Qu.
