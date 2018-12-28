Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14185C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D35B820866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbeL1IiU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:38:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:34516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726608AbeL1IiU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:38:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DF13AD38
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:38:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs-progs: dump-tree/dump-super: Introduce support for bg tree
Date:   Fri, 28 Dec 2018 16:38:05 +0800
Message-Id: <20181228083806.3204-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181228083806.3204-1-wqu@suse.com>
References: <20181228083806.3204-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-inspect-dump-super.c | 3 ++-
 cmds-inspect-dump-tree.c  | 5 +++++
 print-tree.c              | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 97e9624db8d7..4550a38e59fe 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -229,7 +229,8 @@ static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
 	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
 	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES),
-	DEF_INCOMPAT_FLAG_ENTRY(METADATA_UUID)
+	DEF_INCOMPAT_FLAG_ENTRY(METADATA_UUID),
+	DEF_INCOMPAT_FLAG_ENTRY(BG_TREE)
 };
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index ad5345b4f1db..0e96acded90a 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -148,6 +148,7 @@ static u64 treeid_from_string(const char *str, const char **end)
 		{ "CSUM", BTRFS_CSUM_TREE_OBJECTID },
 		{ "CHECKSUM", BTRFS_CSUM_TREE_OBJECTID },
 		{ "QUOTA", BTRFS_QUOTA_TREE_OBJECTID },
+		{ "BG", BTRFS_BLOCK_GROUP_TREE_OBJECTID },
 		{ "UUID", BTRFS_UUID_TREE_OBJECTID },
 		{ "FREE_SPACE", BTRFS_FREE_SPACE_TREE_OBJECTID },
 		{ "TREE_LOG_FIXUP", BTRFS_TREE_LOG_FIXUP_OBJECTID },
@@ -559,6 +560,10 @@ again:
 				if (!skip)
 					printf("free space");
 				break;
+			case BTRFS_BLOCK_GROUP_TREE_OBJECTID:
+				if (!skip)
+					printf("block group");
+				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
 				if (!skip) {
 					printf("multiple");
diff --git a/print-tree.c b/print-tree.c
index ab77463706c1..3e61b5254a1f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -790,6 +790,9 @@ void print_objectid(FILE *stream, u64 objectid, u8 type)
 	case BTRFS_FREE_SPACE_TREE_OBJECTID:
 		fprintf(stream, "FREE_SPACE_TREE");
 		break;
+	case BTRFS_BLOCK_GROUP_TREE_OBJECTID:
+		fprintf(stream, "BLOCK_GROUP_TREE");
+		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		fprintf(stream, "MULTIPLE");
 		break;
-- 
2.20.1

