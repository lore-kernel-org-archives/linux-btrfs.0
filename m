Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbbJUQqI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 12:46:08 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL] Btrfs cleanups for 4.4 (collected)
Date: Wed, 21 Oct 2015 18:44:46 +0200
Message-Id: <cover.1445445632.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a bunch of cleanup patches from the mailinglist, no functional changes.
Reviewed and compile-tested, merge with current integration is without
conflits. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 25cb62b76430a91cc6195f902e61c2cb84ade622:

  Linux 4.3-rc5 (2015-10-11 11:09:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups/for-4.4

for you to fetch changes up to ddd664f4478a4aaf0ac67a4297e33f1992bc9be2:

  btrfs: reada: Fix returned errno code (2015-10-21 18:29:50 +0200)

----------------------------------------------------------------
Alexandru Moise (8):
      btrfs: Fixed dsize and last_off declarations
      btrfs: Fixed declaration of old_len
      btrfs: trimming some start_transaction() code away
      btrfs: memset cur_trans->delayed_refs to zero
      btrfs: use a single if() statement for one outcome in get_block_rsv()
      btrfs: cleanup btrfs_balance profile validity checks
      btrfs: change num_items type from u64 to unsigned int
      btrfs: declare rsv_count as unsigned int instead of int

Byongho Lee (4):
      btrfs: replace unnecessary list_for_each_entry_safe to list_for_each_entry
      btrfs: remove unnecessary list_del
      btrfs: cleanup iterating over prop_handlers array
      btrfs: compress: put variables defined per compress type in struct to make cache friendly

Chandan Rajendra (1):
      Btrfs: btrfs_submit_bio_hook: Use btrfs_wq_endio_type values instead of integer constants

Geliang Tang (1):
      btrfs: fix a comment typo

Luis de Bethencourt (2):
      btrfs: check-integrity: Fix returned errno codes
      btrfs: reada: Fix returned errno code

Shan Hai (1):
      btrfs/file.c: remove an unsed varialbe first_index

Zhao Lei (3):
      btrfs: Move btrfs_raid_array to public
      btrfs: use btrfs_raid_array for btrfs_get_num_tolerated_disk_barrier_failures()
      btrfs: use btrfs_raid_array in btrfs_reduce_alloc_profile

 fs/btrfs/check-integrity.c  |   4 +-
 fs/btrfs/compression.c      |  94 +++++++++++++-------------
 fs/btrfs/ctree.c            |   4 +-
 fs/btrfs/disk-io.c          |  35 ++++++----
 fs/btrfs/extent-tree.c      |  58 +++++++---------
 fs/btrfs/file.c             |   5 +-
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode.c            |   5 +-
 fs/btrfs/ioctl.c            |   3 +-
 fs/btrfs/props.c            |  13 ++--
 fs/btrfs/reada.c            |   8 ++-
 fs/btrfs/root-tree.c        |   2 +-
 fs/btrfs/transaction.c      |  32 +++------
 fs/btrfs/transaction.h      |   5 +-
 fs/btrfs/volumes.c          | 156 +++++++++++++++++++++++++-------------------
 fs/btrfs/volumes.h          |   5 ++
 16 files changed, 220 insertions(+), 211 deletions(-)
