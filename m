From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Sun, 6 Nov 2011 20:29:18 +0100
Message-ID: <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
References: <20111106183851.GA4339@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111106183851.GA4339@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/6 Chris Mason <chris.mason@oracle.com>:

Hi Chris,
   and thanks a lot for your work.

> Arne Jansen and Jan Schmidt have improved the scrubber and provided
> utilities to walk btrfs' many backrefs. =C2=A0The scrubber is much fa=
ster
> thanks to extensive btree readahead and instead of just telling you a
> specific block is bad, it tells you which btree or which file was
> impacted by that bad block.

   Using your for-linus branch, on latest Linus' git tree, with latest
git tools,
   I've got this:

root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate mem=
ory)
scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seco=
nds
	total bytes scrubbed: 0.00 with 0 errors
root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seco=
nds
	total bytes scrubbed: 0.00 with 0 errors

Thanks a lot for your time,
Andrea
>
> There are also progs updates to give you the same backref walking fro=
m
> the command line.
>
> SUSE and Fujitsu have a nice set of error handling fixes, and Li Zefa=
n
> also closed out some problems in the mount -o autodefrag mode.
>
> I kicked in an array of backup tree roots. =C2=A0If a given mount fai=
ls to go
> through because a tree root is bad, you can mount -o recovery and it'=
ll
> walk through the array and try older versions of the FS.
>
> I also spent a lot of time refining Fujitsu's log tree improvements.
> This code has been around for quite a while, and I really wanted to g=
et
> it in this time. =C2=A0But yesterday I hit corruptions when I mixed h=
eavy
> fsyncs with heavy snapshotting, and I wasn't able to fix things in ti=
me
> for this merge window.
>
> Josef Bacik (60) commits (+1847/-1238):
> =C2=A0 =C2=A0Btrfs: don't check bytes_pinned to determine if we shoul=
d commit the transaction (+0/-11)
> =C2=A0 =C2=A0Btrfs: allow callers to specify if flushing can occur fo=
r btrfs_block_rsv_check (+10/-10)
> =C2=A0 =C2=A0Btrfs: be smarter about committing the transaction in re=
serve_metadata_bytes (+67/-19)
> =C2=A0 =C2=A0Btrfs: release metadata from global reserve if we have t=
o fallback for unlink (+4/-1)
> =C2=A0 =C2=A0Btrfs: wait for ordered extents if we're in trouble when=
 shrinking delalloc (+17/-8)
> =C2=A0 =C2=A0Btrfs: add a io_ctl struct and helpers for dealing with =
the space cache (+375/-318)
> =C2=A0 =C2=A0Btrfs: seperate out btrfs_block_rsv_check out into 2 dif=
ferent functions (+37/-24)
> =C2=A0 =C2=A0Btrfs: check the return value of filemap_write_and_wait =
in the space cache (+5/-2)
> =C2=A0 =C2=A0Btrfs: don't increase the block_rsv's size when emergenc=
y allocating space (+0/-3)
> =C2=A0 =C2=A0Btrfs: use the global reserve when truncating the free s=
pace cache inode (+17/-5)
> =C2=A0 =C2=A0Btrfs: make sure to unset trans->block_rsv before runnin=
g delayed refs (+11/-0)
> =C2=A0 =C2=A0Btrfs: only reserve space in fallocate if we have to do =
a preallocate (+16/-6)
> =C2=A0 =C2=A0Btrfs: stop passing a trans handle all around the reserv=
ation code (+39/-43)
> =C2=A0 =C2=A0Btrfs: skip looking for delalloc if we don't have ->fill=
_delalloc (+5/-1)
> =C2=A0 =C2=A0Btrfs: if we have a lot of pinned space, commit the tran=
saction (+15/-0)
> =C2=A0 =C2=A0Btrfs: release trans metadata bytes before flushing dela=
yed refs (+3/-8)
> =C2=A0 =C2=A0Btrfs: make a delayed_block_rsv for the delayed item ins=
ertion (+13/-7)
> =C2=A0 =C2=A0Btrfs: ratelimit the generation printk for the free spac=
e cache (+7/-5)
> =C2=A0 =C2=A0Btrfs: use the global reserve as a backup for deleting i=
nodes (+11/-1)
> =C2=A0 =C2=A0Btrfs: allow shrink_delalloc flush the needed reclaimed =
pages (+3/-2)
> =C2=A0 =C2=A0Btrfs: only inherit btrfs specific flags when creating f=
iles (+11/-6)
> =C2=A0 =C2=A0Btrfs: break out of orphan cleanup if we can't make prog=
ress (+11/-0)
> =C2=A0 =C2=A0Btrfs: move stuff around in btrfs_inode to get better pa=
cking (+3/-3)
> =C2=A0 =C2=A0Btrfs: reserve some space for an orphan item when unlink=
ing (+8/-1)
> =C2=A0 =C2=A0Btrfs: wait for ordered extents if we didn't reclaim eno=
ugh (+1/-1)
> =C2=A0 =C2=A0Btrfs: check unused against how much space we actually w=
ant (+1/-1)
> =C2=A0 =C2=A0Btrfs: put the block group cache after we commit the sup=
er (+3/-3)
> =C2=A0 =C2=A0Btrfs: inline checksums into the disk free space cache (=
+172/-68)
> =C2=A0 =C2=A0Btrfs: use the inode's mapping mask for allocating pages=
 (+18/-6)
