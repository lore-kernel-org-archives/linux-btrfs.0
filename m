Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:48329 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3ASO4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 09:56:36 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119145635.YPGT6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 09:56:35 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 0/4] patches from Fedora 18
Date: Sat, 19 Jan 2013 09:56:21 -0500
Message-Id: <1358607385-21163-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are the patches from the Fedora 18 btrfs-progs package.

I claim no authorship and am simply passing these on to the
btrfs mailing list.  There are only four patches.  The 
btrfs-init-dev-list.patch is new to 18.  The others all date
back to at least Fedora 15 in early 2011.

These patches were applied on top of the 19 patches
assembled by David Sterba.  They all applied cleanly
except the valgrind patch where I had to remove a small part
because it had already been fixed by the "plug a memory leak
reported by cppcheck" patch.

Gene Czarcinski (4):
  Fedora 18 - btrfs-init-dev-list.patch
  Fedora 18 - build-fixes.patch
  Fedora 18 - fix-labels.patch
  Fedora 18 - modified valgrind.patch

 btrfsck.c      |  2 ++
 disk-io.c      | 16 +++++++++++-----
 extent-cache.c | 11 +++++++++++
 extent-cache.h |  1 +
 extent-tree.c  | 10 ++++++++++
 mkfs.c         | 11 ++---------
 utils.c        |  3 ++-
 volumes.c      | 16 +++++++++++++++-
 volumes.h      |  1 +
 9 files changed, 55 insertions(+), 16 deletions(-)

-- 
1.8.1

