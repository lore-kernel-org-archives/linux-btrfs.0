Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34465 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2JaAHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:07:22 -0400
Date: Wed, 31 Oct 2012 01:07:17 +0100
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't allow degraded mount if too many devices
 are missing
Message-ID: <20121031000717.GC3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351617376-5208-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351617376-5208-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch looks ok, juste one thing that caught my attention (and does not block
the patch)

a bit of context:

1224                 if (fs_info->fs_devices->rw_devices == 0) {
1225                         ret = -EACCES;
1226                         goto restore;
1227                 }

> +		if (fs_info->fs_devices->missing_devices >
> +		     fs_info->num_tolerated_disk_barrier_failures &&
> +		    !(*flags & MS_RDONLY)) {
> +			printk(KERN_WARNING
> +			       "Btrfs: too many missing devices, writeable remount is not allowed\n");
> +			ret = -EACCES;

the error code is strange, but it also appears above and has been there for
ages. We're not checking any sort of permissions so this looks confusing,
probably EINVAL or EPERM ?

> +			goto restore;
> +		}
> +
>  		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
>  			ret = -EINVAL;
>  			goto restore;
