Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30752 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbbBPAeX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 19:34:23 -0500
Date: Mon, 16 Feb 2015 11:33:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic test for fsync followed by truncate and
 link
Message-ID: <20150216003337.GG12722@dastard>
References: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 13, 2015 at 12:47:54PM +0000, Filipe Manana wrote:
> This test is motivated by an fsync issue discovered in btrfs.
> The issue was that we could lose file data, that was previously fsync'ed
> successfully, if we end up shrinking (via truncate) the file, add a hard
> link to our file and then persist the fsync log later via an fsync of
> other inode for example. After a power loss our file content wouldn't
> match what it had when we last fsync'ed, but instead it had the data
> prior to that fsync.

Prior to which fsync?

XFS has strictly ordered metadata journalling, which means
transactions committed prior to *any* fsync will be present on disk
after the fsync. ext4 is not quite so strict, but has essentially
the same behaviour. ext3 in ordered mode behaves like XFS.

As such, ext3, ext4 and XFS return the state of the file as "0xaa for
0 to 5k, 0x00 out to 32k" and the hardlink foo_link is present after
the filesystem is remounted and the log replayed.

So, as this test is written, it does not encapsulate the
longstanding, expected behaviour of existing filesystems. btrfs
should behave like XFS, ext3 and ext4 if possible - being different
is only going to cause confusion and pain for application
developers.

> The btrfs issue was fixed by the following linux kernel patch:
> 
>   Btrfs: don't remove extents and xattrs when logging new names

Sounds like you've just introduced an ordered mode behavioural
journalling regression into btrfs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
