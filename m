Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22466 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2FANSn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 09:18:43 -0400
Date: Fri, 1 Jun 2012 09:18:38 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120601131838.GL31087@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

My for-linus branch is updated for 3.5:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This includes a fairly large change from Josef around data writeback
completion.  Before, the writeback wasn't completed until the metadata
insertions for the extent were done, and this made for fairly large
latency spikes on the last page of each ordered extent.

We already had a separate mechanism for tracking pending metadata
insertions, so Josef just needed to tweak things a little to end
writeback earlier on the page.  Overall it makes us much friendly to
memory reclaim and lowers latencies quite a lot for synchronous IO.

Jan Schmidt has finished some background work required to track btree
blocks as they go through changes in ownership.  It's the missing piece
he needed for both btrfs send/receive and subvolume quotas.  Neither of
those are ready yet, but the new tracking code is included here.  Most
of the time, the new code is off.  It is only used by scrub and other
backref walkers.

Stefan Behrens has added io failure tracking.  This includes counters
for which drives are causing the most trouble so the admin (or an
automated tool) can choose to kick them out.  We're tracking IO errors,
crc errors, and generation checks we do on each metadata block.

RAID5/6 did miss the cut this time because I'm having trouble with
corruptions.  I'll nail it down next week and post as a beta testing
before 3.6

Jan Schmidt (21) commits (+1405/-290):
    Btrfs: bugfix: ignore the wrong key for indirect tree block backrefs (+135/-50)
    Btrfs: add del_ptr and insert_ptr modifications to the tree mod log (+32/-10)
    Btrfs: add inodes before dropping the extent lock in find_all_leafs (+43/-6)
    Btrfs: fix tree mod log rewinded level and rewinding of moved keys (+4/-2)
    Btrfs: use delayed ref sequence numbers for all fs-tree updates (+13/-23)
    Btrfs: add missing spin_lock for insertion into tree mod log (+18/-5)
    Btrfs: don't set for_cow parameter for tree block functions (+20/-20)
    Btrfs: use the tree modification log for backref resolving (+29/-17)
    Btrfs: put all block modifications into the tree mod log (+36/-0)
    Btrfs: tree mod log sanity checks in join_transaction (+18/-0)
    Btrfs: look into the extent during find_all_leafs (+158/-84)
    Btrfs: fs_info variable for join_transaction (+19/-18)
    Btrfs: dummy extent buffers for tree mod log (+76/-7)
    Btrfs: add tree modification log functions (+412/-1)
    Btrfs: bugfix in btrfs_find_parent_nodes (+3/-2)
    Btrfs: move struct seq_list to ctree.h (+7/-5)
    Btrfs: add tree_mod_dont_log helper (+15/-9)
    Btrfs: add tree mod log to fs_info (+14/-0)
    Btrfs: add btrfs_search_old_slot (+317/-4)
    Btrfs: fix tree mod log del_ptr (+7/-6)
    Btrfs: ulist realloc bugfix (+29/-21)

Josef Bacik (13) commits (+330/-322):
    Btrfs: convert the inode bit field to use the actual bit operations (+44/-44)
    Btrfs: check to see if the inode is in the log before fsyncing (+16/-17)
    Btrfs: merge contigous regions when loading free space cache (+41/-0)
    Btrfs: fall back to non-inline if we don't have enough space (+4/-1)
    Btrfs: do not check delalloc when updating disk_i_size (+3/-16)
    Btrfs: do not do filemap_write_and_wait_range in fsync (+6/-5)
    Btrfs: finish ordered extents in their own thread (+164/-191)
    Btrfs: remove useless waiting and extra filemap work (+2/-15)
    Btrfs: fix how we deal with the orphan block rsv (+24/-22)
    Btrfs: use i_version instead of our own sequence (+19/-10)
    Btrfs: fix return code in drop_objectid_items (+2/-0)
    Btrfs: fix compile warnings in extent_io.c (+1/-1)
    Btrfs: cache no acl on new inodes (+4/-0)