> =C2=A0 =C2=A0Btrfs: fix space leak when we fail to make an allocation=
 (+14/-6)
> =C2=A0 =C2=A0Btrfs: don't skip writing out a empty block groups cache=
 (+6/-4)
> =C2=A0 =C2=A0Btrfs: use the transactions block_rsv for the csum root =
(+10/-6)
> =C2=A0 =C2=A0Btrfs: fix call to btrfs_search_slot in free space cache=
 (+1/-1)
> =C2=A0 =C2=A0Btrfs: use d_obtain_alias when mounting subvol/subvolid =
(+1/-24)
> =C2=A0 =C2=A0Btrfs: allow us to overcommit our enospc reservations (+=
88/-18)
> =C2=A0 =C2=A0Btrfs: don't get the block_rsv in btrfs_free_tree_block =
(+0/-4)
> =C2=A0 =C2=A0Btrfs: handle enospc accounting for free space inodes (+=
47/-23)
> =C2=A0 =C2=A0Btrfs: reduce the amount of space needed for truncates (=
+15/-4)
> =C2=A0 =C2=A0Btrfs: kill the orphan space calculation for snapshots (=
+0/-90)
> =C2=A0 =C2=A0Btrfs: use bytes_may_use for all ENOSPC reservations (+1=
12/-82)
> =C2=A0 =C2=A0Btrfs: optimize how we account for space in truncate (+2=
9/-29)
> =C2=A0 =C2=A0Btrfs: fix how we reserve space for deleting inodes (+38=
/-11)
> =C2=A0 =C2=A0Btrfs: don't flush the cache inode before writing it (+0=
/-4)
> =C2=A0 =C2=A0Btrfs: take overflow into account in reserving space (+1=
/-1)
> =C2=A0 =C2=A0Btrfs: don't try to commit in btrfs_block_rsv_check (+4/=
-25)
> =C2=A0 =C2=A0Btrfs: fix the amount of space reserved for unlink (+10/=
-1)
> =C2=A0 =C2=A0Btrfs: fix regression in re-setting a large xattr (+11/-=
0)
> =C2=A0 =C2=A0Btrfs: introduce mount option no_space_cache (+22/-10)
> =C2=A0 =C2=A0Btrfs: delay iput when deleting a block group (+1/-1)
> =C2=A0 =C2=A0Btrfs: kill btrfs_truncate_reserve_metadata (+0/-34)
> =C2=A0 =C2=A0Btrfs: fix how we mount subvol=3D<whatever> (+135/-64)
> =C2=A0 =C2=A0Btrfs: calculate checksum space correctly (+118/-8)
> =C2=A0 =C2=A0Btrfs: kill the durable block rsv stuff (+17/-101)
> =C2=A0 =C2=A0Btrfs: fix delayed insertion reservation (+49/-8)
> =C2=A0 =C2=A0Btrfs: fix orphan cleanup regression (+17/-19)
> =C2=A0 =C2=A0Btrfs: kill unused parts of block_rsv (+6/-22)
> =C2=A0 =C2=A0Btrfs: introduce convert_extent_bit (+190/-0)
> =C2=A0 =C2=A0Btrfs: set truncate block rsv's size (+2/-0)
> =C2=A0 =C2=A0Btrfs: kill reserved_bytes in inode (+0/-8)
> =C2=A0 =C2=A0Btrfs: stop using write_one_page (+20/-67)
>
> Jan Schmidt (13) commits (+1954/-303):
> =C2=A0 =C2=A0btrfs: new ioctls to do logical->inode and inode->path r=
esolving (+162/-0)
> =C2=A0 =C2=A0btrfs scrub: add fixup code for errors on nodatasum file=
s (+183/-6)
> =C2=A0 =C2=A0btrfs: integrating raid-repair and scrub-fixup-nodatasum=
 (+67/-25)
