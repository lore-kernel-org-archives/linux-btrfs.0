From: Chester <somethingsome2000@gmail.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Fri, 27 May 2011 16:44:46 -0500
Message-ID: <BANLkTinU7o3OMuCdYB5aMG-kjg7dQFqUXw@mail.gmail.com>
References: <1306525303-sup-718@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306525303-sup-718@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

One question. Will the autodefrag option be snapshot aware? Would
enabling this option double the amount of used space if there is a
snapshot present?

On Fri, May 27, 2011 at 2:55 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
>
> Hi everyone,
>
> I always thought that I'd be retired and with my flying car at the
> beach by the time 3.0 came out, but I've setup the for-linus branch o=
f
> the btrfs-unstable tree for pulling:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.gi=
t for-linus
>
> This pull request is probably the biggest I've sent, but it isn't
> a code dump into our shiny new .0 rc. =A0The bulk of the changes are
> three separate projects that have been going on for 6-8 months:
>
> =A0 =A0 =A0 =A0A new btrfs inode allocation cache (Li Zefan)
> =A0 =A0 =A0 =A0Delayed metadata insertion into the btree (Miao Xe)
> =A0 =A0 =A0 =A0Device scrubbing (Arne Jansen)
>
> On top of that Dave Sterba kicked in a series of code cleanups and Jo=
sef
> Bacik did some really nice tuning. =A0The short log lists a few other
> cleanups and fixes too.
>
> I coded up a mount -o autodefrag that will detect random writes
> into existing files and kick off background defragging. =A0It is well
> suited to bdb or sqlite databases, but not virtualization images or b=
ig
> databases (yet). =A0Once I make sure it doesn't defrag files over and=
 over
