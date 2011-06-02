From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v6 11/20] evm: add evm_inode_post_init call in btrfs
Date: Thu,  2 Jun 2011 08:23:34 -0400
Message-ID: <1307017423-15093-12-git-send-email-zohar@linux.vnet.ibm.com>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <greg@kroah.com>,
	Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

After creating the initial LSM security extended attribute, call
evm_inode_post_init_security() to create the 'security.evm'
extended attribute.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/btrfs/xattr.c |   39 +++++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index f3107e4..8e9afcb2 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -22,6 +22,7 @@
 #include <linux/rwsem.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/evm.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
@@ -367,31 +368,49 @@ int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 			      const struct qstr *qstr)
 {
 	int err;
-	size_t len;
-	void *value;
-	char *suffix;
+	struct xattr lsm_xattr;
+	struct xattr evm_xattr;
 	char *name;
 
-	err = security_inode_init_security(inode, dir, qstr, &suffix, &value,
-					   &len);
+	err = security_inode_init_security(inode, dir, qstr, &lsm_xattr.name,
+					   &lsm_xattr.value,
+					   &lsm_xattr.value_len);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 
-	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(suffix) + 1,
+	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(lsm_xattr.name) + 1,
 		       GFP_NOFS);
 	if (!name) {
 		err = -ENOMEM;
 	} else {
 		strcpy(name, XATTR_SECURITY_PREFIX);
-		strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
-		err = __btrfs_setxattr(trans, inode, name, value, len, 0);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, lsm_xattr.name);
+		err = __btrfs_setxattr(trans, inode, name, lsm_xattr.value,
+				       lsm_xattr.value_len, 0);
 		kfree(name);
 	}
+	if (err)
+		goto out;
+
+	err = evm_inode_post_init_security(inode, &lsm_xattr, &evm_xattr);
+	if (err)
+		goto out;
 
-	kfree(suffix);
-	kfree(value);
+	name = kasprintf(GFP_NOFS, "%s%s", XATTR_SECURITY_PREFIX,
+			 evm_xattr.name);
+	if (!name)
+		err = -ENOMEM;
+	else {
+		err = __btrfs_setxattr(trans, inode, name, evm_xattr.value,
+				       evm_xattr.value_len, 0);
+		kfree(name);
+	}
+	kfree(evm_xattr.value);
+out:
+	kfree(lsm_xattr.name);
+	kfree(lsm_xattr.value);
 	return err;
 }
-- 
1.7.3.4
