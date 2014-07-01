Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758319AbaGARqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 13:46:23 -0400
Date: Tue, 1 Jul 2014 19:46:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: device add must be sysloged
Message-ID: <20140701174621.GQ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 12:58:56AM +0800, Anand Jain wrote:
> when we add a new disk to the mounted btrfs we don't record it
> as of now, disk add is a critical change of btrfs configuration,
> it must be recorded in the syslog to help offline investigations
> of customer problems when reported.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 86d5474..16d20df 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2488,6 +2488,9 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
>  	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
>  	ret = btrfs_init_new_device(root, vol_args->name);
>  
> +	if (!ret)
> +		btrfs_info(root->fs_info, "disk added %s",vol_args->name);

Please use 'device' instead, I think we're moving away from 'disk'
everywhere else. Nitpick: space after the ,

Otherwise good,

Reviewed-by: David Sterba <dsterba@suse.cz>
