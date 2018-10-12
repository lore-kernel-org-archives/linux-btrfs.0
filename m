Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAFFC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830AF2098A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:27:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 830AF2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbeJLN54 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 09:57:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:35756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727056AbeJLN54 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 09:57:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F0BFAE11
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:27:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Deprecate unused super block member, log_root_transid
Date:   Fri, 12 Oct 2018 14:26:57 +0800
Message-Id: <20181012062657.23255-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The member log_root_transid is never used.
It's always kept untouched even when updating log tree root.

And populating it without introducing new incompat flags could easily
cause back-compatibility problems.
So just mark it unused.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..9adc53db679a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -214,8 +214,8 @@ struct btrfs_super_block {
 	__le64 chunk_root;
 	__le64 log_root;
 
-	/* this will help find the new super based on the log root */
-	__le64 log_root_transid;
+	/* This member is never touched, should always be 0 */
+	__le64 __unused_log_root_transid;
 	__le64 total_bytes;
 	__le64 bytes_used;
 	__le64 root_dir_objectid;
@@ -2317,8 +2317,6 @@ BTRFS_SETGET_STACK_FUNCS(super_chunk_root_level, struct btrfs_super_block,
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

