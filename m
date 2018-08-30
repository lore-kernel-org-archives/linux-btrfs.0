Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:45819 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:06 -0400
Received: by mail-qt0-f177.google.com with SMTP id g44-v6so11257305qtb.12
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:50 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w9-v6sm5170148qta.13.2018.08.30.10.42.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:49 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/35] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Date: Thu, 30 Aug 2018 13:42:02 -0400
Message-Id: <20180830174225.2200-13-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With my change to no longer take into account the global reserve for
metadata allocation chunks we have this side-effect for mixed block
group fs'es where we are no longer allocating enough chunks for the
data/metadata requirements.  To deal with this add a ALLOC_CHUNK_FORCE
step to the flushing state machine.  This will only get used if we've
already made a full loop through the flushing machinery and tried
committing the transaction.  If we have then we can try and force a
chunk allocation since we likely need it to make progress.  This
resolves the issues I was seeing with the mixed bg tests in xfstests
with my previous patch.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             | 3 ++-
 fs/btrfs/extent-tree.c       | 7 ++++++-
 include/trace/events/btrfs.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0a4e55703d48..791e287c2292 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2731,7 +2731,8 @@ enum btrfs_flush_state {
 	FLUSH_DELALLOC		=	5,
 	FLUSH_DELALLOC_WAIT	=	6,
 	ALLOC_CHUNK		=	7,
-	COMMIT_TRANS		=	8,
+	ALLOC_CHUNK_FORCE	=	8,
+	COMMIT_TRANS		=	9,
 };
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 783341e3653e..22e1f9f55f4f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4907,6 +4907,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		btrfs_end_transaction(trans);
 		break;
 	case ALLOC_CHUNK:
+	case ALLOC_CHUNK_FORCE:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -4914,7 +4915,9 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		}
 		ret = do_chunk_alloc(trans,
 				     btrfs_metadata_alloc_profile(fs_info),
-				     CHUNK_ALLOC_NO_FORCE);
+				     (state == ALLOC_CHUNK) ?
+				     CHUNK_ALLOC_NO_FORCE :
+				     CHUNK_ALLOC_FORCE);
 		btrfs_end_transaction(trans);
 		if (ret > 0 || ret == -ENOSPC)
 			ret = 0;
@@ -5060,6 +5063,8 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 			}
 		}
 		spin_unlock(&space_info->lock);
+		if (flush_state == ALLOC_CHUNK_FORCE && !commit_cycles)
+			flush_state++;
 	} while (flush_state <= COMMIT_TRANS);
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 7d205e50b09c..fdb23181b5b7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1051,6 +1051,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 		{ FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR"},	\
 		{ FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS"},		\
 		{ ALLOC_CHUNK,			"ALLOC_CHUNK"},			\
+		{ ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE"},		\
 		{ COMMIT_TRANS,			"COMMIT_TRANS"})
 
 TRACE_EVENT(btrfs_flush_space,
-- 
2.14.3
