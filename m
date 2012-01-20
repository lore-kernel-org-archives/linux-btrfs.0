From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] Btrfs: use gfp_t to silence a sparse warning
Date: Fri, 20 Jan 2012 10:56:43 +0300
Message-ID: <20120120075643.GC2295@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

These should be gfp_t or Sparse complains:
fs/btrfs/ulist.c:100:55: warning:
	incorrect type in argument 2 (different base types)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 12f5147..5d1b047 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -95,7 +95,7 @@ EXPORT_SYMBOL(ulist_reinit);
  *
  * The allocated ulist will be returned in an initialized state.
  */
-struct ulist *ulist_alloc(unsigned long gfp_mask)
+struct ulist *ulist_alloc(gfp_t gfp_mask)
 {
 	struct ulist *ulist = kmalloc(sizeof(*ulist), gfp_mask);
 
@@ -143,8 +143,7 @@ EXPORT_SYMBOL(ulist_free);
  * In case of allocation failure -ENOMEM is returned and the ulist stays
  * unaltered.
  */
-int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
-	      unsigned long gfp_mask)
+int ulist_add(struct ulist *ulist, u64 val, unsigned long aux, gfp_t gfp_mask)
 {
 	int i;
 
