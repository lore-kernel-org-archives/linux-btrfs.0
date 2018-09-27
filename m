Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEDEC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7AFC2156D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7AFC2156D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeI0M7U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:38006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726659AbeI0M7U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B8CAB124
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:39 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/7] btrfs: qgroup: Reduce dirty extents for metadata
Date:   Thu, 27 Sep 2018 14:42:28 +0800
Message-Id: <20180927064235.7432-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
The base commit is v4.19-rc1 tag.

There are a lot of reports of system hang for balance on quota enabled
fs.
It's most obvious for large fs.

The hang is caused by tons of unmodified extents marked as qgroup dirty.
Such unmodified/unrelated sources include:
1) Unmodified subtree
2) Subtree drop for reloc tree
(BTW, other sources includes unmodified file extent items)

E.g.
OO = Old tree blocks from file tree
NN = New tree blocks from reloc tree

        file tree                              reloc tree
           OO (a)                                  NN (a)
          /  \                                    /  \
    (b) OO    OO (c)                        (b) NN    NN (c)
       / \   / \                               / \   / \
     OO  OO OO  OO                           OO  OO OO  NN
    (d) (e) (f) (g)                         (d) (e) (f) (g)

In above case, balance will modify nodeptr in OO(a) to point NN(b) and
NN(c), and modify NN(a) to point to OO(B) and OO(c).

Before this patch, quota will mark the whole subtree from its parent
down to the leaves as dirty.
So btrfs quota need to trace all tree block from (a) to (g).

However tree blocks (d) (e) (f) are shared between both trees, thus
there is no need to trace those 3 tree blocks.

This patchset will change how this work by only tracing modified tree
blocks in reloc tree, and their counter parts in file tree.

With this patch, we could skip tree blocks OO(d)~OO(f) in above example,
thus reduce some some overhead caused by qgroup.

The improvement is mostly related to metadata relocation.

Also, for metadata relocation, we don't really need to trace data
extents as they're not modified at all.


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

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22874        | 22856          | +0.1%
qgroup dirty extents | 225251       | 140431         | -37.7%
time (sys)           | 40.161s      | 20.574s        | -48.7%
time (real)          | 42.163s      | 25.173s        | -40.3%

*: (val_new - val_old) / val_old * 100%

And the difference is becoming more and more obvious if more snapshots
are created.

If we increase the number of snapshots to 64 (4 times the number of
references, and 64 snapshots is already not recommended to use with
quota)

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22462        | 22467          | +0.0%
qgroup dirty extents | 314380       | 140826         | -55.2%
time (sys)           | 158.033s     | 74.292s        | -53.0%
time (real)          | 197.395s     | 90.529s        | -67.6%

For larger fs the saving should be even more obvious.

Changelog:
v2:
  Rename "tree reloc tree" to "reloc tree".
  Add patch "Don't trace subtree if we're dropping reloc tree" into the
  patchset.
  Fix wrong btrfs_bin_search() call, which leads to unexpected ENOENT
  error for btrfs_qgroup_trace_extent_swap(). Now use dst_path->slots[]
  directly.
  
v3:
  Add new patch to avoid unnecessary data extents trace for metadata
  relocation.
  Better delayed ref time root owner detection to avoid unnecessary tree
  block tracing.
  Add benchmark result for the patchset.

v4:
  Move part of the benchmark result from cover letter to real patches.
  - The result is *NEW* result, since host kernel get several updates.
    Spectre fixes seem to degrade a little memory performance.
  - Per-patch performance change on total balance time, compared to
    *previous* patch:
    4th -5%
    5th -25%
    6th -15%
    7th 0% 
  - Cover letter still uses old test result.
  - In patch commit message, the result is still compared to v4.19-rc1

  Add more robust level check for qgroup_trace_new_subtree_blocks().

  Make btrfs_qgroup_trace_subtree_swap() to report wrong parameter
  order at runtime. (Since there is only one caller, report at runtime
  should be enough to cover development time error).

  Move the comment for btrfs_qgroup_trace_subtree_swap() to qgroup.c.
  (Other comment cleanup will be sent as a separate patch)

  Fix one uncaught "tree reloc tree" naming.

  Remove unrelated changes in patch 6.
  

Qu Wenruo (7):
  btrfs: qgroup: Introduce trace event to analyse the number of dirty
    extents accounted
  btrfs: qgroup: Introduce function to trace two swaped extents
  btrfs: qgroup: Introduce function to find all new tree blocks of reloc
    tree
  btrfs: qgroup: Use generation aware subtree swap to mark dirty extents
  btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
  btrfs: delayed-ref: Introduce new parameter for
    btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
  btrfs: qgroup: Only trace data extents in leaves if we're relocating
    data block group

 fs/btrfs/delayed-ref.c       |   3 +-
 fs/btrfs/delayed-ref.h       |   1 +
 fs/btrfs/extent-tree.c       |  16 +-
 fs/btrfs/qgroup.c            | 377 +++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h            |   6 +
 fs/btrfs/relocation.c        |  15 +-
 include/trace/events/btrfs.h |  21 ++
 7 files changed, 423 insertions(+), 16 deletions(-)

-- 
2.19.0

