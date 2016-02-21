Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34885 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbcBUVIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 16:08:05 -0500
Subject: Re: [PATCH] Btrfs: async: fixed a brace coding style issue
To: Philippe Loctaux <phil@philippeloctaux.com>, clm@fb.com
References: <1456087842-29045-1-git-send-email-phil@philippeloctaux.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Simon Quigley <sqawesome99@gmail.com>
Message-ID: <56CA2732.7020106@gmail.com>
Date: Sun, 21 Feb 2016 15:08:02 -0600
MIME-Version: 1.0
In-Reply-To: <1456087842-29045-1-git-send-email-phil@philippeloctaux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/21/2016 02:50 PM, Philippe Loctaux wrote:
> Fixed a coding style issue.
>
> Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
> ---
>   fs/btrfs/async-thread.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 5fb60ea..7914dd2 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -227,9 +227,9 @@ static inline void thresh_exec_hook(struct __btrfs_workqueue *wq)
>   out:
>   	spin_unlock(&wq->thres_lock);
>   
> -	if (need_change) {
> +	if (need_change)
>   		workqueue_set_max_active(wq->normal_wq, wq->current_active);
> -	}
> +
>   }
>   
>   static void run_ordered_work(struct __btrfs_workqueue *wq)
I thought I proposed this exact patch...hmm...
