Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC4CC0044C
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BDF12081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BDF12081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbeKBKpR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 06:45:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:44452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbeKBKpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 06:45:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC695AD5D;
        Fri,  2 Nov 2018 01:39:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, josef@toxicpanda.com
Subject: [PATCH v5 0/4] btrfs: Refactor find_free_extent()
Date:   Fri,  2 Nov 2018 09:39:46 +0800
Message-Id: <20181102013950.30293-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Can be fetched from github:
https://github.com/adam900710/linux/tree/refactor_find_free_extent

Which is based on david's misc-4.20 branch.
The base head is:

commit 9084cb6a24bf5838a665af92ded1af8363f9e563 (david/misc-4.20)
Author: Filipe Manana <fdmanana@suse.com>
Date:   Mon Oct 22 10:43:06 2018 +0100

    Btrfs: fix use-after-free when dumping free space


extent-tree.c::find_free_extent() could be one of the most
ill-structured functions, it has at least 6 non-exit tags and jumps
between them.

Refactor it into 4 parts:

1) find_free_extent()
   The main entrance, does the main work of block group iteration and
   block group selection.
   Now this function doesn't care nor handles free extent search by
   itself.

2) find_free_extent_clustered()
   Do clustered free extent search.
   May try to build/re-fill cluster.

3) find_free_extent_unclustered()
   Do unclustered free extent search.
   May try to fill free space cache.

4) find_free_extent_update_loop()
   Do the loop based black magic.
   May allocate new chunk.

With this patch, at least we should make find_free_extent() a little
easier to read, and provides the basis for later work on this function.

Current refactor is trying not to touch the original functionality, thus
the helper structure find_free_extent_ctl still contains a lot of
unrelated members.
But it should not change how find_free_extent() works at all.

changelog:
v2:
  Split into 4 patches.
  Minor comment newline change.
v3:
  Mostly cosmetic update.
  Rebased to v4.19-rc1
  Rename find_free_extent_ctrl to find_free_extent_ctl to keep the
  naming scheme the same.
  Fix some comment spelling error.
  Enhance comment for find_free_extent_unclustered().
  Add reviewed-by tag.
v4:
  Move the (ins->objectid) check to proper location of the last patch,
  so all (!ins->objectid) branches are in the same code block.
  Add reviewed-by tags from Josef.
v5:
  Fix all warning reported by checkpatch.pl
  Rebase to misc-4.20.
  Solve conflicts with fb5c39d7a887 ("btrfs: don't use ctl->free_space for max_extent_size").
  This results:
  * New member find_free_extent_ctl::total_free_space
  * New comment for find_free_extent_ctl::total_free_space
  * New comment for falling back to total_free_space if we can't find
    valid find_free_extent_ctl::max_extent_size.

Qu Wenruo (4):
  btrfs: Introduce find_free_extent_ctl structure for later rework
  btrfs: Refactor clustered extent allocation into
    find_free_extent_clustered()
  btrfs: Refactor unclustered extent allocation into
    find_free_extent_unclustered()
  btrfs: Refactor find_free_extent() loops update into
    find_free_extent_update_loop()

 fs/btrfs/extent-tree.c | 715 ++++++++++++++++++++++++-----------------
 1 file changed, 414 insertions(+), 301 deletions(-)

-- 
2.19.1

