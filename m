Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:58699 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935557Ab3FTDoJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 23:44:09 -0400
Date: Wed, 19 Jun 2013 20:44:08 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Chris Mason <chris.mason@fusionio.com>
cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: hang on 3.9, 3.10-rc5
In-Reply-To: <20130618165952.9494.8953@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1306192043380.14838@cobra.newdream.net>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130618163706.GC19183@localhost.localdomain> <20130618165952.9494.8953@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Tue, 18 Jun 2013, Chris Mason wrote:
> [...]
> Very long way of saying I think we're one release_path short.  Sage, I
> haven't tested this at all yet, I was hoping to trigger it first.
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index c276ac9..c1954b3 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3730,6 +3730,7 @@ next_slot:
>  log_extents:
>  	if (fast_search) {
>  		btrfs_release_path(dst_path);
> +		btrfs_release_path(path);
>  		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
>  		if (ret) {
>  			err = ret;

This seems to be doing the trick.  I'll keep testing overnight, but so far 
so good!

Thanks-
sage

