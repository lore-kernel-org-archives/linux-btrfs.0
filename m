Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbbKSKoC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 05:44:02 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/3] Constify structs
Date: Thu, 19 Nov 2015 11:42:21 +0100
Message-Id: <cover.1447929577.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few more additions of const, aiming for 4.5. Thanks.

----------------------------------------------------------------
The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/constify

for you to fetch changes up to de37f1d3a183e134a1a392309d79f2b3091204d7:

  btrfs: constify static arrays (2015-11-18 17:13:41 +0100)

----------------------------------------------------------------
David Sterba (3):
      btrfs tests: replace whole ops structure for free space tests
      btrfs: constify remaining structs with function pointers
      btrfs: constify static arrays

 fs/btrfs/ctree.h                  |  2 +-
 fs/btrfs/free-space-cache.c       |  2 +-
 fs/btrfs/free-space-cache.h       |  2 +-
 fs/btrfs/inode-map.c              |  4 ++--
 fs/btrfs/inode.c                  |  6 +++---
 fs/btrfs/ioctl.c                  |  2 +-
 fs/btrfs/super.c                  |  2 +-
 fs/btrfs/tests/free-space-tests.c | 14 ++++++++------
 8 files changed, 18 insertions(+), 16 deletions(-)