Stefan Behrens (7) commits (+985/-174):
    Btrfs: read device stats on mount, write modified ones during commit (+232/-0)
    Btrfs: add device counters for detected IO and checksum errors (+230/-24)
    Btrfs: fix runtime warning in check-integrity check data mode (+22/-3)
    Btrfs: change integrity checker to support big blocks (+415/-146)
    Btrfs: fix false positive in check-integrity on unmount (+1/-1)
    Btrfs: add ioctl to get and reset the device stats (+77/-0)
    Btrfs: set ioprio of scrub readahead to idle (+8/-0)

Wang Sheng-Hui (5) commits (+7/-8):
    Btrfs: remove the useless assignment to *entry in function tree_insert of file extent_io.c (+0/-1)
    Btrfs: fix btrfs_release_extent_buffer_page with the right usage of num_extent_pages (+3/-1)
    btrfs/ctree.c: remove the unnecessary 'return -1;' at the end of bin_search (+2/-4)
    Btrfs: cleanup the comment for clear_state_bit in extent_io.c (+1/-1)
    Btrfs: fix the comment for find_first_extent_bit (+1/-1)

Jim Meyering (3) commits (+32/-44):
    Btrfs: NUL-terminate path buffer in DEV_INFO ioctl result (+4/-2)
    Btrfs: avoid buffer overrun in mount option handling (+26/-41)
    Btrfs: avoid buffer overrun in btrfs_printk (+2/-1)

Liu Bo (3) commits (+28/-30):
    Btrfs: use fastpath in extent state ops as much as possible (+18/-26)
    Btrfs: fix wrong error returned by adding a device (+1/-1)
    Btrfs: do not do balance in readonly mode (+9/-3)

Sergei Trofimovich (1) commits (+40/-5):
    btrfs: allow changing 'thread_pool' size at remount time

Daniel J Blueman (1) commits (+5/-6):
    Fix minor type issues

Dan Carpenter (1) commits (+1/-1):
    Btrfs: cleanup: use consistent lock naming

Asias He (1) commits (+0/-14):
    btrfs: Drop unused function btrfs_abort_devices()

Miao Xie (1) commits (+39/-10):
    Btrfs: fix the same inode id problem when doing auto defragment

Tsutomu Itoh (1) commits (+18/-4):
    Btrfs: return value of btrfs_read_buffer is checked correctly

Total: (58) commits

 fs/btrfs/acl.c              |    4 +
 fs/btrfs/backref.c          |  495 +++++++++++++++++--------
 fs/btrfs/backref.h          |    3 +-
 fs/btrfs/btrfs_inode.h      |   50 ++-
 fs/btrfs/check-integrity.c  |  584 +++++++++++++++++++++--------
 fs/btrfs/ctree.c            |  861 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ctree.h            |   77 +++-
 fs/btrfs/delayed-inode.c    |    8 +-
 fs/btrfs/delayed-ref.c      |   10 +-
 fs/btrfs/delayed-ref.h      |   24 --
 fs/btrfs/disk-io.c          |   57 ++-
 fs/btrfs/disk-io.h          |    1 -
 fs/btrfs/extent-tree.c      |   23 +-
 fs/btrfs/extent_io.c        |  168 ++++++---
 fs/btrfs/extent_io.h        |    8 +-
 fs/btrfs/file.c             |   76 ++--
 fs/btrfs/free-space-cache.c |   45 ++-
 fs/btrfs/inode.c            |  264 +++++++------
 fs/btrfs/ioctl.c            |   50 ++-
 fs/btrfs/ioctl.h            |   33 ++
 fs/btrfs/ordered-data.c     |  165 ++++-----
 fs/btrfs/ordered-data.h     |   13 +-
 fs/btrfs/print-tree.c       |    3 +
 fs/btrfs/reada.c            |    5 +
 fs/btrfs/scrub.c            |   65 +++-
 fs/btrfs/super.c            |  117 +++---
 fs/btrfs/transaction.c      |   59 ++-
 fs/btrfs/tree-log.c         |   35 +-
 fs/btrfs/ulist.c            |   38 +-
 fs/btrfs/ulist.h            |   15 +-
 fs/btrfs/volumes.c          |  306 ++++++++++++++-
 fs/btrfs/volumes.h          |   52 +++
 fs/btrfs/xattr.c            |    1 +
 33 files changed, 2849 insertions(+), 866 deletions(-)
