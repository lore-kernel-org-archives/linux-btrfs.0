From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.32-rc
Date: Thu, 1 Oct 2009 20:30:52 -0400
Message-ID: <20091002003052.GA5720@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've prepared the for-linus branch of the btrfs-unstable tree for
pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

The master branch has the same changes against 2.6.31, minus a cleanup
from Christoph that is 2.6.32-rc specific.

The big part of this pull request is Josef Bacik's ENOSPC support.  He
has added enough tracking to reserve room ahead of time for the metadata
required to meet all the delayed allocations we do, and gotten rid of
the half solutions that were in place before.

We already have small updates planned, and the code doesn't yet make
sure that btrfs-vol -b or device shrinking do the proper reservation to
avoid oopsen.  But, it is working nicely and I'd like to get it out for
broader use.

Another change that may get noticed is that Btrfs now uses
CONFIG_BTRFS_POSIX_ACL for testing to see if it should do acls.  There
has been some confusion around this and it is more consistent with the
other filesystems.  So, if you had acls please make sure you've got the
btrfs posix acl config on.

Chris Ball (2) commits (+7/-5):
    Btrfs: Fix setting umask when POSIX ACLs are not enabled (+2/-0)
    Btrfs: Use CONFIG_BTRFS_POSIX_ACL to enable ACL code (+5/-5)

Chris Mason (1) commits (+17/-8):
    Btrfs: take i_mutex before generic_write_checks

Christoph Hellwig (2) commits (+13/-103):
    Btrfs: fix arguments to btrfs_wait_on_page_writeback_range (+3/-1)
    Btrfs: remove duplicates of filemap_ helpers (+10/-102)

Josef Bacik (2) commits (+689/-115):
    Btrfs: proper -ENOSPC handling (+678/-115)
    Btrfs: fix data space leak fix (+11/-0)

Julia Lawall (1) commits (+3/-1):
    Btrfs: introduce missing kfree

Sage Weil (2) commits (+23/-20):
    Btrfs: fix deadlock with free space handling and user transactions (+1/-1)
    Btrfs: fix error cases for ioctl transactions (+22/-19)

Total: (10) commits

 fs/btrfs/acl.c          |    6 
 fs/btrfs/btrfs_inode.h  |    8 
 fs/btrfs/ctree.h        |   25 ++-
 fs/btrfs/disk-io.c      |   16 -
 fs/btrfs/extent-tree.c  |  391 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.c    |   92 ++++++++---
 fs/btrfs/extent_io.h    |   13 +
 fs/btrfs/file.c         |   41 +++--
 fs/btrfs/inode.c        |  235 +++++++++++++++++++++++++---
 fs/btrfs/ioctl.c        |   62 +++++--
 fs/btrfs/ordered-data.c |   93 -----------
 fs/btrfs/ordered-data.h |    4 
 fs/btrfs/super.c        |    2 
 fs/btrfs/transaction.c  |   10 +
 fs/btrfs/volumes.c      |    4 
 fs/btrfs/xattr.c        |    2 
 16 files changed, 752 insertions(+), 252 deletions(-)
