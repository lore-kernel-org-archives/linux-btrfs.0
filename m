From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [GIT PULL] Btrfs patches for scrub, backref walking and raid repair
Date: Thu,  4 Aug 2011 19:51:09 +0200
Message-ID: <cover.1312478019.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

as you requested, you can pull my latest patches from

git://git.jan-o-sch.net/btrfs-unstable

You'll find three branches to choose from: "scrub", containing the backref
walking code and patches to fixup nodatasum errors. They have been sent to the
mailing list lately as "[PATCH v8 0/8] Btrfs scrub: print path to corrupted
files and trigger nodatasum fixup".

Next, there is a "raid1-repair" branch, adding code to write back good data as
we get it to failed disks in a raid setup. This was sent to the list as
"[RFC PATCH 0/4] btrfs: Suggestion for raid auto-repair" earlier. I added a
missing unlock (pointed out by Ian Kent), which should be the only difference
from the previous patch set.

Andi Kleen has looked over the raid1-repair series and suggested adding some
threshold to avoid flooding the console with errors from the repair attempts,
in case the drive is really bad. This is definitely important, but we can also
add them later (that's my opinion, at least). I'm planning to do more tests with
sata fault injectors. I should get some within the next days, hopefully. I'd
like to see the impact of flooding, which will make it easier to come with a
good solution for it.

The combination of both branches mentioned is the for-chris branch. It has the
scrub patches first, followed by the raid1-repair patches as contained in the
separate branches. The last commit in this branch is an integration commit,
improving nodatasum fixup for a corner case (detailed description is in the
commit message).
   
Thanks,
-Jan

Jan Schmidt (13):
  btrfs: added helper functions to iterate backrefs
  btrfs scrub: added unverified_errors
  btrfs scrub: print paths of corrupted files
  btrfs scrub: bugfix: mirror_num off by one
  btrfs: add mirror_num to extent_read_full_page
  btrfs scrub: use int for mirror_num, not u64
  btrfs scrub: add fixup code for errors on nodatasum files
  btrfs: new ioctls to do logical->inode and inode->path resolving
  btrfs: btrfs_multi_bio replaced with btrfs_bio
  btrfs: Do not use bio->bi_bdev after submission
  btrfs: Put mirror_num in bi_bdev
  btrfs: Moved repair code from inode.c to extent_io.c
  btrfs: integrating raid-repair and scrub-fixup-nodatasum

 fs/btrfs/Makefile      |    3 +-
 fs/btrfs/backref.c     |  764 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/backref.h     |   62 ++++
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |   10 +-
 fs/btrfs/extent_io.c   |  393 ++++++++++++++++++++++++-
 fs/btrfs/extent_io.h   |   13 +-
 fs/btrfs/inode.c       |  157 +----------
 fs/btrfs/ioctl.c       |  143 +++++++++
 fs/btrfs/ioctl.h       |   30 ++
 fs/btrfs/scrub.c       |  476 +++++++++++++++++++++++++++---
 fs/btrfs/volumes.c     |  130 +++++----
 fs/btrfs/volumes.h     |   10 +-
 13 files changed, 1916 insertions(+), 277 deletions(-)
 create mode 100644 fs/btrfs/backref.c
 create mode 100644 fs/btrfs/backref.h

-- 
1.7.3.4

