Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab3BDPs7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 10:48:59 -0500
Date: Mon, 4 Feb 2013 16:48:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [RESEND][PATCH] btrfs: add "no file data" flag to btrfs send
 ioctl
Message-ID: <20130204154856.GA8462@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130130224341.GZ12558@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130130224341.GZ12558@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 02:43:41PM -0800, Mark Fasheh wrote:
> @@ -4570,6 +4605,11 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>  	INIT_RADIX_TREE(&sctx->name_cache, GFP_NOFS);
>  	INIT_LIST_HEAD(&sctx->name_cache_list);
>  
> +	if (arg->flags & ~BTRFS_SEND_FLAG_NO_FILE_DATA)
> +		return -EINVAL;

Doing just return skips the cleanup block (goto out;), also the test can
be placed just after the access_ok() call and skip allocation and init
of sctx.

> +
> +	sctx->flags = arg->flags;
> +
>  	sctx->send_filp = fget(arg->send_fd);
>  	if (IS_ERR(sctx->send_filp)) {
>  		ret = PTR_ERR(sctx->send_filp);
