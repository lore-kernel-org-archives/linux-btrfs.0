From: Sage Weil <sage@newdream.net>
Subject: [PATCH 1/2] Btrfs: fix search_ioctl key advance
Date: Mon, 15 Mar 2010 17:02:25 -0700
Message-ID: <1268697746-16300-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

key->type is u8, not u64.

fs/btrfs/ioctl.c: In function 'copy_to_sk':
fs/btrfs/ioctl.c:1024: warning: comparison is always true due to limited range of data type

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e4397a6..f06e8fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1021,7 +1021,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 advance_key:
 	if (key->offset < (u64)-1)
 		key->offset++;
-	else if (key->type < (u64)-1)
+	else if (key->type < (u8)-1)
 		key->type++;
 	else if (key->objectid < (u64)-1)
 		key->objectid++;
-- 
1.6.6.1

