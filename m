From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Subject: btrfs-progs trivial: Double definition of BTRFS_CSUM_TYPE_CRC32 in ctree.h
Date: Mon, 05 Oct 2009 19:29:55 +0200
Message-ID: <gifx9x6964.fsf@sora.hank.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

Hello,

I noticed a double definition of BTRFS_CSUM_TYPE_CRC32 in ctree.h
and attach a patch that removes it.

Best regards,

Dirk


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=ctree.h.diff
Content-Description: ctree.h.diff

diff --git a/ctree.h b/ctree.h
index a9062ea..fec0d9e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -108,10 +108,6 @@ struct btrfs_trans_handle;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-
-/* csum types */
-#define BTRFS_CSUM_TYPE_CRC32	0
-
 static int btrfs_csum_sizes[] = { 4, 0 };
 
 /* four bytes for CRC32 */

--=-=-=--
