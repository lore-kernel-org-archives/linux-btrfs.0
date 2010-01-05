From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: [PATCH] check for NULL pointer dereference in btrfs_set_acl
Date: Tue, 5 Jan 2010 21:33:47 +0100
Message-ID: <201001052133.48355.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755657Ab0AEUd4@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Check for for NULL pointer in btrfs_set_acl and omit calling 
posix_acl_equiv_mode in this case to avoid NULL pointer dereference there. 

Signed-off-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2e9e699..3a3a96d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -111,13 +111,15 @@ static int btrfs_set_acl(struct btrfs_trans_handle 
*trans,

        switch (type) {
        case ACL_TYPE_ACCESS:
-               mode = inode->i_mode;
-               ret = posix_acl_equiv_mode(acl, &mode);
-               if (ret < 0)
-                       return ret;
-               ret = 0;
-               inode->i_mode = mode;
                name = POSIX_ACL_XATTR_ACCESS;
+               if (acl) {
+                       mode = inode->i_mode;
+                       ret = posix_acl_equiv_mode(acl, &mode);
+                       if (ret < 0)
+                               return ret;
+                       ret = 0;
+                       inode->i_mode = mode;
+               }
                break;
        case ACL_TYPE_DEFAULT:
                if (!S_ISDIR(inode->i_mode))
