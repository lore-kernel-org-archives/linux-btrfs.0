Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:59279 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3DSKAx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 06:00:53 -0400
Message-ID: <517115D4.6000105@giantdisaster.de>
Date: Fri, 19 Apr 2013 12:00:52 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvol show could take more than one subvol
References: <1366364309-28525-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366364309-28525-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Apr 2013 17:38:29 +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-subvolume.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 74e2130..e3b8032 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -800,16 +800,18 @@ static int cmd_subvol_show(int argc, char **argv)
>  	struct btrfs_list_filter_set *filter_set;
>  	char tstr[256];
>  	char uuidparse[37];
> -	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
> +	char *fullpath, *svpath = NULL, *mnt;
>  	char raw_prefix[] = "\t\t\t\t";
>  	u64 sv_id, mntid;
>  	int fd = -1, mntfd = -1;
>  	int ret = -1;
>  
> -	if (check_argc_exact(argc, 2))
> +	if (check_argc_min(argc, 2))
>  		usage(cmd_subvol_show_usage);
> -
> -	fullpath = realpath(argv[1], 0);
> +again:
> +	mnt = NULL;
> +	fullpath = NULL;

The "fullpath = NULL" line above is not needed because of the following
line.

> +	fullpath = realpath(argv[optind++], 0);
>  	if (!fullpath) {
>  		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
>  			argv[1], strerror(errno));

                        argv[optind - 1], strerror(errno));


> @@ -939,6 +941,8 @@ out:
>  	if (fullpath)
>  		free(fullpath);
>  
> +	if (optind < argc)
> +		goto again;
>  	return ret;
>  }
>  
> 

