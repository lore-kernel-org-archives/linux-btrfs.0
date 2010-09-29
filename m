From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] Btrfs: Don't dereference extent_mapping if NULL
Date: Thu, 30 Sep 2010 00:20:29 +0200
Message-ID: <4CA3BBAD.8080207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Don't dereference em if it's NULL or an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I just noticed this by code analysis. It wasn't tested in any way.

 fs/btrfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..d4a37f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1787,7 +1787,8 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, failrec->len);
-		if (em->start > start || em->start + em->len < start) {
+		if (em && !IS_ERR(em) && (em->start > start ||
+					em->start + em->len < start)) {
 			free_extent_map(em);
 			em = NULL;
 		}
