From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [RFC PATCH 0/4] btrfs: Suggestion for raid auto-repair
Date: Fri, 22 Jul 2011 16:58:04 +0200
Message-ID: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

This is my suggestion how to do on the fly repair for corrupted raid setups. 
Currently, btrfs can cope with a hardware failure in a way that it tries to
find another mirror and ... that's it. The bad mirror always stays bad and your
data is lost when the last copy vanishes.

Here is where I got on my way changing this. I built upon the retry code
originally used for data (inode.c), moved it to a more central place
(extent_io.c) and made it repair errors when possible. Those two steps are
currently inlcuded in patch 4, because what I actually did was somewhat more
iterative. If it helps reviewing, I can try to split that up in a move-commit
and a change-commit - just tell me you'd like this.

To test this, I made some bad sectors with hdparm (data and metadata) and had
them corrected while reading the affected data. Anyway, this patch touches
critical parts and can potentially screw up your data, in case i have an error
in determination of the destination for corrective writes. You have been warned!
But please, try it anyway :-)

One remark concerning scrub: My latest scrub patches include a change that
triggers a regular page read to correct some kind of errors. This code is meant
to end up exactly in the error correction routines added here, too.

There are some special cases (nodatasum and a certain state of page cache) where
scrub comes across an error that it reports as incorrectable, which it isn't. I
have a patch for that as well, but as it is only relevant when you combine those
two patch series, I did not include it.
 
-Jan

Jan Schmidt (4):
  btrfs: btrfs_multi_bio replaced with btrfs_bio
  btrfs: Do not use bio->bi_bdev after submission
  btrfs: Put mirror_num in bi_bdev
  btrfs: Moved repair code from inode.c to extent_io.c

 fs/btrfs/extent-tree.c |   10 +-
 fs/btrfs/extent_io.c   |  386 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h   |   11 ++-
 fs/btrfs/inode.c       |  155 +-------------------
 fs/btrfs/scrub.c       |   20 ++--
 fs/btrfs/volumes.c     |  130 +++++++++--------
 fs/btrfs/volumes.h     |   10 +-
 7 files changed, 485 insertions(+), 237 deletions(-)

-- 
1.7.3.4

