Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C786C10F00
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217A52070D
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfDBSKB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 14:10:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730017AbfDBSKA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 14:10:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4AEC8AC8C
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 18:09:59 +0000 (UTC)
Received: from starscream.home.jeffm.io (starscream-1.home.jeffm.io [IPv6:2001:559:c0d4::1fe])
        by mail.home.jeffm.io (Postfix) with ESMTPS id 6E18B81AD3D8;
        Tue,  2 Apr 2019 14:09:48 -0400 (EDT)
Received: by starscream.home.jeffm.io (Postfix, from userid 1000)
        id 438103E7FFC; Tue,  2 Apr 2019 14:09:58 -0400 (EDT)
From:   jeffm@suse.com
To:     linux-btrfs@vger.kernel.org
Cc:     Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/2] btrfs-progs: check: fixup_extent_flags needs to deal with non-skinny metadata
Date:   Tue,  2 Apr 2019 14:09:56 -0400
Message-Id: <20190402180956.28893-2-jeffm@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190402180956.28893-1-jeffm@suse.com>
References: <20190402180956.28893-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

When repairing a file system created by a very old kernel, I ran into
issues fixing up the extent flags since fixup_extent_flags assumed
that a METADATA_ITEM would be present if the record was for metadata.

Since METADATA_ITEMs don't exist without skinny metadata, we need to
fall back to EXTENT_ITEMs.  This also falls back to EXTENT_ITEMs even
with skinny metadata enabled as other parts of the tools do.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 check/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 7547209c..4a27a443 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7540,9 +7540,13 @@ static int fixup_extent_flags(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	u64 flags;
 	int ret = 0;
+	bool metadata_item = rec->metadata;
 
+	if (!btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
+		metadata_item = false;
+retry:
 	key.objectid = rec->start;
-	if (rec->metadata) {
+	if (metadata_item) {
 		key.type = BTRFS_METADATA_ITEM_KEY;
 		key.offset = rec->info_level;
 	} else {
@@ -7561,6 +7565,10 @@ static int fixup_extent_flags(struct btrfs_fs_info *fs_info,
 		btrfs_commit_transaction(trans, root);
 		return ret;
 	} else if (ret) {
+		if (key.type == BTRFS_METADATA_ITEM_KEY) {
+			metadata_item = false;
+			goto retry;
+		}
 		fprintf(stderr, "Didn't find extent for %llu\n",
 			(unsigned long long)rec->start);
 		btrfs_release_path(&path);
-- 
2.16.4

