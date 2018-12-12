Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD968C6783B
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A5B020849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 00:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A5B020849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbeLLAkB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 19:40:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:57814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbeLLAkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 19:40:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6C4AAD88
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 00:39:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce overhead
Date:   Wed, 12 Dec 2018 08:39:46 +0800
Message-Id: <20181212003953.5643-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_delayed_subtree

Which is based on v4.20-rc1.

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

                     | v4.20-rc1            | w/ patchset    | diff
-----------------------------------------------------------------------
relocated extents    | 22615                | 22457          | -0.1%
qgroup dirty extents | 163457               | 121606         | -25.6%
time (sys)           | 22.884s              | 18.842s        | -17.6%
time (real)          | 27.724s              | 22.884s        | -17.5%

changelog:
v2:
- Rebase to v4.20-rc1.
- Instead commit transaction after each reloc tree merge, delay it until
  merge_reloc_roots() finishes.
- This provides a more natural behavior, and reduce the unnecessary
  transaction commits.
v3:
- Fix backref walk deadlock by not triggering it at all.
  This also removes the need for @exec_post refactor and replace the
  patch to allow @old_root unpopulated.
- Include the patch that fixes the unexpected data rsv free.

Qu Wenruo (7):
  btrfs: qgroup: Move reserved data account from btrfs_delayed_ref_head
    to btrfs_qgroup_extent_record
  btrfs: qgroup: Don't trigger backref walk at delayed ref insert time
  btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()
  btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
  btrfs: qgroup: Introduce per-root swapped blocks infrastructure
  btrfs: qgroup: Use delayed subtree rescan for balance
  btrfs: qgroup: Cleanup old subtree swap code

 fs/btrfs/ctree.c             |   8 +
 fs/btrfs/ctree.h             |  14 ++
 fs/btrfs/delayed-ref.c       |  39 +---
 fs/btrfs/delayed-ref.h       |  11 --
 fs/btrfs/disk-io.c           |   1 +
 fs/btrfs/extent-tree.c       |   3 -
 fs/btrfs/qgroup.c            | 355 ++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.h            | 157 +++++++++++-----
 fs/btrfs/relocation.c        | 140 +++++++++++---
 fs/btrfs/transaction.c       |   1 +
 include/trace/events/btrfs.h |  29 ---
 11 files changed, 509 insertions(+), 249 deletions(-)

-- 
2.19.2

