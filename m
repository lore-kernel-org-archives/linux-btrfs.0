Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3AGQDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 11:03:52 -0500
Date: Mon, 7 Jan 2013 17:03:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: replace simple_strtoull() with kstrtoull() in
 btrfs_ioctl_resize()
Message-ID: <20130107160350.GI20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50E8F545.5030706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E8F545.5030706@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 11:53:41AM +0800, Jeff Liu wrote:
> -		devid = simple_strtoull(devstr, &end, 10);
> +		ret = kstrtoull(devstr, 10, &devid);
> +		if (ret) {
> +			pr_err("btrfs: resizer unable to parse device %s\n",
> +				devstr);

Code looks ok, I would prefer the message error text to say:

			pr_err("btrfs: resize unable to parse device id %s\n",
				devstr);

but that's maybe just me :)
david