> =C2=A0 =C2=A0btrfs: Moved repair code from inode.c to extent_io.c (+3=
93/-159)
> =C2=A0 =C2=A0btrfs: added helper functions to iterate backrefs (+851/=
-1)
> =C2=A0 =C2=A0btrfs: btrfs_multi_bio replaced with btrfs_bio (+90/-78)
> =C2=A0 =C2=A0btrfs: Do not use bio->bi_bdev after submission (+1/-1)
> =C2=A0 =C2=A0btrfs: add mirror_num to extent_read_full_page (+6/-6)
> =C2=A0 =C2=A0btrfs scrub: print paths of corrupted files (+163/-6)
> =C2=A0 =C2=A0btrfs scrub: use int for mirror_num, not u64 (+4/-4)
> =C2=A0 =C2=A0btrfs scrub: bugfix: mirror_num off by one (+6/-6)
> =C2=A0 =C2=A0btrfs scrub: added unverified_errors (+26/-11)
> =C2=A0 =C2=A0btrfs: Put mirror_num in bi_bdev (+2/-0)
>
> Chris Mason (10) commits (+490/-67):
> =C2=A0 =C2=A0Btrfs: make sure to flush queued bios if write_cache_pag=
es waits (+22/-10)
> =C2=A0 =C2=A0Btrfs: don't wait as long for more batches during SSD lo=
g commit (+2/-2)
> =C2=A0 =C2=A0Btrfs: fix extent_buffer leak in the metadata IO error h=
andling (+1/-0)
> =C2=A0 =C2=A0Btrfs: ClearPageError during writepage and clean_tree_bl=
ock (+10/-1)
> =C2=A0 =C2=A0Btrfs: make sure btrfs_remove_free_space doesn't leak EA=
GAIN (+3/-1)
> =C2=A0 =C2=A0Btrfs: fix the new inspection ioctls for 32 bit compat (=
+15/-16)
> =C2=A0 =C2=A0Btrfs: stop the readahead threads on failed mount (+1/-0=
)
> =C2=A0 =C2=A0Btrfs: fix extent pinning bugs in the tree log (+59/-8)
> =C2=A0 =C2=A0Btrfs: fix race during transaction joins (+8/-5)
> =C2=A0 =C2=A0Btrfs: add a log of past tree roots (+369/-24)
>
> Li Zefan (7) commits (+47/-24):
> =C2=A0 =C2=A0Btrfs: fix wrong max_to_defrag in btrfs_defrag_file() (+=
1/-1)
> =C2=A0 =C2=A0Btrfs: honor extent thresh during defragmentation (+26/-=
11)
> =C2=A0 =C2=A0Btrfs: remove BUG_ON() in compress_file_range() (+5/-1)
> =C2=A0 =C2=A0Btrfs: use i_size_read() in btrfs_defrag_file() (+4/-3)
> =C2=A0 =C2=A0Btrfs: fix defragmentation regression (+4/-2)
> =C2=A0 =C2=A0Btrfs: fix direct-io vs nodatacow (+1/-2)
> =C2=A0 =C2=A0Btrfs: fix array bound checking (+6/-4)
>
> Ilya Dryomov (6) commits (+22/-21):
> =C2=A0 =C2=A0Btrfs: pass the correct root to lookup_free_space_inode(=
) (+1/-1)
> =C2=A0 =C2=A0Btrfs: rename btrfs_bio multi -> bbio for consistency (+=
15/-15)
> =C2=A0 =C2=A0Btrfs: fix a potential btrfs_bio leak on scrub fixups (+=
1/-0)
> =C2=A0 =C2=A0Btrfs: stop leaking btrfs_bios on readahead (+2/-0)
> =C2=A0 =C2=A0Btrfs: fix a bug when opening seed devices (+1/-1)
> =C2=A0 =C2=A0Btrfs: close all bdevs on mount failure (+2/-4)
>
> Arne Jansen (6) commits (+1130/-70):
> =C2=A0 =C2=A0btrfs: add an extra wait mode to read_extent_buffer_page=
s (+9/-6)
> =C2=A0 =C2=A0btrfs: initial readahead code and prototypes (+967/-1)
> =C2=A0 =C2=A0btrfs: add READAHEAD extent buffer flag (+35/-0)
> =C2=A0 =C2=A0btrfs: state information for readahead (+31/-0)
> =C2=A0 =C2=A0btrfs: use readahead API for scrub (+50/-62)
> =C2=A0 =C2=A0btrfs: hooks for readahead (+38/-1)
>
> David Sterba (3) commits (+105/-77):
> =C2=A0 =C2=A0btrfs: do not allow mounting non-subvolumes via subvol o=
ption (+19/-0)
> =C2=A0 =C2=A0btrfs: separate superblock items out of fs_info (+78/-76=
)
> =C2=A0 =C2=A0btrfs: ratelimit WARN_ON in use_block_rsv (+8/-1)
>
> Zheng Yan (1) commits (+4/-1):
> =C2=A0 =C2=A0btrfs: check file extent backref offset underflow
>
> Lukas Czerner (1) commits (+5/-1):
> =C2=A0 =C2=A0btrfs: return EINVAL if start > total_bytes in fitrim io=
ctl
>
> Daniel J Blueman (1) commits (+6/-2):
> =C2=A0 =C2=A0btrfs: fix oops on failure path
>
> Liu Bo (1) commits (+1/-1):
> =C2=A0 =C2=A0Btrfs: do not set EXTENT_DIRTY along with EXTENT_DELALLO=
C
>
> Diego Calleja (1) commits (+1/-3):
> =C2=A0 =C2=A0btrfs: fix memory leak in btrfs_defrag_file
>
> Jeff Liu (1) commits (+8/-2):
> =C2=A0 =C2=A0btrfs: trivial fix, a potential memory leak in btrfs_par=
se_early_options()
>
> Miao Xie (1) commits (+7/-0):
> =C2=A0 =C2=A0Btrfs: fix race between multi-task space allocation and =
caching space
>
> Tsutomu Itoh (1) commits (+7/-10):
> =C2=A0 =C2=A0Btrfs: fix return value of btrfs_get_acl()
>
> Total: (113) commits
>
> =C2=A0fs/btrfs/Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=
=A03 +-
> =C2=A0fs/btrfs/acl.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| =C2=A0 17 +-
> =C2=A0fs/btrfs/backref.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A077=
6 +++++++++++++++++++++++++++++++++++
> =C2=A0fs/btrfs/backref.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 6=
2 +++
> =C2=A0fs/btrfs/btrfs_inode.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 17 +-
> =C2=A0fs/btrfs/compression.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A03 +-
> =C2=A0fs/btrfs/ctree.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 10 +-
> =C2=A0fs/btrfs/ctree.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0198 ++++++++--
> =C2=A0fs/btrfs/delayed-inode.c =C2=A0 =C2=A0| =C2=A0 50 ++-
> =C2=A0fs/btrfs/disk-io.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A043=
4 +++++++++++++++++---
> =C2=A0fs/btrfs/disk-io.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=
=A04 +-
> =C2=A0fs/btrfs/extent-tree.c =C2=A0 =C2=A0 =C2=A0| =C2=A0848 ++++++++=
+++++++++++++++---------------
> =C2=A0fs/btrfs/extent_io.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0614 +++=
++++++++++++++++++++++++-
> =C2=A0fs/btrfs/extent_io.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 23 +-
> =C2=A0fs/btrfs/file-item.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 17 +-
> =C2=A0fs/btrfs/file.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=
=A0 25 +-
> =C2=A0fs/btrfs/free-space-cache.c | =C2=A0926 +++++++++++++++++++++++=
++----------------
> =C2=A0fs/btrfs/inode-map.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A0=
6 +-
> =C2=A0fs/btrfs/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0457 +++++++--------------
> =C2=A0fs/btrfs/ioctl.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0227 +++++++++--
> =C2=A0fs/btrfs/ioctl.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 29 ++
> =C2=A0fs/btrfs/print-tree.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A08 +-
> =C2=A0fs/btrfs/reada.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0951 +++++++++++++++++++++++++++++++++++++++++++
> =C2=A0fs/btrfs/relocation.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 24 +-
> =C2=A0fs/btrfs/scrub.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0591 ++++++++++++++++++++++-----
> =C2=A0fs/btrfs/super.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0298 +++++++++-----
> =C2=A0fs/btrfs/transaction.c =C2=A0 =C2=A0 =C2=A0| =C2=A0146 +++----
> =C2=A0fs/btrfs/tree-log.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 19 +-
> =C2=A0fs/btrfs/volumes.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A020=
7 ++++++----
> =C2=A0fs/btrfs/volumes.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 1=
8 +-
> =C2=A0fs/btrfs/xattr.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 11 +
> =C2=A031 files changed, 5416 insertions(+), 1603 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
