Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53973 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab2KEP2N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 10:28:13 -0500
Date: Mon, 5 Nov 2012 16:28:10 +0100
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Don't trust the superblock label and simply
 printk("%s") it
Message-ID: <20121105152810.GI3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1352121049-4140-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352121049-4140-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 05, 2012 at 02:10:49PM +0100, Stefan Behrens wrote:
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -764,10 +764,13 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	devid = btrfs_stack_device_id(&disk_super->dev_item);
>  	transid = btrfs_super_generation(disk_super);
>  	total_devices = btrfs_super_num_devices(disk_super);
> -	if (disk_super->label[0])
> +	if (disk_super->label[0]) {
> +		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
> +			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';

The label set via 'btrfs fi label' will also set the last-1 byte to 0,
so this keeps it as expected, although it is silent.

thanks,
Reviewed-by: David Sterba <dsterba@suse.cz>

