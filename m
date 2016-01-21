Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbcAUScG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 13:32:06 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/4] Sysfs fixes to incompat bits
Date: Thu, 21 Jan 2016 19:31:57 +0100
Message-Id: <cover.1453400624.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed that the free space tree compat bit is missing from the sysfs
files, this patch series fixes that. Incidentally I found out that any incompat
bits set during filesystem lifetime are not tracked there either, so that's
also fixed.

This is not critical for using the free space tree feature itself, I'm
targeting 4.5-rc2. Thanks.

----------------------------------------------------------------
The following changes since commit 988f1f576d4f7531cb2175ee1b7cb7afd6d95d22:

  Merge branch 'for-chris-4.5' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.5 (2016-01-11 08:39:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fix/fst-sysfs

for you to fetch changes up to 14e46e04958df740c6c6a94849f176159a333f13:

  btrfs: synchronize incompat feature bits with sysfs files (2016-01-21 18:54:41 +0100)

----------------------------------------------------------------
David Sterba (4):
  btrfs: sysfs: fix typo in compat_ro attribute definition
  btrfs: sysfs: add free-space-tree bit attribute
  btrfs: sysfs: introduce helper for syncing bits with sysfs files
  btrfs: synchronize incompat feature bits with sysfs files

 fs/btrfs/free-space-tree.c |  7 +++++++
 fs/btrfs/ioctl.c           |  4 ++++
 fs/btrfs/super.c           |  4 ++++
 fs/btrfs/sysfs.c           | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h           |  5 ++++-
 fs/btrfs/volumes.c         |  2 ++
 6 files changed, 53 insertions(+), 1 deletion(-)

-- 
2.6.3

