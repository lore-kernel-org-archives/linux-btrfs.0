Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3GBQjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 12:39:17 -0400
Date: Tue, 2 Jul 2013 18:39:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: avoid memory leak in btrfs_close_devices
Message-ID: <20130702163915.GK18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51C994D5.3070509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C994D5.3070509@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 25, 2013 at 09:02:13PM +0800, Wang Sheng-Hui wrote:
> +static void btrfs_close_device(struct btrfs_device *device)
> +{
> +	close(device->fd);
> +	device->fd = -1;
> +	device->writeable = 0;

It's not necessary to set these variables when we're freeing the
structure immediatelly.

> +	if (device->name)
> +		kfree(device->name);
> +	kfree(device);
> +}

david
