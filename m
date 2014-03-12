Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58973 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaCLOVD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 10:21:03 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Mar 2014 19:51:01 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id D614A3940048
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:50:59 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2CEKr8461276248
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:50:53 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2CEKxP2008462
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 19:50:59 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
Date: Wed, 12 Mar 2014 19:50:27 +0530
Message-Id: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset describes a possible solution to solve whole page I/O issue
present in Btrfs. Currently whole page I/O is being performed because
bio_vec->[bv_len, bv_offset] can be modified by the Block I/O layer and hence
cannot be used by Btrfs's endio functions to operate on the original file
offset range that the bio was intended for. 

This patch is a precursor to get subpagesize-blocksize Btrfs feature to work
correctly as it would be required to do non-whole page I/O.

The patchset makes use of patches posted earlier by Chandra Seetharaman
(http://article.gmane.org/gmane.comp.file-systems.btrfs/30737). I believe that
getting non whole page I/O to work properly is the first issue to tackle
before working on the review comments posted for Chandra's patches. Please
correct me if my assumption is incorrect.

The patchset has been tested with only a handful of trivial I/O tests i.e. I/O
on different kinds of files (e.g. files with holes, etc). The tests were run
on 2k and 4k blocksized instances of Btrfs code (on x86_64) that has initial
support for mounting a 2k blocksized Btrfs filesystem. The corresponding git
trees can be found at
https://github.com/chandanr/btrfs-progs/tree/subpagesize-blocksize and
https://github.com/chandanr/linux/tree/btrfs/subpagesize-blocksize

The modified code is limited in feature i.e. the following are its known
limitations,
1. xfstests suite has not been executed.
2. Direct I/O has not been tested. 
3. Compression does not work with 2k blocksize filesystem instance.
4. fallocate does not work with 2k blocksize.
5. Data checksum does not work for 2k blocksize. Hence filesystem should be
   mounted by passing the nodatasum option.
6. Performance implications are unknown.

Chandan Rajendra (4):
  Btrfs: subpagesize-blocksize: Get rid of whole page reads.
  Btrfs: subpagesize-blocksize: Get rid of whole page writes.
  Btrfs: subpagesize-blocksize: Work with extents aligned to blocksize.
  Btrfs: subpagesize-blocksize: Hardcode MAX_EXTENT_BUFFERS_PER_PAGE to 2.

Chandra Seetharaman (2):
  Btrfs: subpagesize-blocksize: Define extent_buffer_head
  Btrfs: subpagesize-blocksize: Allow mounting filesystems where sectorsize != PAGE_SIZE

 fs/btrfs/backref.c           |   2 +-
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/disk-io.c           | 117 ++++----
 fs/btrfs/extent-tree.c       |   6 +-
 fs/btrfs/extent_io.c         | 623 ++++++++++++++++++++++++++++---------------
 fs/btrfs/extent_io.h         |  60 ++++-
 fs/btrfs/file.c              |  13 +-
 fs/btrfs/volumes.c           |   2 +-
 fs/btrfs/volumes.h           |   3 +
 include/trace/events/btrfs.h |   2 +-
 11 files changed, 554 insertions(+), 282 deletions(-)

-- 
1.8.3.1

