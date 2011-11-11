From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes
Date: Fri, 11 Nov 2011 16:40:48 -0500
Message-ID: <20111111214048.GP4435@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

The for-linus branch of the btrfs git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
sha: 8965593e41dd2d0e2a2f1e6f245336005ea94a2c

Has our fixes since rc1.  These are pretty small, for the most part
we're nailing some regressions in the mount error handling code and
tweaking the ENOSPC throttling.

My for-linus tree is against 3.1, but this was tested against 3.2-rc1 as
well.

Miao Xie (6) commits (+47/-23):
    Btrfs: Abstract similar code for btrfs_block_rsv_add{, _noflush} (+12/-16)
    Btrfs: fix deadlock caused by the race between relocation (+2/-2)
    Btrfs: fix no reserved space for writing out inode cache (+24/-4)
    Btrfs: fix unreleased path in btrfs_orphan_cleanup() (+3/-0)
    Btrfs: fix nocow when deleting the item (+4/-1)
    Btrfs: fix orphan backref nodes (+2/-0)

Ilya Dryomov (5) commits (+43/-46):
    Btrfs: avoid null dereference and leaks when bailing from open_ctree() (+15/-20)
    Btrfs: close devices on all error paths in open_ctree() (+3/-4)
    Btrfs: fix subvol_name leak on error in btrfs_mount() (+3/-1)
    Btrfs: fix memory leak in btrfs_parse_early_options() (+1/-0)
    Btrfs: rework error handling in btrfs_mount() (+21/-21)

Chris Mason (2) commits (+56/-33):
    Btrfs: fix oops on NULL trans handle in btrfs_truncate (+9/-7)
    Btrfs: tweak the delayed inode reservations again (+47/-26)

Josef Bacik (2) commits (+93/-16):
    Btrfs: only map pages if we know we need them when reading the space cache (+10/-7)
    Btrfs: fix our reservations for updating an inode when completing io (+83/-9)

slyich@gmail.com (1) commits (+5/-3):
    btrfs: fix double-free 'tree_root' in 'btrfs_mount()'

Arne Jansen (1) commits (+29/-35):
    Btrfs: handle bio_add_page failure gracefully in scrub

David Sterba (1) commits (+2/-2):
    btrfs: rename the option to nospace_cache

Total: (18) commits

 fs/btrfs/btrfs_inode.h      |    4 +--
 fs/btrfs/delayed-inode.c    |   58 +++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.c          |   42 +++++++++------------
 fs/btrfs/extent-tree.c      |   50 ++++++++++++++++----------
 fs/btrfs/free-space-cache.c |   17 +++++----
 fs/btrfs/inode-map.c        |   28 ++++++++++++--
 fs/btrfs/inode.c            |   84 +++++++++++++++++++++++++++++--------------
 fs/btrfs/relocation.c       |    2 +
 fs/btrfs/scrub.c            |   64 +++++++++++++++------------------
 fs/btrfs/super.c            |   49 ++++++++++++++-----------
 fs/btrfs/transaction.c      |    4 +-
 fs/btrfs/volumes.c          |    5 ++-
 12 files changed, 262 insertions(+), 145 deletions(-)
