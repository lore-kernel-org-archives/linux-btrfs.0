Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6896C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD33F20872
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 17:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501969AbfIXRdA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 13:33:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:58054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730714AbfIXRdA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 13:33:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBF34AFD5;
        Tue, 24 Sep 2019 17:32:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9ABD9DA835; Tue, 24 Sep 2019 19:33:19 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: make locking assertion helpers static inline
Date:   Tue, 24 Sep 2019 19:33:19 +0200
Message-Id: <4731c206a901f36e78372ea55a5d29aa926a7008.1569345962.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1569345962.git.dsterba@suse.com>
References: <cover.1569345962.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've noticed that none of the btrfs_assert_*lock* debugging helpers is
inlined, despite they're short and mostly a value update. Making them
inline shaves 67 from the text size, reduces stack consumption and
perhaps also slightly improves the performance due to avoiding
unnecessary calls.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 7f9a578a1a20..409c5a865079 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -14,55 +14,55 @@
 #include "locking.h"
 
 #ifdef CONFIG_BTRFS_DEBUG
-static void btrfs_assert_spinning_writers_get(struct extent_buffer *eb)
+static inline void btrfs_assert_spinning_writers_get(struct extent_buffer *eb)
 {
 	WARN_ON(eb->spinning_writers);
 	eb->spinning_writers++;
 }
 
-static void btrfs_assert_spinning_writers_put(struct extent_buffer *eb)
+static inline void btrfs_assert_spinning_writers_put(struct extent_buffer *eb)
 {
 	WARN_ON(eb->spinning_writers != 1);
 	eb->spinning_writers--;
 }
 
-static void btrfs_assert_no_spinning_writers(struct extent_buffer *eb)
+static inline void btrfs_assert_no_spinning_writers(struct extent_buffer *eb)
 {
 	WARN_ON(eb->spinning_writers);
 }
 
-static void btrfs_assert_spinning_readers_get(struct extent_buffer *eb)
+static inline void btrfs_assert_spinning_readers_get(struct extent_buffer *eb)
 {
 	atomic_inc(&eb->spinning_readers);
 }
 
-static void btrfs_assert_spinning_readers_put(struct extent_buffer *eb)
+static inline void btrfs_assert_spinning_readers_put(struct extent_buffer *eb)
 {
 	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
 	atomic_dec(&eb->spinning_readers);
 }
 
-static void btrfs_assert_tree_read_locks_get(struct extent_buffer *eb)
+static inline void btrfs_assert_tree_read_locks_get(struct extent_buffer *eb)
 {
 	atomic_inc(&eb->read_locks);
 }
 
-static void btrfs_assert_tree_read_locks_put(struct extent_buffer *eb)
+static inline void btrfs_assert_tree_read_locks_put(struct extent_buffer *eb)
 {
 	atomic_dec(&eb->read_locks);
 }
 
-static void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
+static inline void btrfs_assert_tree_read_locked(struct extent_buffer *eb)
 {
 	BUG_ON(!atomic_read(&eb->read_locks));
 }
 
-static void btrfs_assert_tree_write_locks_get(struct extent_buffer *eb)
+static inline void btrfs_assert_tree_write_locks_get(struct extent_buffer *eb)
 {
 	eb->write_locks++;
 }
 
-static void btrfs_assert_tree_write_locks_put(struct extent_buffer *eb)
+static inline void btrfs_assert_tree_write_locks_put(struct extent_buffer *eb)
 {
 	eb->write_locks--;
 }
-- 
2.23.0

