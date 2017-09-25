Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932135AbdIYHaT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:30:19 -0400
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
Date: Mon, 25 Sep 2017 10:30:15 +0300
MIME-Version: 1.0
In-Reply-To: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.09.2017 10:41, Misono, Tomohiro wrote:
> "btrfs subvolume create/delete" outputs the message of "Create/Delete
> subvolume ..." even when an operation fails.
> Since it is confusing, let's outputs the message only when an operation succeeds.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  cmds-subvolume.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 666f6e0..6d4b0fe 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -189,7 +189,6 @@ static int cmd_subvol_create(int argc, char **argv)
>  	if (fddst < 0)
>  		goto out;
>  
> -	printf("Create subvolume '%s/%s'\n", dstdir, newname);
>  	if (inherit) {
>  		struct btrfs_ioctl_vol_args_v2	args;
>  
> @@ -213,6 +212,7 @@ static int cmd_subvol_create(int argc, char **argv)
>  		error("cannot create subvolume: %s", strerror(errno));
>  		goto out;
>  	}
> +	printf("Create subvolume '%s/%s'\n", dstdir, newname);

Please change the verb to past tense, more strongly signaling success -
i.e. "Created subvolume"

>  
>  	retval = 0;	/* success */
>  out:
> @@ -337,9 +337,6 @@ again:
>  		goto out;
>  	}
>  
> -	printf("Delete subvolume (%s): '%s/%s'\n",
> -		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
> -		? "commit" : "no-commit", dname, vname);
>  	memset(&args, 0, sizeof(args));
>  	strncpy_null(args.name, vname);
>  	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
> @@ -349,6 +346,9 @@ again:
>  		ret = 1;
>  		goto out;
>  	}
> +	printf("Delete subvolume (%s): '%s/%s'\n",
> +		commit_mode == 2 || (commit_mode == 1 && cnt + 1 == argc)
> +		? "commit" : "no-commit", dname, vname);

Ditto: "Deleted subvolume"

>  
>  	if (commit_mode == 1) {
>  		res = wait_for_commit(fd);
> 
