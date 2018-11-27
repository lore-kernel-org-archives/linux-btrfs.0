Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9E0C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7325720873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7325720873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbeK1GxJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:35272 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4650AC3E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C7DD2DAC3A; Tue, 27 Nov 2018 20:53:52 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/9] btrfs: switch EXTENT_FLAG_* to enums
Date:   Tue, 27 Nov 2018 20:53:52 +0100
Message-Id: <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
References: <cover.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can use simple enum for values that are not part of on-disk format:
extent map flags.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_map.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 31977ffd6190..ef05a0121652 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -11,13 +11,20 @@
 #define EXTENT_MAP_INLINE ((u64)-2)
 #define EXTENT_MAP_DELALLOC ((u64)-1)
 
-/* bits for the flags field */
-#define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
-#define EXTENT_FLAG_COMPRESSED 1
-#define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
-#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
-#define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
-#define EXTENT_FLAG_FS_MAPPING 6 /* filesystem extent mapping type */
+/* bits for the extent_map::flags field */
+enum {
+	/* this entry not yet on disk, don't free it */
+	EXTENT_FLAG_PINNED,
+	EXTENT_FLAG_COMPRESSED,
+	/* pre-allocated extent */
+	EXTENT_FLAG_PREALLOC,
+	/* Logging this extent */
+	EXTENT_FLAG_LOGGING,
+	/* Filling in a preallocated extent */
+	EXTENT_FLAG_FILLING,
+	/* filesystem extent mapping type */
+	EXTENT_FLAG_FS_MAPPING,
+};
 
 struct extent_map {
 	struct rb_node rb_node;
-- 
2.19.1

