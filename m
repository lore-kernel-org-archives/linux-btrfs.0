Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaFWOP7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 10:15:59 -0400
Date: Mon, 23 Jun 2014 16:15:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: delete invalid output file when
 btrfs-image failed
Message-ID: <20140623141557.GG1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1403142363-29482-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403142363-29482-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 09:46:02AM +0800, Gui Hecheng wrote:
> When btrfs-image failed to create an image, the invalid output file
> had better be deleted to prevent being used mistakenly in the future.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  btrfs-image.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/btrfs-image.c b/btrfs-image.c
> index 549722c..b235b87 100644
> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -2598,8 +2598,16 @@ int main(int argc, char *argv[])
>  out:
>  	if (out == stdout)
>  		fflush(out);
> -	else
> +	else {
>  		fclose(out);
> +		if (ret && create) {
> +			ret = unlink(target);

The previous value is overwritten and in case of unlink() success it's
returned as success of main(), which is not true. So a local variable
has to be used instead.

> +			if (ret)
> +				fprintf(stderr,
> +					"unlink output file failed : %s\n",
> +					strerror(errno));
> +		}
> +	}
>  
>  	return !!ret;
