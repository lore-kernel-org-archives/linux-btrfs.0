Return-Path: <SRS0=BA/r=WC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FF5C31E40
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 08:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D356B2070D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Aug 2019 08:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfHFIWI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:22:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:53194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731735AbfHFIWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Aug 2019 04:22:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0036CAF1D
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2019 08:22:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: transaction: Commit transaction more frequently for BPF
Date:   Tue,  6 Aug 2019 16:22:01 +0800
Message-Id: <20190806082201.22683-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs has btrfs_end_transaction_throttle() which could try to commit
transaction when needed.

However under most cases btrfs_end_transaction_throttle() won't really
commit transaction, due to the hard timing requirement.

Now introduce a new error injection point, btrfs_need_trans_pressure(),
to allow btrfs_should_end_transaction() to return 1 and
btrfs_end_transaction_throttle() to fallback to
btrfs_commit_transaction().

With such more aggressive transaction commit, we can dig deeper into
cases like snapshot drop.
Now each reference drop of btrfs_drop_snapshot() will lead to a
transaction commit, allowing dm-logwrites to catch more details, other
than one big transaction dropping everything.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/transaction.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248d535bb14d..2e758957126e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -10,6 +10,7 @@
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
 #include <linux/uuid.h>
+#include <linux/error-injection.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -781,10 +782,18 @@ void btrfs_throttle(struct btrfs_fs_info *fs_info)
 	wait_current_trans(fs_info);
 }
 
+static noinline bool btrfs_need_trans_pressure(struct btrfs_trans_handle *trans)
+{
+	return false;
+}
+ALLOW_ERROR_INJECTION(btrfs_need_trans_pressure, TRUE);
+
 static int should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
+	if (btrfs_need_trans_pressure(trans))
+		return 1;
 	if (btrfs_check_space_for_delayed_refs(fs_info))
 		return 1;
 
@@ -845,6 +854,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_chunk_metadata(trans);
 
+	if (throttle && btrfs_need_trans_pressure(trans))
+		return btrfs_commit_transaction(trans);
 	if (lock && READ_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
 		if (throttle)
 			return btrfs_commit_transaction(trans);
-- 
2.22.0

