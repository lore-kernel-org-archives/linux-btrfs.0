From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Sun, 6 Nov 2011 19:35:14 -0500
Message-ID: <20111107003514.GB4339@shiny>
References: <20111106183851.GA4339@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111106183851.GA4339@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 06, 2011 at 01:38:51PM -0500, Chris Mason wrote:
> Hi everyone,
> 
> This pull request is pretty beefy, it ended up merging a number of long
> running projects and cleanup queues.  I've got btrfs patches in the new
> kernel.org btrfs repo.  There are two different branches with the same
> changes.  for-linus is against 3.1 and has also been tested against
> Linus' tree as of yesterday.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Well, I had one more commit in my working directory that I neglected to
run git commit on.  It fixes an oops during log replay.

The new head of my for-linus branch is:

commit 7c7e82a77fe3d89ae50824aa7c897454675eb4c4
Author: Chris Mason <chris.mason@oracle.com>
Date:   Sun Nov 6 18:50:56 2011 -0500

    Btrfs: check for a null fs root when writing to the backup root log

If you're pulling just that one commit it'll have this diffstat:

disk-io.c |   13 ++++++++++---
1 file changed, 10 insertions(+), 3 deletions(-)

The diffstat for the whole bunch is below.  Sorry for the noise.

-chris

Total: (114) commits

 fs/btrfs/Makefile           |    3 +-
 fs/btrfs/acl.c              |   17 +-
 fs/btrfs/backref.c          |  776 +++++++++++++++++++++++++++++++++++
 fs/btrfs/backref.h          |   62 +++
 fs/btrfs/btrfs_inode.h      |   17 +-
 fs/btrfs/compression.c      |    3 +-
 fs/btrfs/ctree.c            |   10 +-
 fs/btrfs/ctree.h            |  198 ++++++++--
 fs/btrfs/delayed-inode.c    |   50 ++-
 fs/btrfs/disk-io.c          |  441 +++++++++++++++++---
 fs/btrfs/disk-io.h          |    4 +-
 fs/btrfs/extent-tree.c      |  848 +++++++++++++++++++++++---------------
 fs/btrfs/extent_io.c        |  614 +++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h        |   23 +-
 fs/btrfs/file-item.c        |   17 +-
 fs/btrfs/file.c             |   25 +-
 fs/btrfs/free-space-cache.c |  926 +++++++++++++++++++++++++----------------
 fs/btrfs/inode-map.c        |    6 +-
 fs/btrfs/inode.c            |  457 +++++++--------------
 fs/btrfs/ioctl.c            |  227 +++++++++--
 fs/btrfs/ioctl.h            |   29 ++
 fs/btrfs/print-tree.c       |    8 +-
 fs/btrfs/reada.c            |  951 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/relocation.c       |   24 +-
 fs/btrfs/scrub.c            |  591 ++++++++++++++++++++++-----
 fs/btrfs/super.c            |  298 +++++++++-----
 fs/btrfs/transaction.c      |  146 +++----
 fs/btrfs/tree-log.c         |   19 +-
 fs/btrfs/volumes.c          |  207 ++++++----
 fs/btrfs/volumes.h          |   18 +-
 fs/btrfs/xattr.c            |   11 +
 31 files changed, 5423 insertions(+), 1603 deletions(-)
