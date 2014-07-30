Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34479 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaG3GD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 02:03:27 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 075FE3EE0AE
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:03:26 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 195D6AC0398
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:03:25 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C6C741DB8038
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:03:24 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 9DDADBD661A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:03:20 +0900 (JST)
Message-ID: <53D88AA2.90804@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 15:03:14 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs-progs: adjust the return values for scrub
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/07/17 11:40), Gui Hecheng wrote:
> o Return 0 to indicate success,
>    when detected errors were corrected during scrubbing.
>    P.s. This is also to facilitate scripting when return value
>         is to be checked.
> o Warn the users if there are uncorrectable errors detected.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>   cmds-scrub.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index 5265a2b..f9e2b40 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -1514,14 +1514,17 @@ out:
>   	}
>   	close_file_or_dir(fdmnt, dirstream);
>   
> -	if (nothing_to_resume)
> -		return 2;
>   	if (err)
>   		return 1;
> -	if (e_correctable)
> +	if (nothing_to_resume)
> +		return 2;
> +	if (e_uncorrectable) {
> +		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
>   		return 3;
> -	if (e_uncorrectable)
> -		return 4;
> +	}
> +	if (e_correctable)
> +		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
> +

1. ERR() messages are not necessary since start command
   reports its status in the middle of scrub_start().
   It includes both the number of correctable/uncorrectable errors.

2. It prints messages even if this program runs as foreground mode.
   Checking do_print is necessary.

3. Whether correctable/uncorrectable error exists in a file system
   is not related to the exist status of scrub. The role of this
   program is

    a) reading all data from all devices and verify checksums, and
    b) correct checksum errors "if possible".

   So, I consider scrub only returns error if this program itself
   failed to finish.

Thanks,
Satoru

>   	return 0;
>   }
>   
> 

