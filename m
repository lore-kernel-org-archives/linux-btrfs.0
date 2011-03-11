From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 2/6] btrfs: make struct map_lookup public
Date: Fri, 11 Mar 2011 15:49:39 +0100
Message-ID: <21a889929560111c81d8114d66add73a7056d3be.1299854593.git.sensille@gmx.net>
References: <cover.1299854593.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299854593.git.sensille@gmx.net>
In-Reply-To: <cover.1299854593.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

definition of struct map_lookup moved from volumes.c to the header

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/volumes.c |   14 --------------
 fs/btrfs/volumes.h |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 94334d9..7dc9fa5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -33,25 +33,11 @@
 #include "volumes.h"
 #include "async-thread.h"
 
-struct map_lookup {
-	u64 type;
-	int io_align;
-	int io_width;
-	int stripe_len;
-	int sector_size;
-	int num_stripes;
-	int sub_stripes;
-	struct btrfs_bio_stripe stripes[];
-};
-
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_device *device);
 static int btrfs_relocate_sys_chunks(struct btrfs_root *root);
 
-#define map_lookup_size(n) (sizeof(struct map_lookup) + \
-			    (sizeof(struct btrfs_bio_stripe) * (n)))
-
 static DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7af6144..0ccc982 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -129,6 +129,20 @@ struct btrfs_bio_stripe {
 	u64 physical;
 };
 
+struct map_lookup {
+	u64 type;
+	int io_align;
+	int io_width;
+	int stripe_len;
+	int sector_size;
+	int num_stripes;
+	int sub_stripes;
+	struct btrfs_bio_stripe stripes[];
+};
+
+#define map_lookup_size(n) (sizeof(struct map_lookup) + \
+			    (sizeof(struct btrfs_bio_stripe) * (n)))
+
 struct btrfs_multi_bio {
 	atomic_t stripes_pending;
 	bio_end_io_t *end_io;
-- 
1.7.3.4

