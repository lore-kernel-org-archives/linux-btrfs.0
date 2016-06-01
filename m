Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47396 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbcFALoZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:44:25 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Device replace fixes
Date: Wed,  1 Jun 2016 12:44:13 +0100
Message-Id: <1464781453-13536-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following device replace related fixes for inclusion
in a future 4.7 release candidate kernel. These were all previously sent
to the mailing list and reviewed by Josef (and I recently rebased them
against your for-linus-4.7 branch). They mostly fix crashes, invalid
memory accesses and data/metadata loss (some extents, or entire block
groups, end up not being copied from the source device into the target
device).

Thanks.

The following changes since commit 56244ef151c3cd11f505020ab0b3f45454363bcc:

  Btrfs: fix handling of faults from btrfs_copy_from_user (2016-05-26 13:23:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git dev-replace-fixes-4.7

for you to fetch changes up to b5de8d0df80fa87f1f97fbcc4bbc8cad0a018802:

  Btrfs: fix race between device replace and read repair (2016-05-31 01:00:03 +0100)

----------------------------------------------------------------
Filipe Manana (8):
      Btrfs: fix race between readahead and device replace/removal
      Btrfs: fix race between device replace and block group removal
      Btrfs: fix race setting block group readonly during device replace
      Btrfs: fix unprotected assignment of the left cursor for device replace
      Btrfs: fix race setting block group back to RW mode during device replace
      Btrfs: fix race between device replace and chunk allocation
      Btrfs: fix race between device replace and discard
      Btrfs: fix race between device replace and read repair

 fs/btrfs/extent-tree.c  |  6 ++++++
 fs/btrfs/extent_io.c    | 10 ++++++++++
 fs/btrfs/ordered-data.c |  6 +++++-
 fs/btrfs/ordered-data.h |  2 +-
 fs/btrfs/reada.c        |  2 ++
 fs/btrfs/scrub.c        | 50 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c      | 32 ++++++++++++++++++++------------
 7 files changed, 91 insertions(+), 17 deletions(-)

-- 
2.7.0.rc3

