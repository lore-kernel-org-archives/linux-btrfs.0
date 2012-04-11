From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] btrfs_scan_one_dir: avoid use-after-free on error path
Date: Wed, 11 Apr 2012 16:42:50 +0200
Message-ID: <874nsqib2t.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


If we iterate the "goto again" loop, we've called "closedir(dirp)",
yet at the top of the loop, upon malloc failure we "goto fail",
where we test dirp and if non-NULL, call closedir(dirp) again.
* utils.c (btrfs_scan_one_dir): Clear "dirp" after closedir to avoid
use-after-free upon failed fullpath = malloc(...

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
Coverity reported this use-after-free.

I chose to set dirp to NULL after each closedir(dirp).
An alternative fix is to move the test for malloc failure "down"
to after the test for opendir failure.

 utils.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index ee7fa1b..7c8c9d3 100644
--- a/utils.c
+++ b/utils.c
@@ -1021,6 +1021,7 @@ again:
 				     list);
 		list_del(&pending->list);
 		closedir(dirp);
+		dirp = NULL;
 		goto again;
 	}
 	ret = 0;
--
1.7.10.128.g7945c
