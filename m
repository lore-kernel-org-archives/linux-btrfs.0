From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: hold enough space for global_rsv
Date: Fri, 27 Jan 2012 10:25:29 -0500
Message-ID: <20120127152529.GA991@shiny>
References: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 05:51:59PM +0800, Liu Bo wrote:
> I've kept hitting enospc warnings of global_rsv while running defragment on
> files:
> btrfs: block rsv returned -28
> WARNING: at fs/btrfs/extent-tree.c:5984 btrfs_alloc_free_block+0x333/0x340 [btrfs]()
> ...
> 
> I used a fio jobs to create a file with lots of fragments:
> $ filefrag /mnt/btrfs/foobar
> /mnt/btrfs/foobar: 66964 extents found
> 
> and then "btrfs fi defrag /mnt/btrfs/foobar && sync" would pop the warnings.
> 
> I found that the global_rsv size is just not enough for defragment, and didn't
> find any space leak in using global_rsv, so double it and go ahead.

I haven't pulled this one in yet, mostly because I think we need to take
a step back and look harder at the numbers.

-chris
