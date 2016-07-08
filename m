Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbcGHO4U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 10:56:20 -0400
Date: Fri, 8 Jul 2016 16:56:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH RFC] don't background blkdev_put()
Message-ID: <20160708145631.GL13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466686913-7832-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466686913-7832-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 09:01:53PM +0800, Anand Jain wrote:
> As of now we are calling blkdev_put() under call_rcu,
> actually which isn't necessary. Unless I am missing
> something. This is a try out patch to know the same.

Moving the blkdev_put after sync and invalidate, and out of the rcu
callback looks safe (and better) to me. Please create a helper for the
code that does

> +	if (device->bdev && device->writeable) {
> +		sync_blockdev(device->bdev);
> +		invalidate_bdev(device->bdev);
> +	}
> +	if (device->bdev)
> +		blkdev_put(device->bdev, device->mode);

It's repeated 3 times, justifies a helper.
