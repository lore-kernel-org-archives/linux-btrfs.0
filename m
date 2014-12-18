Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25324 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbaLRHFc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 02:05:32 -0500
Message-ID: <1418886214.5832.6.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] Fix wrong memory free on check_is_root
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        naota <naota@elisp.net>
Date: Thu, 18 Dec 2014 15:03:34 +0800
In-Reply-To: <54926FB4.6050604@jp.fujitsu.com>
References: <54926FB4.6050604@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-12-18 at 15:09 +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Date: Thu, 18 Dec 2014 14:35:22 +0900
> 
> @tmp is freed even if its allocation fails.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> ---
>  cmds-property.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/cmds-property.c b/cmds-property.c
> index a764293..a4bc127 100644
> --- a/cmds-property.c
> +++ b/cmds-property.c
> @@ -140,31 +140,32 @@ static int check_is_root(const char *object)

Hi Satoru,
	" tmp = malloc()
	  if (!tmp) {
		...
		goto out;
	  }
	"
Actually, if the malloc() fails, it returns a NULL, and the free()
handles the NULL internally.
I think there is no special need to deal with this case by the prog
itself.
 
Thanks,
Gui

>  	if (ret < 0) {
>  		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", object,
>  				strerror(-ret));
> -		goto out;
> +		goto free_tmp_out;
>  	}
>  
>  	ret = get_fsid(tmp, fsid2, 1);
>  	if (ret == -ENOTTY) {
>  		ret = 0;
> -		goto out;
> +		goto free_tmp_out;
>  	} else if (ret == -ENOTDIR) {
>  		ret = 1;
> -		goto out;
> +		goto free_tmp_out;
>  	} else if (ret < 0) {
>  		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", tmp,
>  			strerror(-ret));
> -		goto out;
> +		goto free_tmp_out;
>  	}
>  
>  	if (memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
>  		ret = 0;
> -		goto out;
> +		goto free_tmp_out;
>  	}
>  
>  	ret = 1;
>  
> -out:
> +free_tmp_out:
>  	free(tmp);
> +out:
>  	return ret;
>  }
>  


