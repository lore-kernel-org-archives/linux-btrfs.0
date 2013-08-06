Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20562 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab3HFDQG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 23:16:06 -0400
Message-ID: <52006AB2.1080605@cn.fujitsu.com>
Date: Tue, 06 Aug 2013 11:17:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
References: <52006509.1060207@redhat.com>
In-Reply-To: <52006509.1060207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 05 Aug 2013 21:52:57 -0500, Eric Sandeen wrote:
> If an array is 5 chars in size:
> 
>        char answer[5];
> 
> and we write the 6th char (counting from 0)...
> 
>        answer[5] = '\0';
> 
> we get problems:
> 
> cmds-chunk.c: In function 'ask_user.clone.0':
> cmds-chunk.c:1343: warning: array subscript is above array bounds
> 
> Fix it...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Thanks to fix this problem.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> 
> 
> diff --git a/cmds-chunk.c b/cmds-chunk.c
> index 03314de..7c3257c 100644
> --- a/cmds-chunk.c
> +++ b/cmds-chunk.c
> @@ -1340,7 +1340,7 @@ again:
>  		}
>  		i++;
>  	}
> -	answer[5] = '\0';
> +	answer[4] = '\0';
>  	__fpurge(stdin);
>  
>  	if (strlen(answer) == 0) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

