Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45853 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbcE0HBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:01:23 -0400
Received: from pps.filterd (m0048827.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R6xXUw031405
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:22 -0400
Message-Id: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236bdbgbfy-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:22 -0400
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 12:31:19 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 69029125804F
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:33:30 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R71B4Q52166758
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:11 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R714st021181
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:09 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH 0/5] Btrfs: enable self-test on ppc64
Date: Fri, 27 May 2016 15:00:33 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Btrfs self-test module assumed that both sectorsize and PAGE_SIZE are 4K.
Thus many self-tests fail on non-4K page size systems, like ppc64. This
patchset enables self-tests to be executed on non-4k page size systems.

This patchset enables us to easily add support for possible sectorsizes and
nodesizes (e.g. for future subpage-blocksize support).

This patchset also fixes the following bugs:
 1) Fix integer overflow when calculating bytes_per_bitmap
 2) Fix infinite loop when searching for free space
 3) Fix extent buffer bitmap test fail on big-endian system

Feifei Xu (5):
  Btrfs: test_check_exists: Fix infinite loop when searching for free
    space entries
  Btrfs: Fix integer overflow when calculating bytes_per_bitmap
  Btrfs: self-tests: Support non-4k page size
  Btrfs: test_bitmaps: Fix failure on 64k sectorsize
  Btrfs: self-test: fix extent buffer bitmap test fail on BE system

 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |   9 +-
 fs/btrfs/disk-io.h                     |   3 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |  17 +-
 fs/btrfs/super.c                       |  62 ++++--
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
 fs/btrfs/tests/extent-io-tests.c       |  97 +++++----
 fs/btrfs/tests/free-space-tests.c      |  75 ++++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 379 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          | 111 ++++++----
 15 files changed, 489 insertions(+), 360 deletions(-)

-- 
2.7.4

