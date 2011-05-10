From: y@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
Date: Tue, 10 May 2011 22:57:26 +0300
Message-ID: <20365.7293146991$1305057316@news.gmane.org>
Cc: Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

The really interesting commit is
    [PATCH 1/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
which fixes hogs on ENOSPC for me.

The rest of patches are cleanup.

Change since v1:
- Added Josef's Reviewed-by
- Fixed my MTA and patch numbering

Thanks!
