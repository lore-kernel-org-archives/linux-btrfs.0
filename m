Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49381 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2FLScN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 14:32:13 -0400
Date: Tue, 12 Jun 2012 14:32:09 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Btrfs and data nocow per inode basis
Message-ID: <20120612183209.GC1803@thunk.org>
References: <4FD442F1.7040008@inwind.it>
 <4FD77F45.3060000@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD77F45.3060000@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 07:41:25PM +0200, Goffredo Baroncelli wrote:
> 
> After a bit of googling I found a Liu Bo patches which add the ability
> to set the NOCOW flags to a btrfs file.[1]
> 
> However it seems that it was not present in the current (v1.42.3)
> e2fsprogs suite.
> 
> There is any reason which stopped the adoption of this patch ?

It's a textbook example of how *not* to try to get a patch into
e2fsprogs.

1) It's a huge patch that makes a much larger set of changes than what
is necessary to achieve the desired results (the EXT2_*_FL to
FS_*_FL flags is hugely gratuitous)

2) Because of all of the noise in the patch, something that was
completely missed was that the patch did ***NOT*** allow the setting
of the NOCOW flag.

My apologies for not having the time send a reply back.  It fell
between the cracks.

> Does make sense to add the chattr/lsattr capability to the btrfs tool (I
> am thinking about new commands like "btrfs filesystem chattr"/"btrfs
> filesystem lsattr") ?

The lsattr/chattr commands and the flags were always originally been
defined for the ext2/3/4 file systems.  It was the reiserfs filesystem
that just glommed onto that interface and hijacked the flags
definition into a file system independent interface.  At this point
enough other file systems have used those ioctl's and the flags
interface that I *do* try to coordinate with other file systems.

This means that I coordinate flag assignments and try not to use flag
bits in ext2/3/4 that have been made visible by other file systems
(even though the 32-bit flag space is getting pretty crowded, and
there's not much space left).  And I will add support for flags into
lsattr/chattr that are not supported by ext2/3/4.

But a massive change which tries to do a global rename of EXT2_*_FL to
FS_*_FL in e2fsprogs for no good reason?  That just adds code churn
and it makes it harder to validate that the patch is correct, for no
good user-visible benefit.

Regards,

					- Ted
