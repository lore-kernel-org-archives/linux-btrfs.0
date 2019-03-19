Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D1EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 06:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAB520989
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 06:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfCSGEZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 02:04:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:42752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfCSGEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 02:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55BECAF8A
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 06:04:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Make btrfs_(set|clear)_header_flag return void
Date:   Tue, 19 Mar 2019 14:04:17 +0800
Message-Id: <20190319060418.29575-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From the introduce of btrfs_(set|clear)_header_flag, there is no usage
of its return value.

So just make it return void.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3642367a595..c03852d1aa34 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2163,18 +2163,16 @@ static inline int btrfs_header_flag(const struct extent_buffer *eb, u64 flag)
 	return (btrfs_header_flags(eb) & flag) == flag;
 }
 
-static inline int btrfs_set_header_flag(struct extent_buffer *eb, u64 flag)
+static inline void btrfs_set_header_flag(struct extent_buffer *eb, u64 flag)
 {
 	u64 flags = btrfs_header_flags(eb);
 	btrfs_set_header_flags(eb, flags | flag);
-	return (flags & flag) == flag;
 }
 
-static inline int btrfs_clear_header_flag(struct extent_buffer *eb, u64 flag)
+static inline void btrfs_clear_header_flag(struct extent_buffer *eb, u64 flag)
 {
 	u64 flags = btrfs_header_flags(eb);
 	btrfs_set_header_flags(eb, flags & ~flag);
-	return (flags & flag) == flag;
 }
 
 static inline int btrfs_header_backref_rev(const struct extent_buffer *eb)
-- 
2.21.0

