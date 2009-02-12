From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix btrfs_read_block_groups return value
Date: Thu, 12 Feb 2009 09:49:35 -0500
Message-ID: <1234450175.8300.1.camel@think.oraclecorp.com>
References: <4993808C.20000@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4993808C.20000@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-02-11 at 20:51 -0500, Jeff Mahoney wrote:
> btrfs_read_block_groups returns an ambiguous value. Whether it finds
>  a block group or not, it will return -ENOENT. find_first_block_group
>  will eventually return -ENOENT when it reaches past the last block
>  group, and that is what is returned to the caller.

Jeff, thanks for starting on all of this.  Could I talk you into setting
up a git tree?  I think you're going to have a long stream of patches
and merging them with my trees is going to be much easier over git.

-chris


