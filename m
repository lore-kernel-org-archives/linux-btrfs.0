Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56243 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaCWQUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 12:20:09 -0400
Date: Sun, 23 Mar 2014 09:20:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>
Message-ID: <20140323162000.GK12833@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net>
 <20140323114712.GC25400@carfax.org.uk>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both
legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=5 /mnt/btrfs_pool2
legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=0 /mnt/btrfs_pool2
failed unfortunately.

On Sun, Mar 23, 2014 at 12:26:32PM +0000, Duncan wrote:
> When it rains, it pours.  What you're missing is that this is now the 
> third thread in three days with exactly the same out-of-space-when-there-
> appears-to-be-plenty problem, which is well explained and a solution 
> presented, along with further discussion, on those threads.
> 
> Evidently you haven't read the others, but rather than rewrite a similar 
> reply here with exactly the same explanation and fix, I'll just refer you 
> to them.

Thanks. Indeed, while I spent most of yesterday dealing with 3 btrfs
filesystems, the one here that was hanging my laptop, the raid5 one that
was hanging repeatedly during balance, and then my main server were one
FS is so slow that it takes 8H to do an reflink copy or delete a backup
with 1 million inodes, I got behind on reading the list :)

Thanks for the pointers

> btrfs balance start -dusage=5 `pwd`
> 
> Tweak the N in usage=N as needed.

I had actually tried this, but it failed too:
legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=5 /mnt/btrfs_pool2
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=5
ERROR: error during balancing '/mnt/btrfs_pool2' - No space left on device

But I now just found
https://btrfs.wiki.kernel.org/index.php/Balance_Filters
and tried -dusage=0
 
On Sun, Mar 23, 2014 at 11:47:12AM +0000, Hugo Mills wrote:
>    I think you probably shouldn't be doing a full balance, but a
> filtered one:
> 
> # btrfs balance start -dusage=5 /mnt/btrfs_pool
> 
> which should only try to clean up chunks which have little usage (so
> it's much faster to run).

Thanks for the other answer Hugo.

So, now I'm down to 
legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=0 /mnt/btrfs_pool2
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=0
ERROR: error during balancing '/mnt/btrfs_pool2' - No space left on device

Looks like there is no good way out of this, so I'll start deleting
snapshots.

Hopefully this will be handled better in later code.

Thanks for the answer,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
