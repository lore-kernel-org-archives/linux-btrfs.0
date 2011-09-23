From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/extent_map.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:45:56 -0700
Message-ID: <201109221845.56204.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the sparse noise:

warning: symbol '__lookup_extent_mapping' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>
linux-btrfs@vger.kernel.org
linux-kernel@vger.kernel.org

---

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7c97b33..48004fe 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -282,7 +282,7 @@ static u64 range_end(u64 start, u64 len)
 	return start + len;
 }
 
-struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
+static struct extent_map *__lookup_extent_mapping(struct extent_map_tree *tree,
 					   u64 start, u64 len, int strict)
 {
 	struct extent_map *em;
