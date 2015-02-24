Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbbBXQvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:51:31 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PULL] [PATCH 0/4] Barriers + waitqueue_active fixes
Date: Tue, 24 Feb 2015 17:51:29 +0100
Message-Id: <cover.1424795734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed some missing smp_mb() in recent code before waitqueue_active and
did a broader audit. Fixed and documented the rest.

The first patch is a stable candidate but does not apply as-is due to changes
in 4.0-rc1.

---

The following changes since commit e57cf21e9787c081db4db6afa02e6e70112ee410:

  Btrfs: fix allocation size calculations in alloc_btrfs_bio (2015-02-20 06:55:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fix/waitqueue-barriers

for you to fetch changes up to 1b127581ed4eb64dc941d2ecaba3174802870c07:

  btrfs: comment the rest of implicit barriers before waitqueue_active (2015-02-20 19:06:39 +0100)

----------------------------------------------------------------
David Sterba (4):
      btrfs: add missing barriers before waitqueue_active
      btrfs: add comments to barriers before waitqueue_active
      btrfs: remove extra barrier before waitqueue_active
      btrfs: comment the rest of implicit barriers before waitqueue_active

 fs/btrfs/compression.c   |  3 +++
 fs/btrfs/delayed-inode.c |  4 ++++
 fs/btrfs/dev-replace.c   |  9 ++++++++-
 fs/btrfs/disk-io.c       |  3 +++
 fs/btrfs/extent-tree.c   |  3 +--
 fs/btrfs/inode.c         |  3 +++
 fs/btrfs/locking.c       | 12 ++++++++++++
 fs/btrfs/ordered-data.c  |  6 ++++++
 fs/btrfs/raid56.c        | 17 ++++++++++++-----
 fs/btrfs/transaction.c   |  8 +++++++-
 fs/btrfs/tree-log.c      | 16 ++++++++++++++--
 fs/btrfs/volumes.c       |  3 +++
 12 files changed, 76 insertions(+), 11 deletions(-)
