Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA07C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 071E42070D
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfDBSKA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 14:10:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbfDBSJ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 14:09:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3160AC86
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 18:09:58 +0000 (UTC)
Received: from starscream.home.jeffm.io (starscream-1.home.jeffm.io [192.168.1.254])
        by mail.home.jeffm.io (Postfix) with ESMTPS id A0EC2801432F;
        Tue,  2 Apr 2019 14:09:47 -0400 (EDT)
Received: by starscream.home.jeffm.io (Postfix, from userid 1000)
        id 5EC993E7FFA; Tue,  2 Apr 2019 14:09:57 -0400 (EDT)
From:   jeffm@suse.com
To:     linux-btrfs@vger.kernel.org
Cc:     Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/2] btrfs-progs: check: run delayed refs after writing out dirty block groups
Date:   Tue,  2 Apr 2019 14:09:55 -0400
Message-Id: <20190402180956.28893-1-jeffm@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

When repairing the extent tree, it's possible for delayed extents to
be created when running btrfs_write_dirty_block_groups.  We run
delayed refs one last time in the kernel but that is missing in
the userspace tools.

That results in delayed refs getting dropped on the floor, the extent
records not getting created, and in the next tranaction, when the
extent tree is CoW'd again, we hit the BUG_ON when we can't find
the extent record.

We can fix this by running the delayed refs after writing out the
dirty block groups.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/transaction.c b/transaction.c
index e756db33..2f19e9c8 100644
--- a/transaction.c
+++ b/transaction.c
@@ -194,6 +194,8 @@ commit_tree:
 	ret = btrfs_run_delayed_refs(trans, -1);
 	BUG_ON(ret);
 	btrfs_write_dirty_block_groups(trans);
+	ret = btrfs_run_delayed_refs(trans, -1);
+	BUG_ON(ret);
 	__commit_transaction(trans, root);
 	if (ret < 0)
 		goto out;
-- 
2.16.4

