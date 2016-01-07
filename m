Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751924AbcAGBIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:36 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 26A6D4092578
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:19 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 00/14][For 4.6] Btrfs: Add inband (write time) de-duplication framework
Date: Thu, 7 Jan 2016 09:08:01 +0800
Message-ID: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updated version of inband de-duplication has the following features:
1) ONE unified dedup framework.
   Most of its code is hidden quietly in dedup.c and export the minimal
   interfaces for its caller.
   Reviewer and further developer would benefit from the unified
   framework.

2) TWO different back-end with different trade-off
   One is the improved version of previous Fujitsu in-memory only dedup.
   The other one is enhanced dedup implementation from Liu Bo.
   Changed its tree structure to handle bytenr -> hash search for
   deleting hash, without the hideous data backref hack.

3) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.
   Further we will add per-file/dir dedup disable command in that ioctl.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

TODO:
1) Per-file ioctl to disbale dedup
   Just like compression setting per file

2) Support compression for hash miss case
   It will go though non-compress routine, not compressing it even we can.
   This may need to change the on-disk format for on-disk backend.

3) Make codes more elegant
   A lot of place is quite ugly, espcially when it comes to delayed_ref
   related part.
   Like btrfs_dedup_add() and btrfs_dedup_del().
   We may need to rework delayed_ref to a more simple and straightforward
   implementation.

Changelog:
v2:
  Totally reworked to handle multiple backends
v3:
  Fix a stupid but deadly on-disk backend bug
  Add handle for multiple hash on same bytenr corner case to fix abort
  trans error
  Increase dedup rate by enhancing delayed ref handler for both backend.
  Move dedup_add() to run_delayed_ref() time, to fix abort trans error.
  Increase dedup block size up limit to 8M.

Qu Wenruo (7):
  btrfs: delayed-ref: Add support for atomic increasing extent ref
  btrfs: delayed_ref: Add support for handle dedup hash
  btrfs: dedup: Add basic tree structure for on-disk dedup method
  btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
  btrfs: dedup: Add support for on-disk hash search
  btrfs: dedup: Add support to delete hash for on-disk backend
  btrfs: dedup: Add support for adding hash for on-disk backend

Wang Xiaoguang (9):
  btrfs: dedup: Introduce dedup framework and its header
  btrfs: dedup: Introduce function to initialize dedup info
  btrfs: dedup: Introduce function to add hash into in-memory tree
  btrfs: dedup: Introduce function to remove hash from in-memory tree
  btrfs: dedup: Introduce function to search for an existing hash
  btrfs: dedup: Implement btrfs_dedup_calc_hash interface
  btrfs: ordered-extent: Add support for dedup
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add ioctl for inband deduplication

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   79 +++-
 fs/btrfs/dedup.c             | 1053 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             |  155 +++++++
 fs/btrfs/delayed-ref.c       |   26 +-
 fs/btrfs/delayed-ref.h       |    9 +-
 fs/btrfs/disk-io.c           |   28 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   39 +-
 fs/btrfs/extent_io.c         |   30 +-
 fs/btrfs/extent_io.h         |   15 +
 fs/btrfs/inode.c             |  305 +++++++++++-
 fs/btrfs/ioctl.c             |   63 +++
 fs/btrfs/ordered-data.c      |   33 +-
 fs/btrfs/ordered-data.h      |   13 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   23 +
 17 files changed, 1829 insertions(+), 48 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.6.4



