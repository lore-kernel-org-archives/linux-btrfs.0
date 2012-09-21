Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59276 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2IUIOw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 04:14:52 -0400
Received: by eaac11 with SMTP id c11so971039eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 01:14:51 -0700 (PDT)
Date: Fri, 21 Sep 2012 11:14:47 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete
 subvolumes
Message-ID: <20120921081447.GA1961@zambezi.lan>
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 02:54:08PM +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> With this user will be able to provide more than one subvolume
> to delete.
> eg: btrfs subvolume delete <subvol1> <subvol2>
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-subvolume.c |   36 ++++++++++++++++++++++++------------
>  man/btrfs.8.in   |    4 ++--
>  2 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index f4aa80f..cfeaa8d 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -188,31 +188,34 @@ int test_issubvolume(char *path)
>  }
>  
>  static const char * const cmd_subvol_delete_usage[] = {
> -	"btrfs subvolume delete <name>",
> -	"Delete a subvolume",
> +	"btrfs subvolume delete <subvolume> [<subvolume>...]",
> +	"Delete subvolume(s)",
>  	NULL
>  };
>  
>  static int cmd_subvol_delete(int argc, char **argv)
>  {
> -	int	res, fd, len, e;
> +	int	res, fd, len, e, cnt = 1, ret = 0;
>  	struct btrfs_ioctl_vol_args	args;
>  	char	*dname, *vname, *cpath;
>  	char	*path;
>  
> -	if (check_argc_exact(argc, 2))
> +	if (argc < 2)
>  		usage(cmd_subvol_delete_usage);

check_argc_min(argc, 2)

Haven't looked at the rest.

Thanks,

		Ilya
