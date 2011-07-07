From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 6/8] scrub: use int for mirror_num, not u64
Date: Thu,  7 Jul 2011 17:48:31 +0200
Message-ID: <7645b6478a76d461531ec7f8044ecd5a12e48270.1310053204.git.list.btrfs@jan-o-sch.net>
References: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

the rest of the code uses int mirror_num, and so should scrub

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 15fed35..12c08c0 100644
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

