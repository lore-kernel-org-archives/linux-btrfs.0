From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 18 Apr 2011 10:26:22 -0400
Message-ID: <1303135497-sup-59@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The master branch of the btrfs unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a nice pile of btrfs fixes.  Josef tackled a variety of DIO problems
including latencies and crc errors.  He also fixed a crash in the
mount -o free_space_cache mode, and dramatically reduced contention on
the journal mutex.  Less contention means we finish up endio processing
faster and we're able to process delalloc much faster as space gets
tight.

Our ENOSPC fixes have returned.  The cluster allocation code was
sometimes getting out of hand and leaving us with a filesystem full of
metadata chunks.

Fujitsu continues a long series of error handling improvements and
fixes, and Sergei Trofimovich fixed a memcpy vs memmove bug.

I've removed a duplicate commit from the shortlog below.  Josef and I
both managed to take his iov_base fix.  Git did the right thing and the
resulting code is correct.

Josef Bacik (10) commits (+224/-133):
    Btrfs: reuse the extent_map we found when calling btrfs_get_extent (+28/-8)
    Btrfs: do not call btrfs_update_inode in endio if nothing changed (+10/-5)
    Btrfs: deal with the case that we run out of space in the cache (+69/-74)
    Btrfs: avoid taking the trans_mutex in btrfs_end_transaction (+19/-24)
    Btrfs: check for duplicate iov_base's when doing dio reads (+16/-1)
    Btrfs: avoid taking the chunk_mutex in do_chunk_alloc (+28/-6)
    Btrfs: map the inode item when doing fill_inode_item (+12/-0)
    Btrfs: do not use async submit for small DIO io's (+19/-5)
    Btrfs: don't split dio bios if we don't have to (+13/-7)
    Btrfs: only retry transaction reservation once (+10/-1)

Chris Mason (4) commits (+78/-29):
    Btrfs end_bio_extent_readpage should look for locked bits (+1/-1)
    Btrfs: don't force chunk allocation in find_free_extent (+73/-22)
    Btrfs: make uncache_state unconditional (+3/-5)
    Btrfs: fix free space cache leak (+1/-1)

Li Zefan (2) commits (+22/-39):
    Btrfs: Check if btrfs_next_leaf() returns error in btrfs_real_readdir() (+10/-18)
    Btrfs: Check if btrfs_next_leaf() returns error in btrfs_listxattr() (+12/-21)

Miao Xie (2) commits (+8/-7):
    Btrfs: Fix incorrect inode nlink in btrfs_link() (+3/-3)
    Btrfs: Check validity before setting an acl (+5/-4)

Sergei Trofimovich (1) commits (+11/-3):
    btrfs: properly handle overlapping areas in memmove_extent_buffer

Yoshinori Sano (1) commits (+4/-1):
    Btrfs: fix memory leaks in btrfs_new_inode()

Xin Zhong (1) commits (+33/-9):
    Btrfs: fix subvolume mount by name problem when default mount subvolume is set

Daniel J Blueman (1) commits (+1/-1):
    fix user annotation in ioctl.c

Arne Jansen (1) commits (+55/-19):
    btrfs: using cached extent_state in set/unlock combinations

Total: (24) commits (+452/-240)

 fs/btrfs/acl.c              |    9 ++-
 fs/btrfs/ctree.h            |    9 ++-
 fs/btrfs/disk-io.c          |    2 +-
 fs/btrfs/extent-tree.c      |  125 +++++++++++++++++++++++++-------
 fs/btrfs/extent_io.c        |   82 ++++++++++++++++-----
 fs/btrfs/extent_io.h        |    2 +-
 fs/btrfs/file.c             |   21 +++---
 fs/btrfs/free-space-cache.c |  119 +++++++++++++++----------------
 fs/btrfs/inode.c            |  165 ++++++++++++++++++++++++++++++-------------
 fs/btrfs/ioctl.c            |    2 +-
 fs/btrfs/super.c            |   42 +++++++++---
 fs/btrfs/transaction.c      |   48 +++++++------
 fs/btrfs/transaction.h      |    4 +-
 fs/btrfs/xattr.c            |   33 +++------
 14 files changed, 430 insertions(+), 233 deletions(-)
