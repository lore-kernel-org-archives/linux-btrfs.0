From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: fix wrong i_size when truncating a file to a
 larger size
Date: Wed, 14 Dec 2011 11:51:47 -0500
Message-ID: <20111214165147.GF31158@shiny>
References: <4EE84D29.5070601@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE84D29.5070601@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 03:15:53PM +0800, Miao Xie wrote:
> Btrfsck report error 100 after the 83th case of xfstests was run, it means
> the i_size of the file is wrong.
> 
> The reason of this bug is that:
> Btrfs increased i_size of the file at the beginning, but it failed to expand
> the file, and failed to update the i_size to the old size because there is no
> enough space in the file system, so we found a wrong i_size.
> 
> This patch fixes this bug by updating the i_size just when we pass the file
> expanding and get enough space to update i-node.

Hmmm, have you tested this one with fsx-linux?  It should be ok to call
truncate_pagecache before bumping i_size in this case, since we
shouldn't have pages past i_size.

But, truncate_pagecache does expect i_size to be accurate before the
call.

-chris
