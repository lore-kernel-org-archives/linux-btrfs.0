Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5937C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C06220870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfAWRiu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:38000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfAWRiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F702B080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43975DA6F5; Wed, 23 Jan 2019 18:38:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: simplify waiting loop in btrfs_tree_lock
Date:   Wed, 23 Jan 2019 18:38:16 +0100
Message-Id: <cc392a65b45fc90672c8e1ebf5f81cc96254a964.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548264220.git.dsterba@suse.com>
References: <cover.1548264220.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently, the number of readers and writers is checked and in case
there are any, wait and redo the locks. There's some duplication
before the branches go back to again label, eg. calling wait_event on
blocking_readers twice.

The sequence is transformed

loop:
* wait for readers
* wait for writers
* write_lock
* check readers, unlock and wait for readers, loop
* check writers, unlock and wait for writers, loop

The new sequence is not exactly the same due to the simplification, for
readers it's slightly faster. For the writers, original code does

* wait for writers
* (loop) wait for readers
*        wait for writers -- again

while the new goes directly to the reader check. This should behave the
same on a contended lock with multiple writers and readers, but can
reduce number of times we're waiting on something.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 7f89ca6f1fbc..82b84e4daad1 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -237,16 +237,9 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
 	write_lock(&eb->lock);
-	if (atomic_read(&eb->blocking_readers)) {
+	if (atomic_read(&eb->blocking_readers) ||
+	    atomic_read(&eb->blocking_writers)) {
 		write_unlock(&eb->lock);
-		wait_event(eb->read_lock_wq,
-			   atomic_read(&eb->blocking_readers) == 0);
-		goto again;
-	}
-	if (atomic_read(&eb->blocking_writers)) {
-		write_unlock(&eb->lock);
-		wait_event(eb->write_lock_wq,
-			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
 	WARN_ON(atomic_read(&eb->spinning_writers));
-- 
2.20.1

