Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:44310 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 30.22 OK)
	with ESMTP id p03dd3oA6AspSU for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/26] Btrfs: Add device replace code
Date: Tue,  6 Nov 2012 17:38:18 +0100
Message-Id: <cover.1352214751.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series adds support for replacing disks at runtime.

It replaces the following steps in case a disk was lost:
    mount ... -o degraded
    btrfs device add new_disk
    btrfs device delete missing

Or in case a disk just needs to be replaced because the error rate
is increasing:
    btrfs device add new_disk
    btrfs device delete old_disk

Instead just run:
    btrfs replace mountpoint old_disk new_disk

The device replace operation takes place at runtime on a live
filesystem, you don't need to unmount it or stop active tasks.
It is safe to crash or lose power during the operation, the
process resumes with the next mount.

The copy usually takes place at 90% of the available platter
speed if no additional disk I/O is ongoing during the copy
operation, thus the degraded state without redundancy can be
left quickly.

The copy process is started manually. It is a different project
to react on an increased device I/O error rate with an automatic
start of this procedure.

The patch series is based on btrfs-next and also available here:
git://btrfs.giantdisaster.de/git/btrfs device-replace

The user mode part is the top commit of
git://btrfs.giantdisaster.de/git/btrfs-progs master


replace start [-Bfr] <path> <srcdev>|<devid> <targetdev>
       Replace device of a btrfs filesystem.   On  a  live  filesystem,
       duplicate  the  data  to  the  target  device which is currently
       stored on the source device. If the source device is not  avail-
       able anymore, or if the -r option is set, the data is built only
       using the RAID redundancy mechanisms. After  completion  of  the
       operation, the source device is removed from the filesystem.  If
       the srcdev is a numerical value, it is assumed to be the  device
       id  of the filesystem which is mounted at mount_point, otherwise
       is is the path to the source device. If  the  source  device  is
       disconnected, from the system, you have to use the devid parame-
       ter format.  The targetdev needs to be same size or larger  than
       the srcdev.

       Options

       -r     only  read  from  srcdev  if  no other zero-defect mirror
              exists (enable this  if  your  drive  has  lots  of  read
              errors, the access would be very slow)

       -f     force  using  and  overwriting targetdev even if it looks
              like  containing  a  valid  btrfs  filesystem.  A   valid
              filesystem  is  assumed  if  a  btrfs superblock is found
              which contains a correct checksum. Devices which are cur-
              rently  mounted  are never allowed to be used as the tar-
              getdev

       -B     do not background


replace status [-1] <path>
       Print status  and  progress  information  of  a  running  device
       replace operation.

       Options

       -1     print once instead of print continously until the replace
              operation finishes (or is canceled)


replace cancel <path>
       Cancel a running device replace operation.


Stefan Behrens (26):
  Btrfs: rename the scrub context structure
  Btrfs: remove the block device pointer from the scrub context struct
  Btrfs: make the scrub page array dynamically allocated
  Btrfs: in scrub repair code, optimize the reading of mirrors
  Btrfs: in scrub repair code, simplify alloc error handling
  Btrfs: cleanup scrub bio and worker wait code
  Btrfs: add two more find_device() methods
  Btrfs: Pass fs_info to btrfs_num_copies() instead of mapping_tree
  Btrfs: pass fs_info to btrfs_map_block() instead of mapping_tree
  Btrfs: add btrfs_scratch_superblock() function
  Btrfs: pass fs_info instead of root
  Btrfs: avoid risk of a deadlock in btrfs_handle_error
  Btrfs: enhance btrfs structures for device replace support
  Btrfs: introduce a btrfs_dev_replace_item type
  Btrfs: add a new source file with device replace code
  Btrfs: disallow mutually exclusiv admin operations from user mode
  Btrfs: disallow some operations on the device replace target device
  Btrfs: handle errors from btrfs_map_bio() everywhere
  Btrfs: add code to scrub to copy read data to another disk
  Btrfs: change core code of btrfs to support the device replace
    operations
  Btrfs: introduce GET_READ_MIRRORS functionality for btrfs_map_block()
  Btrfs: changes to live filesystem are also written to replacement
    disk
  Btrfs: optionally avoid reads from device replace source drive
  Btrfs: increase BTRFS_MAX_MIRRORS by one for dev replace
  Btrfs: allow repair code to include target disk when searching
    mirrors
  Btrfs: add support for device replace ioctls

 fs/btrfs/Makefile          |    2 +-
 fs/btrfs/check-integrity.c |   29 +-
 fs/btrfs/compression.c     |    6 +-
 fs/btrfs/ctree.h           |  127 ++-
 fs/btrfs/dev-replace.c     |  843 ++++++++++++++++++++
 fs/btrfs/dev-replace.h     |   44 ++
 fs/btrfs/disk-io.c         |   79 +-
 fs/btrfs/extent-tree.c     |    5 +-
 fs/btrfs/extent_io.c       |   28 +-
 fs/btrfs/extent_io.h       |    4 +-
 fs/btrfs/inode.c           |   39 +-
 fs/btrfs/ioctl.c           |  117 ++-
 fs/btrfs/ioctl.h           |   45 ++
 fs/btrfs/print-tree.c      |    3 +
 fs/btrfs/reada.c           |   31 +-
 fs/btrfs/scrub.c           | 1822 ++++++++++++++++++++++++++++++++------------
 fs/btrfs/super.c           |   30 +-
 fs/btrfs/transaction.c     |    7 +-
 fs/btrfs/volumes.c         |  624 +++++++++++++--
 fs/btrfs/volumes.h         |   26 +-
 20 files changed, 3244 insertions(+), 667 deletions(-)
 create mode 100644 fs/btrfs/dev-replace.c
 create mode 100644 fs/btrfs/dev-replace.h

-- 
1.8.0

