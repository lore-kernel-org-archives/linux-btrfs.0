Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab2GaB1N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 21:27:13 -0400
Message-ID: <50173463.5060405@cn.fujitsu.com>
Date: Tue, 31 Jul 2012 09:26:59 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alexander Karbstein <alexander.karbstein@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Enabled setting root subvolume with subvolid=0
References: <CA+=FuiWE4QVFrbTY_dQyABABJyvD=xtpEFKe4Ob9pqeZQ9NysA@mail.gmail.com> <1343696005-23703-1-git-send-email-alexander.karbstein@gmail.com>
In-Reply-To: <1343696005-23703-1-git-send-email-alexander.karbstein@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2012 08:53 AM, Alexander Karbstein wrote:

> The command btrfs subvolume set-default 0 /path/to/fs changed the
> default subvolume to whatever subvolume was currently mounted on
> /path/to/fs. This patch changes this behaviour to set the default
> subvolume to BTRFS_FS_TREE_OBJECTID in case the user asks for
> subvolid=0
> 

> Signed-off-by: Alexander Karbstein <alexander.karbstein@gmail.com>
> ---
>  btrfs_cmds.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index f2b6355..699d9b0 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -964,6 +964,11 @@ int do_set_default_subvol(int nargs, char **argv)
>  		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
>  		return 30;
>  	}
> +	
> +	/* Using the original root fs tree */
> +	if (objectid == 0ULL) {
> +		objectid = BTRFS_FS_TREE_OBJECTID;
> +	}
>  	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
>  	e = errno;
>  	close(fd);


Seems that you're using an old btrfs-prog source code, now the file is cmds-subvolume.c

And also checkpatch.pl complains about style errors while checking this.

thanks,
liubo
