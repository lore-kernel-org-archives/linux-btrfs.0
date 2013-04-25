Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab3DYMvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 08:51:08 -0400
Date: Thu, 25 Apr 2013 14:51:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH] btrfs-progs: mkfs seg fault for wrong free
Message-ID: <20130425125104.GI16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366892142-21920-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366892142-21920-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 08:15:42PM +0800, Anand Jain wrote:
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1290,8 +1290,10 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
>  				fprintf(stderr, "Warning, could not drop caches\n");
>  		}
>  		close(device->fd);
> -		kfree(device->name);
> -		kfree(device->label);
> +		if (device->name)
> +			kfree(device->name);
> +		if (device->label)
> +			kfree(device->label);

As we're going to use the kernel sources directly, we should also keep
the semantics of the helpers. The in-kernel kfree accepts NULL and does
nothing in that case, so should the userspace replacement which is now
implemented as:

#define kfree(x) free(x)

>  		kfree(device);
>  	}
>  	kfree(fs_info->fs_devices);
> diff --git a/utils.c b/utils.c
> index 7b028a7..8104465 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -484,6 +484,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
>  	device = kmalloc(sizeof(*device), GFP_NOFS);
>  	if (!device)
>  		return -ENOMEM;
> +	memset(device, 0, sizeof(*device));

Please replace the above kmalloc with kzalloc instead.

> +	
>  	buf = kmalloc(sectorsize, GFP_NOFS);
>  	if (!buf) {
>  		kfree(device);
