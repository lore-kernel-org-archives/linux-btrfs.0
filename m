Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54699 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965616AbeFOLGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:11 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/6] Freespace tree repair support
Date: Fri, 15 Jun 2018 14:05:56 +0300
Message-Id: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

This patchset adds support to btrfs check to repair corrupted freespace tree. 
Once this has been merged then we can start thinking of making the freespace
tree the default freespace cache and deprecate the existing v1 cache in new 
filesystems. 

This series depend on the already sent delayed refs. In order to facilitate 
testing the 2 series have been integrated and posted at :

   https://github.com/lorddoskias/btrfs-progs.git dev/delayed-refs-fst

The main thing with this code is that the repair will always regenerate the 
FST with extents since it I haven't ported the code which deals with 
detecting that bitmaps are more space efficient. This is not a big deal since 
the kernel will do it.

The first patch is here for completeness' sake and was only used in a previous 
incarnation of this code but since I've re-worked the way the code is supposed 
to work it can be dropped. I don't have strong opinions either way. It just 
teaches btrfs_read_fs_root to return the freespace root

Patch 2 adds some low-level bit manipulation primitives which are necessary to 
support bitmap based FST. My initial idea was to completely ommit the bitmap 
support but in testing it turned out to be less pain to just include it from 
the get-go. Otherwise the filesystem created in the test case in patch 6 
couldn't be worked on. 

Patch 3 is mostly copy/paste from the kernel code bringin in necessary 
functions to repair the freespace tree. I've only omitted locking code since 
in userspace we are always single-threaded, also there is no support currently 
when regenerating FST to convert it to bitmap.

Patch 4 updates the compat_ro bitmask to allow reading an FST filesystem in 
repair mode.

Patch 5 adds the core code which utilizes everything added up until this point. 
It's not that big and should be fairly easy to review. 

Patch 6 is a test-case which creates a filesystem with FST enabled, populates it 
with some files and then corrupts a bitmap and an extent records and tries to 
repair them. It's passing for me. 


Nikolay Borisov (6):
  btrfs-progs: Add support for freespace tree in btrfs_read_fs_root
  btrfs-progs: Add extent buffer bitmap manipulation infrastructure
  btrfs-progs: Pull free space tree related code from kernel
  btrfs-progs: Add freespace tree as compat_ro supported feature
  btrfs-progs: check: Add support for freespace tree fixing
  btrfs-progs: tests: Test for FST corruption detection/repair

 check/main.c                                      |  61 +-
 ctree.c                                           |  77 ++
 ctree.h                                           |   8 +-
 disk-io.c                                         |   3 +
 extent-tree.c                                     |   9 +
 extent_io.c                                       |  39 +
 extent_io.h                                       |  15 +
 free-space-tree.c                                 | 893 +++++++++++++++++++++-
 free-space-tree.h                                 |  10 +-
 tests/fsck-tests/035-freespacetree-repair/test.sh |  79 ++
 10 files changed, 1163 insertions(+), 31 deletions(-)
 create mode 100755 tests/fsck-tests/035-freespacetree-repair/test.sh

-- 
2.7.4

