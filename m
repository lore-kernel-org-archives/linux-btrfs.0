Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2JSI7V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 04:59:21 -0400
Message-ID: <50811681.2000702@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 16:59:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs-progs: fix irrelevant string in the subvol
 path
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com> <1350627837-27639-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-3-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	fri, 19 Oct 2012 14:23:55 +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> btrfs su list -a /btrfs/sv1
> ID 256 gen 6 top level 5 path <FS_TREE>/sv1
> ID 258 gen 6 top level 5 path <FS_TREE>/ss1

I don't agree with this patch, because after applying this patch, the output of 'btrfs su list'
is the same as 'btrfs su list'. I hope 'btrfs su list' just list the subvolumes in the specified
path. In this way, the user can find the path of the subvolume easily (the specified path + the
path in the result of 'btrfs su list').

Could you make it output the path which is relative to the path that the user specified? 

Thanks
Miao

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-subvolume.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index a33c352..f8beecc 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -306,7 +306,7 @@ static int cmd_subvol_list(int argc, char **argv)
>  	u64 top_id;
>  	int ret;
>  	int c;
> -	char *subvol;
> +	char *subvol, *mnt = NULL;
>  	int is_tab_result = 0;
>  	int is_list_all = 0;
>  	struct option long_options[] = {
> @@ -398,9 +398,18 @@ static int cmd_subvol_list(int argc, char **argv)
>  		return 13;
>  	}
>  
> -	fd = open_file_or_dir(subvol);
> +	ret = find_mount_root(subvol, &mnt);
> +	if (ret < 0) {
> +		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
> +				"%s\n", subvol,
> +			strerror(-ret));
> +		return 12;
> +	}
> +
> +	fd = open_file_or_dir(mnt);
>  	if (fd < 0) {
>  		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
> +		free(mnt);
>  		return 12;
>  	}
>  
> @@ -412,6 +421,8 @@ static int cmd_subvol_list(int argc, char **argv)
>  
>  	ret = btrfs_list_subvols(fd, filter_set, comparer_set,
>  				is_tab_result);
> +
> +	free(mnt);
>  	if (ret)
>  		return 19;
>  	return 0;
> 


