From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Thu, 27 May 2010 13:32:20 -0400
Message-ID: <20100527173220.GG3835@think>
References: <20100527151515.GA3835@think>
 <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 27, 2010 at 10:18:04AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 27 May 2010, Chris Mason wrote:
> > 
> >  fs/btrfs/extent-tree.c  | 2317 ++++++++++++++++++++++++++++--------------------
> >  fs/btrfs/relocation.c   | 1991 +++++++++++++++++++++++++----------------
> >  fs/btrfs/inode.c        | 1797 +++++++++++++++++++++++++++++--------
> >  fs/btrfs/file.c         |  304 +++---
> >  fs/btrfs/tree-log.c     |  241 +++-
> > ...
> 
> What kind of bogus diffstat is this? 
> 
> Don't do that. I cannot compare your bogus diffstat with what I get, 
> because it's just random noise. You've apparently sorted it by size of the 
> damage, but the numbers are total crap too. That is _not_ the actual size 
> of the changes at all.

My the btrfs-unstable repo is against v2.6.34, here is a 'pure'
diffstat.  My script ends up piping the git log -p output through
diffstat, which does give different numbers.  I'll use the git diff
variant from now on.

# git diff v2.6.34 HEAD | diffstat
 fs/btrfs/async-thread.c |    1 
 fs/btrfs/btrfs_inode.h  |    3 
 fs/btrfs/ctree.c        |  109 +-
 fs/btrfs/ctree.h        |  163 ++-
 fs/btrfs/delayed-ref.c  |  101 --
 fs/btrfs/delayed-ref.h  |    3 
 fs/btrfs/disk-io.c      |  169 +--
 fs/btrfs/disk-io.h      |    4 
 fs/btrfs/extent-tree.c  | 2255 ++++++++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.c    |   85 -
 fs/btrfs/extent_io.h    |   14 
 fs/btrfs/file-item.c    |   28 
 fs/btrfs/file.c         |  166 ++-
 fs/btrfs/inode-item.c   |   27 
 fs/btrfs/inode.c        | 1713 ++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c        |  206 ++--
 fs/btrfs/ordered-data.c |   82 +
 fs/btrfs/ordered-data.h |    9 
 fs/btrfs/relocation.c   | 1971 +++++++++++++++++++++++++----------------
 fs/btrfs/root-tree.c    |   23 
 fs/btrfs/super.c        |   30 
 fs/btrfs/transaction.c  |  232 +++-
 fs/btrfs/transaction.h  |   24 
 fs/btrfs/tree-defrag.c  |    7 
 fs/btrfs/tree-log.c     |  241 +++--
 fs/btrfs/tree-log.h     |    2 
 fs/btrfs/volumes.c      |   17 
 fs/btrfs/xattr.c        |   12 
 fs/direct-io.c          |   62 +
 include/linux/fs.h      |   11 
 mm/filemap.c            |   36 
 31 files changed, 5066 insertions(+), 2740 deletions(-)

-chris
