Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2476EECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09892087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09892087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbeJRTSH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:18:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:42868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727496AbeJRTSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:18:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7FF52AD18
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:17:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
Date:   Thu, 18 Oct 2018 19:17:23 +0800
Message-Id: <20181018111729.11128-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees

Which is still based on v4.19-rc1, but with previous submitted patches
as dependency.

This patch address the heavy load subtree scan, but delaying it until
we're going to modify the swapped tree block.

The overall workflow is:

1) Record the subtree root block get swapped.

   During subtree swap:
   O = Old tree blocks
   N = New tree blocks
         reloc tree                         file tree X
            Root                               Root
           /    \                             /    \
         NA     OB                          OA      OB
       /  |     |  \                      /  |      |  \
     NC  ND     OE  OF                   OC  OD     OE  OF

  In these case, NA and OA is going to be swapped, record (NA, OA) into
  file tree X.

2) After subtree swap.
         reloc tree                         file tree X
            Root                               Root
           /    \                             /    \
         OA     OB                          NA      OB
       /  |     |  \                      /  |      |  \
     OC  OD     OE  OF                   NC  ND     OE  OF

3a) CoW happens for OB
    If we are going to CoW tree block OB, we check OB's bytenr against
    tree X's swapped_blocks structure.
    It doesn't fit any one, nothing will happen.

3b) CoW happens for NA
    Check NA's bytenr against tree X's swapped_blocks, and get a hit.
    Then we do subtree scan on both subtree OA and NA.
    Resulting 6 tree blocks to be scanned (OA, OC, OD, NA, NC, ND).

    Then no matter what we do to file tree X, qgroup numbers will
    still be correct.
    Then NA's record get removed from X's swapped_blocks.

4)  Transaction commit
    Any record in X's swapped_blocks get removed, since there is no
    modification to swapped subtrees, no need to trigger heavy qgroup
    subtree rescan for them.

[[Benchmark]]
Hardware:
	VM 4G vRAM, 8 vCPUs,
	disk is using 'unsafe' cache mode,
	backing device is SAMSUNG 850 evo SSD.
	Host has 16G ram.

Mkfs parameter:
	--nodesize 4K (To bump up tree size)

Initial subvolume contents:
	4G data copied from /usr and /lib.
	(With enough regular small files)

Snapshots:
	16 snapshots of the original subvolume.
	each snapshot has 3 random files modified.

balance parameter:
	-m

So the content should be pretty similar to a real world root fs layout.

And after file system population, there is no other activity, so it
should be the best case scenario.

                     | prev optimization(*) | w/ patchset    | diff
-----------------------------------------------------------------------
relocated extents    | 22958                | 22983          | +0.1%
qgroup dirty extents | 129282               | 54630          | -57.8%
time (sys)           | 37.807s              | 27.038s        | -28.5%
time (real)          | 45.446s              | 34.015s        | -25.2%

*: Previous submitted patch, titled
   "[PATCH v4 0/7] btrfs: qgroup: Reduce dirty extents for metadata".
   Still based on v4.19-rc1

Qu Wenruo (6):
  btrfs: qgroup: Allow btrfs_qgroup_extent_record::old_roots unpopulated
    at insert time
  btrfs: relocation: Commit transaction before dropping
    btrfs_root::reloc_root
  btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
  btrfs: qgroup: Introduce per-root swapped blocks infrastructure
  btrfs: qgroup: Use delayed subtree rescan for balance
  btrfs: qgroup: Cleanup old subtree swap code

 fs/btrfs/ctree.c       |   8 +
 fs/btrfs/ctree.h       |  13 ++
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/qgroup.c      | 368 +++++++++++++++++++++++++++++++----------
 fs/btrfs/qgroup.h      | 107 +++++++++++-
 fs/btrfs/relocation.c  |  26 ++-
 fs/btrfs/transaction.c |   1 +
 7 files changed, 424 insertions(+), 100 deletions(-)

-- 
2.19.1

