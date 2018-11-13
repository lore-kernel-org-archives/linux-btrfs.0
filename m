Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC42C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 07:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E892245E
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 07:05:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1E892245E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbeKMRCE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 12:02:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbeKMRCE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 12:02:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BCF3FB608
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 07:05:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Remove duplicated trace points for qgroup_rsv_add/release()
Date:   Tue, 13 Nov 2018 15:05:08 +0800
Message-Id: <20181113070508.3463-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Inside qgroup_rsv_add/release(), we have trace events
trace_qgroup_update_reserve() to catch reserved space update.

However we still have two manual trace_qgroup_update_reserve() calls
just outside these functions.

Remove these duplicated calls.

Fixes: 64ee4e751a1c ("btrfs: qgroup: Update trace events to use new separate rsv types")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 45868fd76209..c1fbd8a30fc4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2952,7 +2952,6 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		trace_qgroup_update_reserve(fs_info, qg, num_bytes, type);
 		qgroup_rsv_add(fs_info, qg, num_bytes, type);
 	}
 
@@ -3019,7 +3018,6 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		trace_qgroup_update_reserve(fs_info, qg, -(s64)num_bytes, type);
 		qgroup_rsv_release(fs_info, qg, num_bytes, type);
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-- 
2.19.1

