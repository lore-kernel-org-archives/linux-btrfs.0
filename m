Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF967C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A752D20872
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfCRPpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:45:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:44274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726808AbfCRPpY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 11:45:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B83D2AED4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 15:45:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Couple of coverity fixes
Date:   Mon, 18 Mar 2019 17:45:17 +0200
Message-Id: <20190318154520.4086-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are 3 patches based on the latest coverity defect scans. Mostly minor, 
quality-of-life type of fixes. One redundant assignment removal, 1 bounds 
checking in qgroup and 1 possible overflow in qgroups please merge.  

Nikolay Borisov (3):
  btrfs: Remove unused -EIO assignment in end_bio_extent_readpage
  btrfs: Fix bound checking in qgroup_trace_new_subtree_blocks
  btrfs: Avoid possible qgroup_rsv_size overflow in
    btrfs_calculate_inode_block_rsv_size

 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/extent_io.c   | 2 --
 fs/btrfs/qgroup.c      | 6 +++---
 3 files changed, 4 insertions(+), 6 deletions(-)

-- 
2.17.1

