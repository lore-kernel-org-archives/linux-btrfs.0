Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E49EC6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E4F206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36E4F206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbeJLOOC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 10:14:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:37264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbeJLOOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 10:14:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75387AEE5
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:43:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: Deprecate unused super block member log_root_transid
Date:   Fri, 12 Oct 2018 14:42:58 +0800
Message-Id: <20181012064258.27033-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181012064258.27033-1-wqu@suse.com>
References: <20181012064258.27033-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only user of it is "btrfs inspect dump-super".

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-inspect-dump-super.c | 4 ++--
 ctree.h                   | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index e965267c5d96..3f33931ed9bc 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -387,8 +387,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_chunk_root_level(sb));
 	printf("log_root\t\t%llu\n",
 	       (unsigned long long)btrfs_super_log_root(sb));
-	printf("log_root_transid\t%llu\n",
-	       (unsigned long long)btrfs_super_log_root_transid(sb));
+	printf("log_root_transid (deprecated)\t%llu\n",
+	       le64_to_cpu(sb->__unused_log_root_transid));
 	printf("log_root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_super_log_root_level(sb));
 	printf("total_bytes\t\t%llu\n",
diff --git a/ctree.h b/ctree.h
index 4719962df67d..a314fdb102b0 100644
--- a/ctree.h
+++ b/ctree.h
@@ -427,8 +427,8 @@ struct btrfs_super_block {
 	__le64 chunk_root;
 	__le64 log_root;
 
-	/* this will help find the new super based on the log root */
-	__le64 log_root_transid;
+	/* This member is never touched, should always be 0 */
+	__le64 __unused_log_root_transid;
 	__le64 total_bytes;
 	__le64 bytes_used;
 	__le64 root_dir_objectid;
@@ -2203,8 +2203,6 @@ BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
 			 chunk_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_log_root, struct btrfs_super_block,
 			 log_root, 64);
-BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
-			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
 BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
-- 
2.19.1

