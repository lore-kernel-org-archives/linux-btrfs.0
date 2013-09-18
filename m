Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab3IROGC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 10:06:02 -0400
Date: Wed, 18 Sep 2013 16:05:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clmason@fusionio.com
Subject: Re: [patch 1/9] btrfs: add ioctls to query/change feature bits online
Message-ID: <20130918140558.GZ6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130916181910.799140428@suse.com>
 <20130916182017.776301648@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130916182017.776301648@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 02:19:11PM -0400, Jeff Mahoney wrote:
> +static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
> +{
...
> +	trans = btrfs_start_transaction(root, 1);

	trans = btrfs_start_transaction(root, 0);

> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);

