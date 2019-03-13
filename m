Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9896CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658EA206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfCMPpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:60738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726720AbfCMPpv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A1CAB117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D361BDA875; Wed, 13 Mar 2019 16:47:05 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/9] btrfs: add assertion helpers for spinning readers
Date:   Wed, 13 Mar 2019 16:47:05 +0100
Message-Id: <166229ac17bc9ee50810c9a572b8262a75fac471.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552489554.git.dsterba@suse.com>
References: <cover.1552489554.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add helpers for conditional DEBUG build to assert that the extent buffer
spinning_readers constraints are met. Will be used in followup patches.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index a5a3c5118f61..2dd3ae524aa3 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -32,10 +32,23 @@ static void btrfs_assert_no_spinning_writers(struct extent_buffer *eb)
 	WARN_ON(atomic_read(&eb->spinning_writers));
 }
 
+static void btrfs_assert_spinning_readers_get(struct extent_buffer *eb)
+{
+	atomic_inc(&eb->spinning_readers);
+}
+
+static void btrfs_assert_spinning_readers_put(struct extent_buffer *eb)
+{
+	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
+	atomic_dec(&eb->spinning_readers);
+}
+
 #else
 static void btrfs_assert_spinning_writers_get(struct extent_buffer *eb) { }
 static void btrfs_assert_spinning_writers_put(struct extent_buffer *eb) { }
 static void btrfs_assert_no_spinning_writers(struct extent_buffer *eb) { }
+static void btrfs_assert_spinning_readers_put(struct extent_buffer *eb) { }
+static void btrfs_assert_spinning_readers_get(struct extent_buffer *eb) { }
 #endif
 
 void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
-- 
2.20.1

