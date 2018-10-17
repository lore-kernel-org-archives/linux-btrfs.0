Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C00ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 06:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 961B6214C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 06:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 961B6214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbeJQOu1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 10:50:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:58354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727182AbeJQOu1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 10:50:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 438FDACD2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 06:56:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/4] btrfs: Refactor find_free_extent()
Date:   Wed, 17 Oct 2018 14:56:02 +0800
Message-Id: <20181017065606.8707-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Can be fetched from github:
https://github.com/adam900710/linux/tree/refactor_find_free_extent

Which is based on v4.19-rc1.

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

Qu Wenruo (4):
  btrfs: Introduce find_free_extent_ctl structure for later rework
  btrfs: Refactor clustered extent allocation into
    find_free_extent_clustered()
  btrfs: Refactor unclustered extent allocation into
    find_free_extent_unclustered()
  btrfs: Refactor find_free_extent() loops update into
    find_free_extent_update_loop()

 fs/btrfs/extent-tree.c | 704 ++++++++++++++++++++++++-----------------
 1 file changed, 406 insertions(+), 298 deletions(-)

-- 
2.19.1

