From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Thu, 18 Mar 2010 12:59:50 -0400
Message-ID: <20100318165950.GE14074@think>
References: <20100315191807.GA3449@think>
 <20100316210150.GA14886@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100316210150.GA14886@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 16, 2010 at 05:01:50PM -0400, Chris Mason wrote:
> On Mon, Mar 15, 2010 at 03:18:07PM -0400, Chris Mason wrote:
> > Hello everyone,
> > 
> > The master branch of the btrfs unstable tree has a collection of fixes
> > and features:
> > 

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

> 
> I've updated the master tree with 3 small fixes.  Thanks to Sage for
> sending along a one liner for a bad cast in the searching ioctl, really
> not sure why my gcc isn't giving the same warnings his was.
> 
> I fixed the new space info ioctl to avoid scheduling in a
> rcu_read_lock.  Sage also turned u64 to __u64 in the space_info ioctl
> args struct.

I mentioned how the new searching ioctl could be used to very quickly
find updated files, and that I was planning on adding this.  There were
a few questions about how it might work, so I worked up a prototype.

I had to make some small mods to the kernel side to be more friendly to
userland, mostly just fixing up how we advance through the keys.  For an
example of how this works, cloned the linux-26 git repo onto a fresh FS,
then modified a single file.

I timed how long it took find to find my one modified file (via find
-newer) and I timed my ioctl.

Find took 9s, the ioctl took .024s.

A repeat of the test on a much larger filesystem had find timed in at
25s and the ioctl at 2s.

The prototype is called btrfs subvol find-new and it can be found in the
master branch of the btrfs-progs-unstable repo.  I've updated the master branch
on the kernel side.  Here are the updates since my last pull request:

Chris Mason (4) commits (+35/-18):
    Btrfs: fix the inode ref searches done by btrfs_search_path_in_tree (+6/-3)
    Btrfs: fix key checks and advance in the search ioctl (+25/-14)
    Btrfs: return keys for large items to the search ioctl (+1/-1)
    Btrfs: allow treeid==0 in the inode lookup ioctl (+3/-0)

Total: (4) commits

 fs/btrfs/ioctl.c |   53 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 18 deletions(-)

And here is the full log of things missing from Linus' git tree right
now.

Chris Mason (11) commits (+654/-85):
    Btrfs: fix the inode ref searches done by btrfs_search_path_in_tree (+6/-3)
    Btrfs: run the backing dev more often in the submit_bio helper (+10/-10)
    Btrfs: finish read pages in the order they are submitted (+4/-3)
    Btrfs: fix key checks and advance in the search ioctl (+25/-14)
    Btrfs: return keys for large items to the search ioctl (+1/-1)
    Btrfs: allow treeid==0 in the inode lookup ioctl (+3/-0)
    Btrfs: buffer results in the space_info ioctl (+46/-11)
    Btrfs: don't look at bio flags after submit_bio (+3/-3)
    Btrfs: be more selective in the defrag ioctl (+140/-10)
    Btrfs: add search and inode lookup ioctls (+299/-16)
    Btrfs: add new defrag-range ioctl. (+117/-14)

Josef Bacik (10) commits (+517/-160):
    Btrfs: make set/get functions for the super compat_ro flags use compat_ro (+1/-1)
    Btrfs: change the ordered tree to use a spinlock instead of a mutex (+19/-19)
    Btrfs: add ioctl and incompat flag to set the default mount subvol (+80/-1)
    Btrfs: cache the extent state everywhere we possibly can V2 (+148/-90)
    Btrfs: make subvolid=0 mount the original default root (+9/-3)
    Btrfs: make df be a little bit more understandable (+26/-3)
    Btrfs: cache extent state in find_delalloc_range (+8/-3)
    Btrfs: cache ordered extent when completing io (+10/-5)
    Btrfs: change how we mount subvolumes (+158/-34)
    Btrfs: add a "df" ioctl for btrfs (+58/-1)

Sage Weil (3) commits (+7/-10):
    Btrfs: flush data on snapshot creation (+1/-4)
    Btrfs: fix search_ioctl key advance (+1/-1)
    Btrfs: use __u64 types in ioctl.h (+5/-5)

TARUISI Hiroaki (2) commits (+99/-0):
    Btrfs: add a function to lookup a directory path by following backrefs (+92/-0)
    btrfs: Update existing btrfs_device for renaming device (+7/-0)

Xiao Guangrong (1) commits (+3/-3):
    btrfs: using btrfs_stack_device_id() get devid

Akinobu Mita (1) commits (+4/-30):
    btrfs: use memparse

Miao Xie (1) commits (+1/-1):
    btrfs: fix btrfs_mkdir goto for no free objectids

Nick Piggin (1) commits (+1/-1):
    Btrfs: fix gfp flags masking in the compression code

Total: (30) commits

 fs/btrfs/ioctl.c        |  810 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/super.c        |  244 ++++++++++----
 fs/btrfs/inode.c        |  139 +++++---
 fs/btrfs/ioctl.h        |  123 ++++++-
 fs/btrfs/extent_io.c    |   79 ++--
 fs/btrfs/ordered-data.c |   41 +-
 fs/btrfs/volumes.c      |   39 +-
 fs/btrfs/file.c         |   23 -
 fs/btrfs/disk-io.c      |   15 
 fs/btrfs/ctree.h        |   13 
 fs/btrfs/extent-tree.c  |   11 
 fs/btrfs/extent_io.h    |   10 
 fs/btrfs/ordered-data.h |    7 
 fs/btrfs/transaction.c  |    5 
 fs/btrfs/btrfs_inode.h  |    5 
 fs/btrfs/relocation.c   |    4 
 fs/btrfs/export.c       |    4 
 fs/btrfs/tree-log.c     |    2 
 fs/btrfs/compression.c  |    2 
 19 files changed, 1286 insertions(+), 290 deletions(-)

