Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CEFC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E2321019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfAWHPY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:15:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:47290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbfAWHPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 02:15:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9BE11B055
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 07:15:22 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce overhead
Date:   Wed, 23 Jan 2019 15:15:11 +0800
Message-Id: <20190123071518.2528-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_delayed_subtree

Which is based on v5.0-rc1.

This patch address the heavy load subtree scan, but delaying it until
we're going to modify the swapped tree block.

The overall workflow is:

1) Record the subtree root block get swapped.

   During subtree swap:
   O = Old tree blocks
   N = New tree blocks
         reloc tree                         subvol tree X
            Root                               Root
           /    \                             /    \
         NA     OB                          OA      OB
       /  |     |  \                      /  |      |  \
     NC  ND     OE  OF                   OC  OD     OE  OF

  In these case, NA and OA is going to be swapped, record (NA, OA) into
  subvol tree X.

2) After subtree swap.
         reloc tree                         subvol tree X
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

    Then no matter what we do to subvol tree X, qgroup numbers will
    still be correct.
    Then NA's record get removed from X's swapped_blocks.

4)  Transaction commit
    Any record in X's swapped_blocks get removed, since there is no
    modification to swapped subtrees, no need to trigger heavy qgroup
    subtree rescan for them.

[[Benchmark]] (*)
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

*: Due to a bug in v5.0-rc1, balancing metadata with snapshots is
unacceptably slow even with quota disabled. So the result is from
v4.20-rc1.

changelog:
v2:
- Rebase to v4.20-rc1.

- Instead commit transaction after each reloc tree merge, delay it until
  merge_reloc_roots() finishes.
  This provides a more natural behavior, and reduce the unnecessary
  transaction commits.

v3:
- Fix backref walk deadlock by not triggering it at all.
  This also removes the need for @exec_post refactor and replace the
  patch to allow @old_root unpopulated.

- Include the patch that fixes the unexpected data rsv free.

v3.1:
- Rebased to v4.20-rc1.
  Minor conflicts with some cleanup code.

v4:
- Renaming members from "file_*" to "subv_*".
  Members like "file_bytenr" is pretty confusing, renaming it to
  "subv_bytenr" avoid the confusion.

- Use btrfs_root::reloc_dirty_list to replace dynamic memory allocation
  One less point of failure, and no need to worry about GFP_KERNEL/NOFS.
  Furthermore, it's easier to manipulate list than rb tree.

v5:
- Use Josef's superior qgroup deadlock fix.
  No performance regression now.

- A new patch to allow delayed subtree rescan to insert empty old_roots.

- Fix a possible race due to wrong rb_tree node initialization out of
  critical section.

- A lot of coding style fixes:
  * naming change from "file"/"subv" to "subvol"
  * {} for any else if branch
  * avoid err/ret confusion by introducing "tmp_ret"
  * proper errno for non-uptodate extent buffer
  * struct member re-ordering to avoid unnecessary padding
  * avoid single letter variable name
  * less redundant emphasizing
  * move certain devel-only warning under CONFIG_BTRFS_DEBUG
  * replace cool-sounding 'hack' with 'optimization'
  * remove unnecessary inline prefix for btrfs_qgroup_init_swapped_blocks
  * keep an empty line before #endif


Josef Bacik (1):
  btrfs: honor path->skip_locking in backref code

Qu Wenruo (6):
  btrfs: qgroup: Move reserved data account from btrfs_delayed_ref_head
    to btrfs_qgroup_extent_record
  btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()
  btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
  btrfs: qgroup: Introduce per-root swapped blocks infrastructure
  btrfs: qgroup: Use delayed subtree rescan for balance
  btrfs: qgroup: Cleanup old subtree swap code

 fs/btrfs/backref.c           |  16 +-
 fs/btrfs/ctree.c             |   8 +
 fs/btrfs/ctree.h             |  29 +++
 fs/btrfs/delayed-ref.c       |  15 +-
 fs/btrfs/delayed-ref.h       |  11 --
 fs/btrfs/disk-io.c           |   2 +
 fs/btrfs/extent-tree.c       |   3 -
 fs/btrfs/qgroup.c            | 339 +++++++++++++++++++++++++++--------
 fs/btrfs/qgroup.h            | 120 +++++++++++--
 fs/btrfs/relocation.c        | 101 ++++++++---
 fs/btrfs/transaction.c       |   1 +
 include/trace/events/btrfs.h |  29 ---
 12 files changed, 502 insertions(+), 172 deletions(-)

-- 
2.20.1

