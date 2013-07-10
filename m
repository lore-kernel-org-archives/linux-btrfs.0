Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3GJDi1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 23:38:27 -0400
Message-ID: <51DCD854.8050401@oracle.com>
Date: Wed, 10 Jul 2013 11:43:16 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix memory leak in open_file_or_dir()
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks.


Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 07/10/2013 07:01 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> After calling opendir() successfully, closedir() should be
> also called to free memory. Otherwise, memory leak happens.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>   utils.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index 7b4cd74..0afff55 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1480,7 +1480,7 @@ int open_file_or_dir(const char *fname)
>   {
>   	int ret;
>   	struct stat st;
> -	DIR *dirstream;
> +	DIR *dirstream = NULL;
>   	int fd;
>
>   	ret = stat(fname, &st);
> @@ -1496,9 +1496,10 @@ int open_file_or_dir(const char *fname)
>   	} else {
>   		fd = open(fname, O_RDWR);
>   	}
> -	if (fd < 0) {
> -		return -3;
> -	}
> +	if (fd < 0)
> +		fd = -3;
> +	if (dirstream)
> +		closedir(dirstream);
>   	return fd;
>   }
>
>
