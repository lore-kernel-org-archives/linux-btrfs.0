Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35123 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3LGOV5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 09:21:57 -0500
Date: Sat, 7 Dec 2013 01:22:16 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Extremely slow metadata performance
Message-ID: <20131207092216.GL22683@merlins.org>
References: <52A0BD44.9030509@complete.org>
 <pan$950f8$ef940490$829198f6$4f5f85c7@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$950f8$ef940490$829198f6$4f5f85c7@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 05, 2013 at 07:39:30PM +0000, Duncan wrote:
> John Goerzen posted on Thu, 05 Dec 2013 11:52:04 -0600 as excerpted:
> 
> > Hello,
> > 
> > I have observed extremely slow metadata performance with btrfs. This may
> > be a bit of a nightmare scenario; it involves untarring a backup of
> > 1.6TB of backuppc data, which contains millions of hardlinks and much
> > data, onto USB 2.0 disks.
> 
> > Is this behavior known and expected?
> 
> Yes.  Btrfs doesn't do well with lots of hardlinks and indeed until 
> relatively recently had a hard-limit on the number of hardlinks possible 
> within a directory, that hardlink-heavy use-cases would regularly hit.  
> That was worked around, but there's an additional level of indirection 
> once the first level link-pool is filled, and you're not the first to 
> have observed that btrfs performance isn't the best in that sort of 
> scenario.  That's known.
> 
> Other filesystems will probably do quite a bit better for hardlink style 
> backups and other hardlink-heavy use-cases.  Either that, or consider 
> using btrfs, but with some other form of backup, possibly btrfs 
> snapshots, or COW reflinks.

Thanks for explaining this.

I'm one of those people who uses cp -al and rsync to do backups. Indeed
I should likely rework the flow to use subvolumes and snapshots.
You also mentioned reflinks, and it sounds like I can use
cp -a --reflink instead of cp -al.

Also, would the dedupe code in btrfs effectively allow for the same
thing after the fact if you use cp without --reflink? Is it stable
enough nowadays?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
