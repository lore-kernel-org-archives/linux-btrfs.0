From: Liuwenyi <qingshenlwy@gmail.com>
Subject: [PATCHv2 02/12]posix_acl: Add the check items
Date: Mon, 21 Dec 2009 19:52:58 +0800
Message-ID: <4B2F619A.8000407@gmail.com>
Reply-To: qingshenlwy@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	joel.becker@oracle.com, cjb@laptop.org, jmorris@namei.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	onlyflyer@gmail.
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756640AbZLULt2@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.


---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: James Morris <jmorris@namei.org>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2e9e699..0f14f95 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_handle
*trans,
char *value = NULL;
mode_t mode;

- if (acl) {
- ret = posix_acl_valid(acl);
- if (ret < 0)
- return ret;
- ret = 0;
- }
+ ret = posix_acl_valid(acl);
+ if (ret < 0)
+ return ret;

switch (type) {
case ACL_TYPE_ACCESS:

-- 
Best Regards,
Liuwenyi
