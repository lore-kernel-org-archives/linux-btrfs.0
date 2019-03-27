Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526CCC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 229092087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfC0MY0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:24:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:55248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728396AbfC0MYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:24:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71019AF6D
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:24:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 07/15] btrfs: Implement set_extent_bits_nowait
Date:   Wed, 27 Mar 2019 14:24:10 +0200
Message-Id: <20190327122418.24027-8-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190327122418.24027-1-nborisov@suse.com>
References: <20190327122418.24027-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It will be used in a future patch that will require modifying an
extent_io_tree struct under a spinlock.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++++++
 fs/btrfs/extent_io.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eec64436d488..4bf17d4c0819 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1366,6 +1366,13 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 				changeset);
 }
 
+int set_extent_bits_nowait(struct extent_io_tree *tree, u64 start, u64 end,
+			   unsigned bits)
+{
+	return __set_extent_bit(tree, start, end, bits, 0, NULL, NULL,
+				GFP_NOWAIT, NULL);
+}
+
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
 		     struct extent_state **cached)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0fda249e5982..c23ce4df88f3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -329,6 +329,8 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   unsigned bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
+int set_extent_bits_nowait(struct extent_io_tree *tree, u64 start, u64 end,
+			   unsigned bits);
 
 static inline int set_extent_bits(struct extent_io_tree *tree, u64 start,
 		u64 end, unsigned bits)
-- 
2.17.1

