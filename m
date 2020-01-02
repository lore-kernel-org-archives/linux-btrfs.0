Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6777EC2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 11:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ACFA21655
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 11:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgABL1x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 06:27:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:42506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgABL1x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 06:27:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 873B3AB7F
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Jan 2020 11:27:51 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] Introduce per-profile available space array to avoid over-confident can_overcommit()
Date:   Thu,  2 Jan 2020 19:27:42 +0800
Message-Id: <20200102112746.145045-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are several bug reports of ENOSPC error in
btrfs_run_delalloc_range().

With some extra info from one reporter, it turns out that
can_overcommit() is using a wrong way to calculate allocatable metadata
space.

The most typical case would look like:
  devid 1 unallocated:	1G
  devid 2 unallocated:  10G
  metadata profile:	RAID1

In above case, we can at most allocate 1G chunk for metadata, due to
unbalanced disk free space.
But current can_overcommit() uses factor based calculation, which never
consider the disk free space balance.


To address this problem, here comes the per-profile available space
array, which gets updated every time a chunk get allocated/removed or a
device get grown or shrunk.

This provides a quick way for hotter place like can_overcommit() to grab
an estimation on how many bytes it can over-commit.

The per-profile available space calculation tries to keep the behavior
of chunk allocator, thus it can handle uneven disks pretty well.

Although per-profile is not clever enough to handle estimation when both
data and metadata chunks need to be considered, its virtual chunk
infrastructure is flex enough to handle such case.

So for statfs(), we also re-use virtual chunk allocator to handle
available data space, with metadata over-commit space considered.
This brings an unexpected advantage, now we can handle RAID5/6 pretty OK
in statfs().

Changelog:
v1:
- Fix a bug where we forgot to update per-profile array after allocating
  a chunk.
  To avoid ABBA deadlock, this introduce a small windows at the end
  __btrfs_alloc_chunk(), it's not elegant but should be good enough
  before we rework chunk and device list mutex.
  
- Make statfs() to use virtual chunk allocator to do better estimation
  Now statfs() can report not only more accurate result, but can also
  handle RAID5/6 better.

v2:
- Fix a deadlock caused by acquiring device_list_mutex under
  __btrfs_alloc_chunk()
  There is no need to acquire device_list_mutex when holding
  chunk_mutex.
  Fix it and remove the lockdep assert.

Qu Wenruo (4):
  btrfs: Introduce per-profile available space facility
  btrfs: Update per-profile available space when device size/used space
    get updated
  btrfs: space-info: Use per-profile available space in can_overcommit()
  btrfs: statfs: Use virtual chunk allocation to calculation available
    data space

 fs/btrfs/space-info.c |  15 ++-
 fs/btrfs/super.c      | 190 +++++++++++++-----------------------
 fs/btrfs/volumes.c    | 218 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.h    |  14 +++
 4 files changed, 288 insertions(+), 149 deletions(-)

-- 
2.24.1

