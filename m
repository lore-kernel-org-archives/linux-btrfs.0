Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47995 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932279AbaFDGrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 02:47:24 -0400
Message-ID: <538EC135.6060105@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 14:48:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Christian Hesse <mail@eworm.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
In-Reply-To: <1401794959-25907-1-git-send-email-mail@eworm.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 1/1] btrfs-progs: fix compiler warning
From: Christian Hesse <mail@eworm.de>
To: linux-btrfs@vger.kernel.org
Date: 2014年06月03日 19:29
> gcc 4.9.0 gives a warning: array subscript is above array bounds
>
> Checking for "greater or equal" instead of just "equal" fixes this.
>
> Signed-off-by: Christian Hesse <mail@eworm.de>
> ---
>   cmds-restore.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cmds-restore.c b/cmds-restore.c
> index 96b97e1..534a49e 100644
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -169,7 +169,7 @@ again:
>   			break;
>   	}
>   
> -	if (level == BTRFS_MAX_LEVEL)
> +	if (level >= BTRFS_MAX_LEVEL)
>   		return 1;
>   
>   	slot = path->slots[level] + 1;
Also I faied to reproduce the bug.
Using gcc-4.9.0-3 from Archlinux core repo.

It seems to be related to default gcc flags from distribution?

Thanks,
Qu
