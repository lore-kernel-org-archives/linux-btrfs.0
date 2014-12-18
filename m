Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63456 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752414AbaLRHLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 02:11:37 -0500
Message-ID: <1418886575.5832.9.camel@localhost.localdomain>
Subject: Re: [PATCH 2/2] btrfs-progs: fix the file system root is regarded
 as non-root
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        naota <naota@elisp.net>
Date: Thu, 18 Dec 2014 15:09:35 +0800
In-Reply-To: <54927765.6060207@jp.fujitsu.com>
References: <54926FB4.6050604@jp.fujitsu.com>
	 <54927765.6060207@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-12-18 at 15:42 +0900, Satoru Takeuchi wrote:
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
> 
> ---
>  cmds-property.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds-property.c b/cmds-property.c
> index a4bc127..640af99 100644
> --- a/cmds-property.c
> +++ b/cmds-property.c
> @@ -125,11 +125,22 @@ static int check_is_root(const char *object)
>  	u8 fsid[BTRFS_FSID_SIZE];
>  	u8 fsid2[BTRFS_FSID_SIZE];
>  	char *tmp;
> +	char *rp;
> +
> +	rp = realpath(object, NULL);
> +	if (!rp) {
> +		ret = -ENOMEM;
Hi Satoru，

IMO, ret = -errno may be better, because there are many possible return
values of realpath().

Thanks,
Gui

> +		goto out;
> +	}
> +	if (!strcmp(rp, "/")) {
> +		ret = 0;
> +		goto free_rp_out;
> +	}
>  
>  	tmp = malloc(strlen(object) + 5);
>  	if (!tmp) {
>  		ret = -ENOMEM;
> -		goto out;
> +		goto free_rp_out;
>  	}
>  	strcpy(tmp, object);
>  	if (tmp[strlen(tmp) - 1] != '/')
> @@ -165,6 +176,8 @@ static int check_is_root(const char *object)
>  
>  free_tmp_out:
>  	free(tmp);
> +free_rp_out:
> +	free(rp);
>  out:
>  	return ret;
>  }


