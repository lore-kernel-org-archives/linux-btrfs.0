Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:47331 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbdEANJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 May 2017 09:09:58 -0400
Date: Mon, 1 May 2017 15:09:41 +0200
From: Christian Brauner <christian.brauner@canonical.com>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: nazar@mokrynskyi.com, lakshmipathi.g@gmail.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: send: fail on first -ENODATA only
Message-ID: <20170501130941.hw7fuaovdnuvaxbc@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170429215405.1123-2-christian.brauner@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The original bug-reporter verified that my patch fixes the bug. See

https://bugzilla.kernel.org/show_bug.cgi?id=195597

Christian

On Sat, Apr 29, 2017 at 11:54:05PM +0200, Christian Brauner wrote:
> Returning -ENODATA is only considered invalid on the first run of the loop.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  cmds-receive.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/cmds-receive.c b/cmds-receive.c
> index b59f00e4..72e9c8f3 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -1091,6 +1091,7 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>  	char *dest_dir_full_path;
>  	char root_subvol_path[PATH_MAX];
>  	int end = 0;
> +	int iterations = 0;
>  
>  	dest_dir_full_path = realpath(tomnt, NULL);
>  	if (!dest_dir_full_path) {
> @@ -1198,13 +1199,18 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>  							 rctx,
>  							 rctx->honor_end_cmd,
>  							 max_errors);
> -		if (ret < 0 && ret == -ENODATA) {
> +		if (ret < 0) {
> +			if (ret != -ENODATA)
> +				goto out;
> +
>  			/* Empty stream is invalid */
> -			error("empty stream is not considered valid");
> -			ret = -EINVAL;
> -			goto out;
> -		} else if (ret < 0) {
> -			goto out;
> +			if (iterations == 0) {
> +				error("empty stream is not considered valid");
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +
> +			ret = 1;
>  		}
>  		if (ret > 0)
>  			end = 1;
> @@ -1213,6 +1219,8 @@ static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
>  		ret = finish_subvol(rctx);
>  		if (ret < 0)
>  			goto out;
> +
> +		iterations++;
>  	}
>  	ret = 0;
>  
> -- 
> 2.11.0
> 