> again, I'll move this toward the default.
>
> David Sterba (17) commits (+310/-3253):
> =A0 =A0btrfs: rename variables clashing with global function names (+=
53/-53)
> =A0 =A0btrfs: use printk_ratelimited instead of printk_ratelimit (+10=
/-24)
> =A0 =A0btrfs: drop unused parameter from btrfs_release_path (+160/-16=
0)
> =A0 =A0btrfs: drop unused parameter from extent_map_tree_init (+5/-7)
> =A0 =A0btrfs: drop unused argument from extent_io_tree_init (+10/-12)
> =A0 =A0btrfs: remove nested duplicate variable declarations (+0/-4)
> =A0 =A0btrfs: drop gfp parameter from alloc_extent_buffer (+7/-9)
> =A0 =A0btrfs: drop gfp parameter from find_extent_buffer (+4/-6)
> =A0 =A0btrfs: drop gfp parameter from alloc_extent_map (+16/-17)
> =A0 =A0btrfs: use unsigned type for single bit bitfield (+4/-4)
> =A0 =A0btrfs: remove old unused commented out code (+1/-2071)
> =A0 =A0btrfs: Document a mutex lock/unlock sequence (+12/-0)
> =A0 =A0btrfs: make functions static when possible (+7/-7)
> =A0 =A0btrfs: unify checking of IS_ERR and null (+17/-17)
> =A0 =A0btrfs: remove unused function prototypes (+0/-43)
> =A0 =A0btrfs: remove all unused functions (+1/-817)
> =A0 =A0btrfs: fix dereference before check (+3/-2)
>
> Li Zefan (8) commits (+1449/-665):
> =A0 =A0Btrfs: Make the code for reading/writing free space cache gene=
ric (+204/-154)
> =A0 =A0Btrfs: setup free ino caching in a more asynchronous way (+22/=
-6)
> =A0 =A0Btrfs: Support reading/writing on disk free ino cache (+236/-1=
9)
> =A0 =A0Btrfs: Remove unused btrfs_block_group_free_space() (+0/-16)
> =A0 =A0Btrfs: Make free space cache code generic (+271/-223)
> =A0 =A0Btrfs: Cache free inode numbers in memory (+500/-53)
> =A0 =A0Btrfs: Always use 64bit inode number (+208/-182)
> =A0 =A0Btrfs: Use bitmap_set/clear() (+8/-12)
>
> Xiao Guangrong (7) commits (+134/-59):
> =A0 =A0Btrfs: allocate extent state and check the result properly (+2=
6/-8)
> =A0 =A0Btrfs: using rcu lock in the reader side of devices list (+72/=
-36)
> =A0 =A0Btrfs: fix the race between reading and updating devices (+9/-=
0)
> =A0 =A0Btrfs: fix the race between remove dev and alloc chunk (+6/-0)
> =A0 =A0Btrfs: fix bh leak on __btrfs_open_devices path (+1/-0)
> =A0 =A0Btrfs: fix unsafe usage of merge_state (+14/-8)
> =A0 =A0Btrfs: drop unnecessary device lock (+6/-7)
>
> Arne Jansen (6) commits (+1822/-361):
> =A0 =A0btrfs scrub: don't coalesce pages that are logically discontig=
uous (+2/-1)
> =A0 =A0btrfs: move btrfs_cmp_device_free_bytes to super.c (+26/-28)
> =A0 =A0btrfs: quasi-round-robin for chunk allocation (+177/-305)
> =A0 =A0btrfs: add readonly flag (+16/-12)
> =A0 =A0btrfs: heed alloc_start (+1/-4)
> =A0 =A0btrfs: scrub (+1600/-11)
>
> Tsutomu Itoh (5) commits (+43/-36):
> =A0 =A0Btrfs: BUG_ON is deleted from the caller of btrfs_truncate_ite=
m & btrfs_extend_item (+2/-17)
> =A0 =A0Btrfs: return error code to caller when btrfs_previous_item fa=
ils (+3/-2)
> =A0 =A0Btrfs: return error code to caller when btrfs_del_item fails (=
+19/-11)
> =A0 =A0Btrfs: return error to caller if read_one_inode() fails (+18/-=
6)
> =A0 =A0Btrfs: check return value of btrfs_inc_extent_ref() (+1/-0)
>
> Chris Mason (4) commits (+689/-144):
> =A0 =A0Btrfs: update the delayed inode code to use the btrfs_ino help=
er. (+7/-6)
> =A0 =A0Btrfs: use the device_list_mutex during write_dev_supers (+2/-=
2)
> =A0 =A0Btrfs: return -ENOMEM in clear_extent_bit (+2/-1)
> =A0 =A0Btrfs: add mount -o auto_defrag (+678/-135)
>
> Sergei Trofimovich (3) commits (+7/-3):
> =A0 =A0btrfs: don't spin in shrink_delalloc if there is nothing to fr=
ee (+4/-0)
> =A0 =A0btrfs: fix typo 'testeing' -> 'testing' (+2/-2)
> =A0 =A0btrfs: typo: 'btrfS' -> 'btrfs' (+1/-1)
>
> Jan Schmidt (1) commits (+169/-2):
> =A0 =A0btrfs: new ioctls for scrub
>
> liubo (1) commits (+3/-0):
> =A0 =A0Btrfs: do not flush csum items of unchanged file data during t=
reelog
>
> Miao Xie (1) commits (+2074/-91):
> =A0 =A0btrfs: implement delayed inode items operation
>
> Julia Lawall (1) commits (+4/-1):
> =A0 =A0fs/btrfs: Add missing btrfs_free_path
>
> Andi Kleen (1) commits (+0/-4):
> =A0 =A0BTRFS: Remove unused node_lock
>
> Ilya Dryomov (1) commits (+80/-207):
> =A0 =A0btrfs scrub: make fixups sync
>
> Jamey Sharp (1) commits (+0/-43):
> =A0 =A0btrfs: Delete unused version.sh script.
>
> Hugo Mills (1) commits (+1/-3):
> =A0 =A0btrfs: Ensure the tree search ioctl returns the right number o=
f records
>
> Total: (58) commits
>
> =A0fs/btrfs/Makefile =A0 =A0 =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/btrfs/acl.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/btrfs/btrfs_inode.h =A0 =A0 =A0| =A0 15 +
> =A0fs/btrfs/compression.c =A0 =A0 =A0| =A0 47 +-
> =A0fs/btrfs/compression.h =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/btrfs/ctree.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 51 +-
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 =A0 =A0 =A0| =A0244 +++---
> =A0fs/btrfs/delayed-inode.c =A0 =A0| 1695 +++++++++++++++++++++++++++=
+++++++++
> =A0fs/btrfs/delayed-inode.h =A0 =A0| =A0141 +++
> =A0fs/btrfs/delayed-ref.c =A0 =A0 =A0| =A0114 ---
> =A0fs/btrfs/delayed-ref.h =A0 =A0 =A0| =A0 =A06 -
> =A0fs/btrfs/dir-item.c =A0 =A0 =A0 =A0 | =A0 39 +-
> =A0fs/btrfs/disk-io.c =A0 =A0 =A0 =A0 =A0| =A0210 +++--
> =A0fs/btrfs/disk-io.h =A0 =A0 =A0 =A0 =A0| =A0 19 +-
> =A0fs/btrfs/export.c =A0 =A0 =A0 =A0 =A0 | =A0 25 +-
> =A0fs/btrfs/extent-tree.c =A0 =A0 =A0| 2014 ++++---------------------=
------------------
> =A0fs/btrfs/extent_io.c =A0 =A0 =A0 =A0| =A0324 ++------
> =A0fs/btrfs/extent_io.h =A0 =A0 =A0 =A0| =A0 40 +-
> =A0fs/btrfs/extent_map.c =A0 =A0 =A0 | =A0 =A08 +-
> =A0fs/btrfs/extent_map.h =A0 =A0 =A0 | =A0 =A04 +-
> =A0fs/btrfs/file-item.c =A0 =A0 =A0 =A0| =A0 38 +-
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0302 ++++++-
> =A0fs/btrfs/free-space-cache.c | =A0993 +++++++++++++---------
> =A0fs/btrfs/free-space-cache.h | =A0 48 +-
> =A0fs/btrfs/inode-item.c =A0 =A0 =A0 | =A0 =A02 -
> =A0fs/btrfs/inode-map.c =A0 =A0 =A0 =A0| =A0444 ++++++++++-
> =A0fs/btrfs/inode-map.h =A0 =A0 =A0 =A0| =A0 13 +
> =A0fs/btrfs/inode.c =A0 =A0 =A0 =A0 =A0 =A0| =A0700 ++++++---------
> =A0fs/btrfs/ioctl.c =A0 =A0 =A0 =A0 =A0 =A0| =A0624 +++++++++++---
> =A0fs/btrfs/ioctl.h =A0 =A0 =A0 =A0 =A0 =A0| =A0107 ++-
> =A0fs/btrfs/locking.c =A0 =A0 =A0 =A0 =A0| =A0 25 -
> =A0fs/btrfs/locking.h =A0 =A0 =A0 =A0 =A0| =A0 =A02 -
> =A0fs/btrfs/ref-cache.c =A0 =A0 =A0 =A0| =A0164 ----
> =A0fs/btrfs/ref-cache.h =A0 =A0 =A0 =A0| =A0 24 -
> =A0fs/btrfs/relocation.c =A0 =A0 =A0 | =A0 67 +-
> =A0fs/btrfs/root-tree.c =A0 =A0 =A0 =A0| =A0 61 +--
> =A0fs/btrfs/scrub.c =A0 =A0 =A0 =A0 =A0 =A0| 1369 +++++++++++++++++++=
++++++++++
> =A0fs/btrfs/super.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 51 +-
> =A0fs/btrfs/sysfs.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 77 --
> =A0fs/btrfs/transaction.c =A0 =A0 =A0| =A0196 ++---
> =A0fs/btrfs/transaction.h =A0 =A0 =A0| =A0 =A05 +-
> =A0fs/btrfs/tree-defrag.c =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/btrfs/tree-log.c =A0 =A0 =A0 =A0 | =A0208 +++--
> =A0fs/btrfs/tree-log.h =A0 =A0 =A0 =A0 | =A0 =A01 -
> =A0fs/btrfs/version.sh =A0 =A0 =A0 =A0 | =A0 43 -
> =A0fs/btrfs/volumes.c =A0 =A0 =A0 =A0 =A0| =A0657 ++++++---------
> =A0fs/btrfs/volumes.h =A0 =A0 =A0 =A0 =A0| =A0 27 +-
> =A0fs/btrfs/xattr.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 12 +-
> =A048 files changed, 6594 insertions(+), 4670 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
