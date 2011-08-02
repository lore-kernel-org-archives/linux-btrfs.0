From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 8/11] fs/btrfs/volumes.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:35:01 +0200
Message-ID: <1312281304-11847-9-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, trivial@kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..275be0f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1983,8 +1983,8 @@ again:
 						   found_key.offset);
 			if (ret == -ENOSPC)
 				failed++;
-			else if (ret)
-				BUG();
+			else
+				BUG_ON(ret);
 		}
 
 		if (found_key.offset == 0)

