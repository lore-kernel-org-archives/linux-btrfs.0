Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbcA0OCK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:02:10 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/4] Minor fixes to free-space-tree patchset, for 4.5
Date: Wed, 27 Jan 2016 15:01:59 +0100
Message-Id: <cover.1453902967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the newly added free space tree has to be added to a few more places.  Plus two
minor updates to memory allocations, similar to what went in during this dev
cycle.

----------------------------------------------------------------
The following changes since commit 988f1f576d4f7531cb2175ee1b7cb7afd6d95d22:

  Merge branch 'for-chris-4.5' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.5 (2016-01-11 08:39:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/fst-followup

for you to fetch changes up to 3e4c5efbb3ac7c9c4fb5f33b659fa98afe568ab1:

  btrfs: add free space tree to the cow-only list (2016-01-25 16:48:07 +0100)
----------------------------------------------------------------

David Sterba (4):
  btrfs: tests: switch to GFP_KERNEL
  btrfs: tweak free space tree bitmap allocation
  btrfs: add free space tree to lockdep classes
  btrfs: add free space tree to the cow-only list

 fs/btrfs/disk-io.c               |  1 +
 fs/btrfs/free-space-tree.c       | 18 ++++++++++++++++--
 fs/btrfs/relocation.c            |  3 ++-
 fs/btrfs/tests/btrfs-tests.c     | 10 +++++-----
 fs/btrfs/tests/extent-io-tests.c | 12 ++++++------
 fs/btrfs/tests/inode-tests.c     |  8 ++++----
 6 files changed, 34 insertions(+), 18 deletions(-)

-- 
2.6.3

