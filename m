From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 15 Mar 2010 15:18:07 -0400
Message-ID: <20100315191807.GA3449@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of the btrfs unstable tree has a collection of fixes
and features:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

If Linus decides this pull is too big/too late, we'll maintain a bug fix
only branch for .34 and keep this branch stable for people that want to
pull in the new features.

One big feature from this code is the ability to change which subvolume
or snapshot is mounted by default.  For a while, we've had mount -o
subvol, which lets you jump into a subvolume instead of using the
default root.  Something like this:

mkfs.btrfs /dev/xxx
mount /dev/xxx /mnt
# did I mention the new 'btrfs' command in btrfs-progs-unstable?
btrfs subvolume create /mnt/new_subvol
umount /mnt
mount -o subvol=new_subvol /dev/xxx /mnt

The new ioctl allows you to set this once and have it used as the new
default for every mount (without any mount options), until you change it
again.  This is part of snapshot assisted upgrades, where you can take a
snapshot and revert back to the old tree if it didn't work out.

But (and this is why I mention it up top), the ioctl also sets an
incompat bit on the super block because we ended up doing it differently
than I had planned in the disk format.  People would end up with a big
surprise if they mounted with 2.6.33 and got one directory tree but
mounted with 2.6.32 and got another, so we flip an incompat bit when the
ioctl is run.

The incompat bit is only set if you run the set-default ioctl.

The btrfs-unstable git tree is against 2.6.32 so you can pull
it into older trees.

The file defragging ioctl had some bugs that could lead to getting stuck
in balance_dirty_pages.  I fixed these up and changed it to only defrag
extents in the file that were actually fragmented.  I added the ability
to compress a single file on demand and defrag only a range of bytes in
the file.

When snapshots are taken, we now wait for all the delayed allocation
extents to hit the disk first.  When I originally made the snapshotting
code, there were many different threads flaming pony fsyncs and I had
this funny idea that people really wanted to run the btrfs sync ioctl
before snapshotting.  At any rate, we have snapshotting ponies now.

There's a new ioctl to list all the subvolumes on the filesystem.  This
makes use of a new interface that runs tree searches from userland,
which we'll build on and use for incremental backups in later
btrfs-progs releases.

Josef changed the math for df a little to better reflect space available
for data, and factors in duplication for raid and single spindle dup.
He also added a space info ioctl which shows how much space is tied up
in metadata, and shows the raid level used for metadata/data.

The short log shows that most of these changes are in the ioctls, but we
have performance fixes in the mix as well, mostly to reduce contention
on the in-ram extent mapping and state trees for each file.

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

Chris Mason (6) commits (+573/-56):
    Btrfs: run the backing dev more often in the submit_bio helper (+10/-10)
    Btrfs: finish read pages in the order they are submitted (+4/-3)
    Btrfs: don't look at bio flags after submit_bio (+3/-3)
    Btrfs: be more selective in the defrag ioctl (+140/-10)
    Btrfs: add search and inode lookup ioctls (+299/-16)
    Btrfs: add new defrag-range ioctl. (+117/-14)

TARUISI Hiroaki (2) commits (+99/-0):
    Btrfs: add a function to lookup a directory path by following backrefs (+92/-0)
    btrfs: Update existing btrfs_device for renaming device (+7/-0)

Sage Weil (1) commits (+1/-4):
    Btrfs: flush data on snapshot creation

Xiao Guangrong (1) commits (+3/-3):
    btrfs: using btrfs_stack_device_id() get devid

Akinobu Mita (1) commits (+4/-30):
    btrfs: use memparse

Miao Xie (1) commits (+1/-1):
    btrfs: fix btrfs_mkdir goto for no free objectids

Nick Piggin (1) commits (+1/-1):
    Btrfs: fix gfp flags masking in the compression code

Total: (23) commits

 fs/btrfs/btrfs_inode.h  |    5 
 fs/btrfs/compression.c  |    2 
 fs/btrfs/ctree.h        |   13 
 fs/btrfs/disk-io.c      |   15 -
 fs/btrfs/export.c       |    4 
 fs/btrfs/extent-tree.c  |   11 
 fs/btrfs/extent_io.c    |   79 +++--
 fs/btrfs/extent_io.h    |   10 
 fs/btrfs/file.c         |   23 -
 fs/btrfs/inode.c        |  139 +++++----
 fs/btrfs/ioctl.c        |  698 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/ioctl.h        |  113 +++++++
 fs/btrfs/ordered-data.c |   41 +-
 fs/btrfs/ordered-data.h |    7 
 fs/btrfs/relocation.c   |    4 
 fs/btrfs/super.c        |  244 ++++++++++++----
 fs/btrfs/transaction.c  |    5 
 fs/btrfs/tree-log.c     |    2 
 fs/btrfs/volumes.c      |   39 +-
 19 files changed, 1199 insertions(+), 255 deletions(-)
