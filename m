From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v7 6/8] btrfs scrub: use int for mirror_num, not u64
Date: Fri, 22 Jul 2011 13:12:16 +0200
Message-ID: <4e73ff27921162fa84bf1ff686680e011d828d67.1311333004.git.list.btrfs@jan-o-sch.net>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311333004.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311333004.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

the rest of the code uses int mirror_num, and so should scrub

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 59caf8f..41a0114 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -65,7 +65,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix);
 struct scrub_page {
 	u64			flags;  /* extent flags */
 	u64			generation;
-	u64			mirror_num;
+	int			mirror_num;
 	int			have_csum;
 	u8			csum[BTRFS_CSUM_SIZE];
 };
@@ -776,7 +776,7 @@ nomem:
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
-		      u64 physical, u64 flags, u64 gen, u64 mirror_num,
+		      u64 physical, u64 flags, u64 gen, int mirror_num,
 		      u8 *csum, int force)
 {
 	struct scrub_bio *sbio;
@@ -873,7 +873,7 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 
 /* scrub extent tries to collect up to 64 kB for each bio */
 static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
-			u64 physical, u64 flags, u64 gen, u64 mirror_num)
+			u64 physical, u64 flags, u64 gen, int mirror_num)
 {
 	int ret;
 	u8 csum[BTRFS_CSUM_SIZE];
@@ -919,7 +919,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	u64 physical;
 	u64 logical;
 	u64 generation;
-	u64 mirror_num;
+	int mirror_num;
 
 	u64 increment = map->stripe_len;
 	u64 offset;
-- 
1.7.3.4

