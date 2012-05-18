Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54236 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab2ERNBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 09:01:32 -0400
Date: Fri, 18 May 2012 15:01:23 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: do not resize a seeding device
Message-ID: <20120518130123.GJ24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1337256489-20887-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337256489-20887-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 08:08:08PM +0800, Liu Bo wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1303,6 +1303,13 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>  		ret = -EINVAL;
>  		goto out_free;
>  	}
> +	if (device->fs_devices && device->fs_devices->seeding) {
> +		printk(KERN_INFO "btrfs: resizer unable to apply on "
> +		       "seeding device %s\n", device->name);
> +		ret = -EACCES;

I think EINVAL would be more appropriate. EACCESS is about permissions
which do not make much sense in context of resizing devices, besides
that CAP_SYS_ADMIN is required anyway (and checked a few lines above).


david
