From: Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: [PATCH btrfs-progs] Fix a typo in usage message
Date: Fri, 2 Dec 2011 21:35:22 +0900
Message-ID: <20111202123523.81CCA15C03A@msa104.auone-net.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 btrfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..adb5f05 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -105,7 +105,7 @@ static struct Command commands[] = {
 	{ do_resize, 2,
 	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
-		"will occupe all available space on the device.",
+		"will occupy all available space on the device.",
 	  NULL
 	},
 	{ do_show_filesystem, 999,
-- 
1.7.7.3

