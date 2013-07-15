Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab3GOOGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 10:06:37 -0400
Message-ID: <51E401E7.8040202@redhat.com>
Date: Mon, 15 Jul 2013 09:06:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: fix the long lines
References: <1373866527-10604-1-git-send-email-anand.jain@oracle.com> <1373866527-10604-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866527-10604-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/15/13 12:35 AM, Anand Jain wrote:
> trivial: cmds-replace.c contains long lines fix it

I realize that this is total bikeshedding, so you can take or leave it, but:

One downside to this is that it makes it a little harder to grep for strings
when they get arbitrarily split across lines.

One thing XFS userspace did was to out-dent in cases like this, i.e.:

> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -211,8 +211,8 @@ static int cmd_start_replace(int argc, char **argv)
>  		struct btrfs_ioctl_dev_info_args *di_args = NULL;
>  
>  		if (atoi(srcdev) == 0) {
> -			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
> -				srcdev);
> +			fprintf(stderr,
> +	"Error: Failed to parse the numerical devid value '%s'\n",
> +				srcdev);
>  			goto leave_with_error;
>  		}
>  		start_args.start.srcdevid = (__u64)atoi(srcdev);

so that the strings remain more easily searchable.  Just a thought; maybe folks hate that idea but I thought I'd throw it out there.

But as a more topical review:

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-replace.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/cmds-replace.c b/cmds-replace.c
> index 6397bb5..c68986a 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -211,8 +211,8 @@ static int cmd_start_replace(int argc, char **argv)
>  		struct btrfs_ioctl_dev_info_args *di_args = NULL;
>  
>  		if (atoi(srcdev) == 0) {
> -			fprintf(stderr, "Error: Failed to parse the numerical devid value '%s'\n",
> -				srcdev);
> +			fprintf(stderr, "Error: Failed to parse the numerical "\
                                                                               ^
There's no need for the line continuation, this isn't a macro.  ;)

To split the line this way just do:

> +			fprintf(stderr, "Error: Failed to parse the numerical "
> +				"devid value '%s'\n", srcdev);

-Eric

>  			goto leave_with_error;
>  		}
>  		start_args.start.srcdevid = (__u64)atoi(srcdev);
> @@ -235,8 +235,8 @@ static int cmd_start_replace(int argc, char **argv)
>  				break;
>  		free(di_args);
>  		if (i == fi_args.num_devices) {
> -			fprintf(stderr, "Error: '%s' is not a valid devid for filesystem '%s'\n",
> -				srcdev, path);
> +			fprintf(stderr, "Error: '%s' is not a valid devid for "\
> +				"filesystem '%s'\n", srcdev, path);
>  			goto leave_with_error;
>  		}
>  	} else {
> @@ -283,7 +283,8 @@ static int cmd_start_replace(int argc, char **argv)
>  				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
>  	if (ret >= 0 && !force_using_targetdev) {
>  		fprintf(stderr,
> -			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
> +			"Error, target device %s contains filesystem, "\
> +			"use '-f' to force overwriting.\n",
>  			dstdev);
>  		goto leave_with_error;
>  	}
> @@ -321,7 +322,8 @@ static int cmd_start_replace(int argc, char **argv)
>  	if (do_not_background) {
>  		if (ret) {
>  			fprintf(stderr,
> -				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
> +				"ERROR: ioctl(DEV_REPLACE_START) failed "\
> +				"on \"%s\": %s, %s\n",
>  				path, strerror(errno),
>  				replace_dev_result2string(start_args.result));
>  			goto leave_with_error;
> @@ -330,7 +332,8 @@ static int cmd_start_replace(int argc, char **argv)
>  		if (start_args.result !=
>  		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
>  			fprintf(stderr,
> -				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" returns error: %s\n",
> +				"ERROR: ioctl(DEV_REPLACE_START) on \"%s\" "\
> +				"returns error: %s\n",
>  				path,
>  				replace_dev_result2string(start_args.result));
>  			goto leave_with_error;
> 

