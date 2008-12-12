From: "Yehuda Sadeh Weinraub" <yehudasa@gmail.com>
Subject: [PATCH] fix wrong value returned from btrfs_listxattr when buffer is too small
Date: Fri, 12 Dec 2008 14:36:21 -0800
Message-ID: <a37615150812121436w57f43184g71b297369f3923e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix bug, btrfs_listxattr doesn't return an error when the buffer size
is too small (ret was overridden).

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index adb4b32..4146f07 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -226,7 +226,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry,
char *buffer, size_t size)

 		if (!buffer || (name_len + 1) > size_left) {
 			ret = -ERANGE;
-			break;
+			goto err;
 		}

 		name_ptr = (unsigned long)(di + 1);
-- 
1.5.6.5
