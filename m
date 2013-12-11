Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:51278 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3LKXkm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 18:40:42 -0500
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Wed, 11 Dec 2013 16:40:42 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A963A19D8042
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:33 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp07028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBBLcWXC8192374
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 22:38:32 +0100
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBBNeeXs029882
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 16:40:40 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
To: linux-btrfs@vger.kernel.org, chandra_pdx@yahoo.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/7] Patches to support subpagesize blocksize
Date: Wed, 11 Dec 2013 17:38:35 -0600
Message-Id: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs, blocksize, the basic IO size of the filesystem, has been
more than PAGE_SIZE.

But, some 64 bit architures, like PPC64 and ARM64 have the default
PAGE_SIZE as 64K, which means the filesystems handled in these
architectures are with a blocksize of 64K.

This works fine as long as you create and use the filesystems within
these systems.

In other words, one cannot create a filesystem in some other architecture
and use that filesystem in PPC64 or ARM64, and vice versa.,

Another restriction is that we cannot use ext? filesystems in these
architectures as btrfs filesystems, since ext? filesystems have a blocksize
of 4K.

Sometime last year, Wade Cline posted a patch(http://lwn.net/Articles/529682/).
I started testing it, and found many locking/race issues. So, I changed the
logic and created an extent_buffer_head that holds an array of extent buffers that
belong to a page.

There are few wrinkles in this patchset, like some xfstests are failing, which
could be due to me doing something incorrectly w.r.t how the blocksize and
PAGE_SIZE are used in these patched.

Would like to get some feedback, review comments.

Thanks,

Chandra

---

Chandra Seetharaman (7):
  btrfs: subpagesize-blocksize: Define extent_buffer_head
  btrfs: subpagesize-blocksize: Use a global alignment for size
  btrfs: subpagesize-blocksize: Handle small extent maps properly
  btrfs: subpagesize-blocksize: Handle iosize properly in submit_extent_page()
  btrfs: subpagesize-blocksize: handle checksum calculations properly
  btrfs: subpagesize-blocksize: Handle relocation clusters appropriately
  btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |   6 +-
 fs/btrfs/btrfs_inode.h       |   7 +
 fs/btrfs/compression.c       |   3 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           | 115 ++++++-----
 fs/btrfs/extent-tree.c       |  18 +-
 fs/btrfs/extent_io.c         | 449 ++++++++++++++++++++++++++-----------------
 fs/btrfs/extent_io.h         |  55 ++++--
 fs/btrfs/file-item.c         |  45 ++++-
 fs/btrfs/file.c              |  15 +-
 fs/btrfs/inode.c             |  75 +++++---
 fs/btrfs/ioctl.c             |   6 +-
 fs/btrfs/ordered-data.c      |   2 +-
 fs/btrfs/relocation.c        |   6 +-
 fs/btrfs/tree-log.c          |   2 +-
 fs/btrfs/volumes.c           |   2 +-
 include/trace/events/btrfs.h |   2 +-
 18 files changed, 515 insertions(+), 301 deletions(-)

-- 
1.7.12.4

