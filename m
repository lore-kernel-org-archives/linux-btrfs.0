Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54932 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752440AbeGEHrY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2018 03:47:24 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: fix nanosecs in task_period_start
To: =?UTF-8?Q?St=c3=a9phane_Lesimple?= <stephane_btrfs@lesimple.fr>,
        <linux-btrfs@vger.kernel.org>
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
 <1530732014-5449-2-git-send-email-stephane_btrfs@lesimple.fr>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <30c8d16c-6cc3-cfc7-8068-87d30954c988@cn.fujitsu.com>
Date: Thu, 5 Jul 2018 15:53:40 +0800
MIME-Version: 1.0
In-Reply-To: <1530732014-5449-2-git-send-email-stephane_btrfs@lesimple.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/05/2018 03:20 AM, Stéphane Lesimple wrote:
> This is a single-line fix on the preexisting task_period_start function.
> 
> Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   task-utils.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/task-utils.c b/task-utils.c
> index 12b0002..284cbb3 100644
> --- a/task-utils.c
> +++ b/task-utils.c
> @@ -102,7 +102,7 @@ int task_period_start(struct task_info *info, unsigned int period_ms)
>   	info->periodic.wakeups_missed = 0;
>   
>   	sec = period_ms / 1000;
> -	ns = (period_ms - (sec * 1000)) * 1000;
> +	ns = (period_ms - (sec * 1000)) * 1000 * 1000;
>   	itval.it_interval.tv_sec = sec;
>   	itval.it_interval.tv_nsec = ns;
>   	itval.it_value.tv_sec = sec;
> 


