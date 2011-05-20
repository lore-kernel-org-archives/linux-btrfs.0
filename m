From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 0/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
Date: Fri, 20 May 2011 23:20:29 +0300
Message-ID: <1305922832-22551-1-git-send-email-slyfox@gentoo.org>
Cc: Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The really interesting commit is
    btrfs: don't spin in shrink_delalloc if there is nothing to free
which fixes hogs on ENOSPC for me.


The rest of patches are cleanup.

Change since v2:
- Rebased against 2.6.39

Change since v1:
- Added Josef's Reviewed-by
- Fixed my MTA and patch numbering

Thanks!

P.S.:
It's also interesting to note, that 'shrink_delalloc' tries
to mess with 'bytes_reserved' (which are metadata reservation
right?)

The more I look at 'bytes_reserved' management paths the more I
think 'shrink_delalloc' should not touch them.
