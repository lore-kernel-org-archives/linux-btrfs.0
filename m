From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs pull for .34
Date: Mon, 8 Mar 2010 17:00:22 -0500
Message-ID: <20100308220022.GB14976@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This merge window conflicted with my spring break skiing window, so this
pull request is very very short.  I have a larger one in testing but
really wanted to get this out.

Linus, please pull the btrfs-unstable master branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

The RB_ROOT patch changes btrfs to use the proper rbtree initializer,
and Josef's patch fixes a memory corruption during btrfs mount.

Eric Paris (1) commits (+12/-12):
    Btrfs: use RB_ROOT to intialize rb_trees instead of setting rb_node to NULL

Josef Bacik (1) commits (+3/-2):
    Btrfs: kfree correct pointer during mount option parsing

Total: (2) commits

 fs/btrfs/disk-io.c          |    4 ++--
 fs/btrfs/extent_io.c        |    4 ++--
 fs/btrfs/extent_map.c       |    2 +-
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/ordered-data.h     |    2 +-
 fs/btrfs/ref-cache.h        |    2 +-
 fs/btrfs/relocation.c       |    4 ++--
 fs/btrfs/super.c            |    5 +++--
 fs/btrfs/transaction.c      |    2 +-
 9 files changed, 15 insertions(+), 14 deletions(-)

