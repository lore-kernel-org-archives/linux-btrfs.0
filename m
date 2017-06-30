Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752015AbdF3QBE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 12:01:04 -0400
Date: Fri, 30 Jun 2017 17:59:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: Re: [PATCH v2 3/4] btrfs: Warn the user when the legacy
 btrfs_qgroup_create API is used
Message-ID: <20170630155953.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>
 <20170526204449.GA18209@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526204449.GA18209@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 08:44:50PM +0000, Sargun Dhillon wrote:
> This patch adds a warning to let the user know when the legacy
> qgroup creation / removal API is in use. Eventually, we can
> deprecate this API.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>  fs/btrfs/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 78c8321..fba409f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5027,6 +5027,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> +	pr_info_once("btrfs: Usage of deprecated btrfs_qgroup_create ioctl\n");

Would be better to use the btrfs_info helper otherwise the user does not
know on which filesystem it happened.

Deprecation of v1 makes sense but the ioctl must stay anyway, similar to
other v1/v2 ioctls that we have. In long-term and long-living distros,
the applications probably use the deprecated interfaces so the syslog
message causes noise. I'd first document the deprecation and add a real
warning in a few releases maybe.
