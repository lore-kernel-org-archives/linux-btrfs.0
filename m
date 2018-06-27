Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934003AbeF0Nie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 09:38:34 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DE7CAC23
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 13:38:33 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Document locking require via lockdep_assert_held
Date: Wed, 27 Jun 2018 16:38:23 +0300
Message-Id: <1530106705-27186-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1530106705-27186-1-git-send-email-nborisov@suse.com>
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove stale comment since there is no longer an eb->eb_lock and
document the locking expectation with a lockdep_assert_held statement.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4180a3b7e725..6ac15804bab1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5064,9 +5064,10 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 	__free_extent_buffer(eb);
 }
 
-/* Expects to have eb->eb_lock already held */
 static int release_extent_buffer(struct extent_buffer *eb)
 {
+	lockdep_assert_held(&eb->refs_lock);
+
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
 		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
-- 
2.7.4

