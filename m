Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:53693 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab2IFVVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 17:21:15 -0400
Date: Thu, 6 Sep 2012 14:21:14 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix our overcommit math
Message-ID: <20120906212114.GD15825@lenny.home.zabbo.net>
References: <1346965415-12820-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346965415-12820-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	used = space_info->bytes_used + space_info->bytes_reserved +
> +		space_info->bytes_pinned + space_info->bytes_readonly +
> +		space_info->bytes_may_use;
> +		spin_lock(&root->fs_info->free_chunk_lock);
> +	avail = root->fs_info->free_chunk_space;

Is that lock only protecting the read of free_chunk_space?  Might as
well just acquire and release around that and get all that local math
out of the critical section?

(I first thought the spin_lock() was accidentally dropped until I saw it
hiding all tabbed in and smushed against the used assignment.)

>  		spin_lock(&space_info->lock);
> -		if (space_info->bytes_used + space_info->bytes_reserved +
> -		    space_info->bytes_pinned + space_info->bytes_readonly +
> -		    space_info->bytes_may_use + orig <=
> -		    space_info->total_bytes) {
> +		if (can_overcommit(root, space_info, orig, !trans)) {
>  			spin_unlock(&space_info->lock);

*spots lock nesting, puts on his "only guy who runs with lockdep"
worrying hat*

- z
