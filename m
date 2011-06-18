From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 6/7] scrub: use int for mirror_num, not u64
Date: Sat, 18 Jun 2011 13:46:03 +0200
Message-ID: <3a21e534c7cd76ace502e6b10d954f8936fccdb8.1308397267.git.list.btrfs@jan-o-sch.net>
References: <cover.1308397267.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1308397267.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1308397267.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

the rest of the code uses int mirror_num, and so should scrub

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 519bf4b..de918ff 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -71,7 +71,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix);
 struct scrub_page {
 	u64			flags;  /* extent flags */
 	u64			generation;
-	u64			mirror_num;
+	int			mirror_num;
 	int			have_csum;
 	u8			csum[BTRFS_CSUM_SIZE];
 };
@@ -761,7 +761,7 @@ nomem:
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
-		      u64 physical, u64 flags, u64 gen, u64 mirror_num,
+		      u64 physical, u64 flags, u64 gen, int mirror_num,
 		      u8 *csum, int force)
 {
 	struct scrub_bio *sbio;
@@ -858,7 +858,7 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 
 /* scrub extent tries to collect up to 64 kB for each bio */
 static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
-			u64 physical, u64 flags, u64 gen, u64 mirror_num)
+			u64 physical, u64 flags, u64 gen, int mirror_num)
 {
 	int ret;
 	u8 csum[BTRFS_CSUM_SIZE];
@@ -904,7 +904,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	u64 physical;
 	u64 logical;
 	u64 generation;
-	u64 mirror_num;
+	int mirror_num;
 
 	u64 increment = map->stripe_len;
 	u64 offset;
-- 
1.7.3.4

