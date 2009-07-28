From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/9] fs/btrfs: correct error-handling code
Date: Tue, 28 Jul 2009 17:53:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907281753260.28189@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

find_zlib_workspace returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = find_zlib_workspace(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/zlib.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index ecfbce8..3e2b90e 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -208,7 +208,7 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	*total_in = 0;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -1;
 
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
@@ -366,7 +366,7 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 	char *kaddr;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -ENOMEM;
 
 	data_in = kmap(pages_in[page_in_index]);
@@ -547,9 +547,9 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 		return -ENOMEM;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -ENOMEM;
 
 	workspace->inf_strm.next_in = data_in;
