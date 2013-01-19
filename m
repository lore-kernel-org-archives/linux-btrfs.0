Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:48093 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3ASSGb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:31 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180631.ITUP6475.eastrmfepo202.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:31 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 0/6] patches from Fedora 18 (resubmitted)
Date: Sat, 19 Jan 2013 13:06:15 -0500
Message-Id: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are the patches from the Fedora 18 btrfs-progs package.

This is resubmitted to pickup the other two patches by
Josef Bacik.  One of them had to be refitted/rebased
because of changes to mkfs.c but only the original Josef
changes are included.

I claim no authorship and am simply passing these on to the
btrfs mailing list.  There are only six patches.  The 
btrfs-init-dev-list.patch and the two Bacik patches are new to 18.
The others all date back to at least Fedora 15 in early 2011.

These patches were applied on top of the 19 patches
assembled by David Sterba.  The valgrind patch  needed to be
change to remove a small part which had already been fixed 
by the "plug a memory leak reported by cppcheck" patch.

Gene Czarcinski (5):
  Fedora 18 - btrfs-init-dev-list.patch
  Fedora 18 - build-fixes.patch
  Fedora 18 - fix-labels.patch
  Fedora 18 - modified valgrind.patch
  Btrfs-progs: detect if the disk we are formatting is a ssd

Josef Bacik (1):
  Btrfs-progs: add btrfs device ready command

 Makefile            |  2 +-
 btrfsck.c           |  2 ++
 cmds-device.c       | 35 +++++++++++++++++++++++++
 disk-io.c           | 16 ++++++++----
 extent-cache.c      | 11 ++++++++
 extent-cache.h      |  1 +
 extent-tree.c       | 10 ++++++++
 ioctl.h             |  2 ++
 man/mkfs.btrfs.8.in |  5 +++-
 mkfs.c              | 74 ++++++++++++++++++++++++++++++++++++++++++++---------
 utils.c             |  3 ++-
 volumes.c           | 16 +++++++++++-
 volumes.h           |  1 +
 13 files changed, 157 insertions(+), 21 deletions(-)

-- 
1.8.1

