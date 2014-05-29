Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbaE2MnK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 08:43:10 -0400
Date: Thu, 29 May 2014 14:43:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device
 add/remove.
Message-ID: <20140529124308.GA29992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397638952-16691-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397638952-16691-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 05:02:32PM +0800, Qu Wenruo wrote:
> @@ -1704,10 +1720,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  
>  	ret = 0;
>  
> -	/* Notify udev that device has changed */
> -	if (bdev)
> +	if (bdev) {
> +		/* Notify udev that device has changed */
>  		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
>  
> +		/* Update ctime/mtime for device path for libblkid */
> +		update_dev_time(device_path);

The change on the device comes after the uevent notification, is it
possible that the event is delivered and processed before the device
times are updated? I would say so.

> +	}
> +
>  error_brelse:
>  	brelse(bh);
>  	if (bdev)
