Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752464AbdK0TQn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 14:16:43 -0500
Date: Mon, 27 Nov 2017 20:14:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: fi defrag: clean up duplicate code if
 find errors
Message-ID: <20171127191446.GI3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171107022431.17938-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171107022431.17938-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 07, 2017 at 10:24:30AM +0800, Su Yue wrote:
> In function cmd_filesystem_defrag(), lines of code for error handling
> are duplicate and hard to expand in further.
> 
> Create a jump label for errors.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-filesystem.c | 46 +++++++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 7728430f16a1..0893a44f28fe 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1029,29 +1029,27 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  		if (fd < 0) {
>  			error("cannot open %s: %s", argv[i],
>  					strerror(errno));
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			ret = fd;

The fd will be -1, we might need to save the last error, though it's not
directly used (yet).

> +			goto next;
>  		}
> -		if (fstat(fd, &st)) {
> +
> +		ret = fstat(fd, &st);
> +		if (ret) {
>  			error("failed to stat %s: %s",
>  					argv[i], strerror(errno));
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			goto next;

Similar here.

>  		}
>  		if (!(S_ISDIR(st.st_mode) || S_ISREG(st.st_mode))) {
>  			error("%s is not a directory or a regular file",
>  					argv[i]);
> -			defrag_global_errors++;
> -			close_file_or_dir(fd, dirstream);
> -			continue;
> +			ret = -EINVAL;

So it's consistent with that one.

> +			goto next;
>  		}
>  		if (recursive && S_ISDIR(st.st_mode)) {
>  			ret = nftw(argv[i], defrag_callback, 10,
>  						FTW_MOUNT | FTW_PHYS);
>  			if (ret == ENOTTY)
> -				exit(1);
> +				break;

Please split this change, it changes the logic and should be properly
described in the changelog.

Otherwise ok.
