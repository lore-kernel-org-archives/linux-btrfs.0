Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab3IIQ4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 12:56:19 -0400
Date: Mon, 9 Sep 2013 18:56:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: add ability to query/change feature bits online
Message-ID: <20130909165616.GS32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <521CFB62.7010600@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <521CFB62.7010600@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 27, 2013 at 03:17:54PM -0400, Jeff Mahoney wrote:
> +static int btrfs_ioctl_add_features(struct file *file, void __user *arg)
> +{
...

		spin_lock(&fs_info->super_lock);

> +		flags = btrfs_super_compat_flags(super_block);
> +		flags |= features.compat_flags;
> +		btrfs_set_super_compat_flags(super_block, flags);
> +
> +		flags = btrfs_super_compat_ro_flags(super_block);
> +		flags |= features.compat_ro_flags;
> +		btrfs_set_super_compat_ro_flags(super_block, flags);
> +
> +		flags = btrfs_super_incompat_flags(super_block);
> +		flags |= features.incompat_flags;
> +		btrfs_set_super_incompat_flags(super_block, flags);

		spin_unlock(&fs_info->super_lock);

> +		return btrfs_end_transaction(trans, root);
> +	}
> +
> +	return 0;
> +}
