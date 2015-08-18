Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36058 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbbHRKjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 06:39:39 -0400
Date: Tue, 18 Aug 2015 12:39:37 +0200
From: Michal Hocko <mhocko@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [RFC -v2 6/8] ext3: Do not abort journal prematurely
Message-ID: <20150818103937.GE5033@dhcp22.suse.cz>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-7-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438768284-30927-7-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

journal_get_undo_access is relying on GFP_NOFS allocation yet it is
essential for the journal transaction:

[   83.256914] journal_get_undo_access: No memory for committed data
[   83.258022] EXT3-fs: ext3_free_blocks_sb: aborting transaction: Out
of memory in __ext3_journal_get_undo_access
[   83.259785] EXT3-fs (hdb1): error in ext3_free_blocks_sb: Out of
memory
[   83.267130] Aborting journal on device hdb1.
[   83.292308] EXT3-fs (hdb1): error: ext3_journal_start_sb: Detected
aborted journal
[   83.293630] EXT3-fs (hdb1): error: remounting filesystem read-only

Since "mm: page_alloc: do not lock up GFP_NOFS allocations upon OOM"
these allocation requests are allowed to fail so we need to use
__GFP_NOFAIL to imitate the previous behavior.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/jbd/transaction.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index bf7474deda2f..2151b80276c3 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -886,15 +886,8 @@ int journal_get_undo_access(handle_t *handle, struct buffer_head *bh)
 		goto out;
 
 repeat:
-	if (!jh->b_committed_data) {
-		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
-		if (!committed_data) {
-			printk(KERN_ERR "%s: No memory for committed data\n",
-				__func__);
-			err = -ENOMEM;
-			goto out;
-		}
-	}
+	if (!jh->b_committed_data)
+		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS | __GFP_NOFAIL);
 
 	jbd_lock_bh_state(bh);
 	if (!jh->b_committed_data) {
-- 
2.5.0

-- 
Michal Hocko
SUSE Labs
