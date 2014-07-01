Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbaGARti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 13:49:38 -0400
Date: Tue, 1 Jul 2014 19:49:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: device delete must be sysloged
Message-ID: <20140701174936.GR1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
 <1404147537-19873-2-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404147537-19873-2-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 12:58:57AM +0800, Anand Jain wrote:
> as in the disk add patch, disk detached from the volume must be
> recorded in the syslog as well for the same reason.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 16d20df..be4e097 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2530,6 +2530,9 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>  	mutex_unlock(&root->fs_info->volume_mutex);
>  	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
>  
> +	if (!ret)
> +		btrfs_info(root->fs_info, "disk deleted %s",vol_args->name);

Same comment as for the 'add' patch

Reviewed-by: David Sterba <dsterba@suse.cz>
