Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbbBQRiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 12:38:25 -0500
Date: Tue, 17 Feb 2015 18:38:22 +0100
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs, recent cleanup patches
Message-ID: <20150217173822.GQ8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've collected the cleanup patches that are not in the integration
branch, the time span is last few months. I've reviewed them but tested
only lightly due to yet unknown problems in the current integration branch.

The target release is probably 3.21, I'm going to send more cleanup
series so that can be a base for next development cycle and minize
conflicts with other changes.

Please pull, thanks.

The following changes since commit a742994aa2e271eb8cd8e043d276515ec858ed73:

  Btrfs: don't remove extents and xattrs when logging new names (2015-02-14 08:22:49 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-post-3.19

for you to fetch changes up to a4f3d2c4efe2628329249b64fd5799468e025b9d:

  btrfs: cleanup, reduce temporary variables in btrfs_read_roots (2015-02-16 18:48:47 +0100)

----------------------------------------------------------------
Daniel Dressler (3):
      Btrfs: ctree: reduce args where only fs_info used
      Btrfs: delayed-inode: replace root args iff only fs_info used
      Btrfs: disk-io: replace root args iff only fs_info used

David Sterba (3):
      btrfs: constify structs with op functions or static definitions
      btrfs: use correct type for workqueue flags
      btrfs: cleanup, reduce temporary variables in btrfs_read_roots

Eric Sandeen (10):
      btrfs: remove unused fs_info arg from btrfs_close_extra_devices()
      btrfs: consistently use fs_info in close_ctree()
      btrfs: factor btrfs_init_scrub() out of open_ctree()
      btrfs: factor btrfs_init_balance() out of open_ctree()
      btrfs: factor btrfs_init_btree_inode() out of open_ctree()
      btrfs: factor btrfs_init_dev_replace_locks() out of open_ctree()
      btrfs: factor btrfs_init_qgroup() out of open_ctree()
      btrfs: factor btrfs_init_workqueues() out of open_ctree()
      btrfs: factor btrfs_replay_log() out of open_ctree()
      btrfs: factor btrfs_read_roots() out of open_ctree()

Fabian Frederick (1):
      btrfs: fix sizeof format specifier in btrfs_check_super_valid()

Wang Shilong (1):
      Btrfs: switch to kvfree() helper

Zhao Lei (3):
      btrfs: cleanup: remove no-used alloc_chunk in btrfs_check_data_free_space()
      btrfs: remove unused chunk_tree argument in several functions
      btrfs: cleanup: use for() loop in btrfs_map_bio()

 fs/btrfs/async-thread.c    |   4 +-
 fs/btrfs/async-thread.h    |   2 +-
 fs/btrfs/check-integrity.c |   5 +-
 fs/btrfs/compression.c     |   2 +-
 fs/btrfs/compression.h     |   4 +-
 fs/btrfs/ctree.c           |  53 +++--
 fs/btrfs/ctree.h           |   3 +-
 fs/btrfs/delayed-inode.c   |   9 +-
 fs/btrfs/disk-io.c         | 558 ++++++++++++++++++++++++---------------------
 fs/btrfs/disk-io.h         |   4 +-
 fs/btrfs/extent-tree.c     |  10 +-
 fs/btrfs/extent_io.h       |   2 +-
 fs/btrfs/file-item.c       |   2 +-
 fs/btrfs/file.c            |   8 +-
 fs/btrfs/lzo.c             |   2 +-
 fs/btrfs/props.c           |   2 +
 fs/btrfs/qgroup.c          |   2 +-
 fs/btrfs/raid56.c          |  13 +-
 fs/btrfs/scrub.c           |   2 +-
 fs/btrfs/sysfs.c           |   2 +-
 fs/btrfs/transaction.c     |   2 +-
 fs/btrfs/tree-log.c        |   8 +-
 fs/btrfs/volumes.c         |  34 +--
 fs/btrfs/volumes.h         |   3 +-
 fs/btrfs/zlib.c            |   2 +-
 25 files changed, 386 insertions(+), 352 deletions(-)

