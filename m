Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5B2C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26082175B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfCUTTk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:19:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:42092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727958AbfCUTTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 15:19:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0569DAE7F
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 19:19:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ECFBBDA77B; Thu, 21 Mar 2019 20:20:53 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove stale definition of BUFFER_LRU_MAX
Date:   Thu, 21 Mar 2019 20:20:48 +0100
Message-Id: <20190321192048.10028-1-dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Long time ago (2008), the extent buffers were organized in a LRU list
and switched to rb-tree in 6af118ce51b52ced ("Btrfs: Index extent
buffers in an rbtree"). There was one stale macro definition left.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca259c75bbcd..923070535f0b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -109,8 +109,6 @@ static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 #define btrfs_debug_check_extent_io_range(c, s, e)	do {} while (0)
 #endif
 
-#define BUFFER_LRU_MAX 64
-
 struct tree_entry {
 	u64 start;
 	u64 end;
-- 
2.21.0

