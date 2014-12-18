Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16459 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbaLRIBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 03:01:46 -0500
Message-ID: <1418889589.7146.6.camel@localhost.localdomain>
Subject: Re: [PATCH v2] Fix wrong memory free on check_is_root
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        naota <naota@elisp.net>
Date: Thu, 18 Dec 2014 15:59:49 +0800
In-Reply-To: <549284AE.9020201@jp.fujitsu.com>
References: <549284AE.9020201@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-12-18 at 16:39 +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> When "/" is Btrfs, "btrfs property <subcommand> /" regards it
> as non-root by mistake.
> 
> check_is_root() regards @object as a file system root if
> the following two conditions are satisfied.
> 
>  a) Both @object and its parent directory are Btrfs object
>     (file system root, subvolume, inode, and device
>     used for Btrfs).
>  b) fsid of the above mentioned two objects are different.
> 
> It doesn't work if @object is "/" because, in this case,
> fsid of "/" and its parent (it's also "/"), are the same.
> 
> * Test environment
> 
> Two Btrfs file system (not subvolume) "/" and "/home/sat/mnt".
> 
> * How to reproduce
> 
> Submit "btrfs prop get" against the above mentioned file systems.
> 
> * Test Result
> 
> ** Actual result (without my patch)
> 
> ==========================
> # btrfs prop get /home/sat/mnt/
> ro=false
> label=                 # label is displayed because it's a file system root
> # btrfs prop get /
> ro=false               # label is not displayed even if it's a file system root
> ==========================
> ** Expected result (with my patch)
> 
> ==========================
> # ./btrfs-new prop get btrfs-auto-test/
> # ./btrfs-new prop get /home/sat/mnt/
> ro=false
> label=
> # ./btrfs-new prop get /             
> ro=false
> label=foo            # label is displayed
> ===========================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Reported-by: Naohiro Aota <naota@elisp.net>

Looks good to me.
Reviewed-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Thanks,
Gui

> ---
> changelog
> v2: Return a correct error code when realpath() fails.
>     Thank you Gui Hecheng for pointing my mistake out.
>     https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40204.html
> ---
>  cmds-property.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds-property.c b/cmds-property.c
> index a764293..6501338 100644
> --- a/cmds-property.c
> +++ b/cmds-property.c
> @@ -124,7 +124,18 @@ static int check_is_root(const char *object)
>  	int ret;
>  	u8 fsid[BTRFS_FSID_SIZE];
>  	u8 fsid2[BTRFS_FSID_SIZE];
> -	char *tmp;
> +	char *tmp = NULL;
> +	char *rp;
> +
> +	rp = realpath(object, NULL);
> +	if (!rp) {
> +		ret = -errno;
> +		goto out;
> +	}
> +	if (!strcmp(rp, "/")) {
> +		ret = 0;
> +		goto out;
> +	}
>  
>  	tmp = malloc(strlen(object) + 5);
>  	if (!tmp) {
> @@ -165,6 +176,7 @@ static int check_is_root(const char *object)
>  
>  out:
>  	free(tmp);
> +	free(rp);
>  	return ret;
>  }
>  


