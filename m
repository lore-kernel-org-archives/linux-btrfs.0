From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Use do_div() instead of native 64-bit division in
	btrfs_ordered_sum_size()
Date: Mon, 21 Jul 2008 23:32:08 -0400
Message-ID: <1216697528.18980.34.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Prevents the compiler emitting calls to __udivdi3() from libgcc on some
platforms:
WARNING: "__udivdi3" [/shiny/git/btrfs-kernel-unstable/btrfs.ko] undefi=
ned!

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Untested but ObviouslyCorrect=E2=84=A2. Now that I can load the module,=
 I hit a
BUG() immediately -- but I don't think it's caused by this patch. qv.

diff --git a/ordered-data.h b/ordered-data.h
index 1794efd..1abe5f5 100644
--- a/ordered-data.h
+++ b/ordered-data.h
@@ -97,9 +97,12 @@ struct btrfs_ordered_extent {
  */
 static inline int btrfs_ordered_sum_size(struct btrfs_root *root, u64 =
bytes)
 {
-	unsigned long num_sectors =3D (bytes + root->sectorsize - 1) /
-		root->sectorsize;
-	num_sectors++;
+	unsigned long num_sectors;
+
+	bytes +=3D root->sectorsize - 1;
+	do_div(bytes, root->sectorsize);
+	num_sectors =3D bytes + 1;
+
 	return sizeof(struct btrfs_ordered_sum) +
 		num_sectors * sizeof(struct btrfs_sector_sum);
 }

--=20
David Woodhouse                            Open Source Technology Centr=
e
David.Woodhouse@intel.com                              Intel Corporatio=
n


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
