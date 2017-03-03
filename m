Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55568 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 01/17] fs, btrfs: convert btrfs_bio.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:10 +0200
Message-Id: <1488531326-21271-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 fs/btrfs/volumes.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b124462..a8fd2e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5295,22 +5295,22 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 		GFP_NOFS|__GFP_NOFAIL);
 
 	atomic_set(&bbio->error, 0);
-	atomic_set(&bbio->refs, 1);
+	refcount_set(&bbio->refs, 1);
 
 	return bbio;
 }
 
 void btrfs_get_bbio(struct btrfs_bio *bbio)
 {
-	WARN_ON(!atomic_read(&bbio->refs));
-	atomic_inc(&bbio->refs);
+	WARN_ON(!refcount_read(&bbio->refs));
+	refcount_inc(&bbio->refs);
 }
 
 void btrfs_put_bbio(struct btrfs_bio *bbio)
 {
 	if (!bbio)
 		return;
-	if (atomic_dec_and_test(&bbio->refs))
+	if (refcount_dec_and_test(&bbio->refs))
 		kfree(bbio);
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 59be812..ac0bf7d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -298,7 +298,7 @@ struct btrfs_bio;
 typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
 
 struct btrfs_bio {
-	atomic_t refs;
+	refcount_t refs;
 	atomic_t stripes_pending;
 	struct btrfs_fs_info *fs_info;
 	u64 map_type; /* get from map_lookup->type */
-- 
2.7.4

