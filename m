From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs-progs: remove a redundant
	btrfs_find_block_group() call
Date: Wed, 22 Jul 2009 10:41:53 -0400
Message-ID: <20090722144153.GD29886@think>
References: <4A66BD5D.9060403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: LiYu <raise.sail@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A66BD5D.9060403@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2009 at 03:18:53PM +0800, LiYu wrote:
> 
> It seem that we have a redundant btrfs_find_block_group() call in extent-tree.c/find_search_start(), is this guess right?

Thanks for sending this patch along.

-chris

