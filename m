Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36135 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933518AbdDHA6t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:49 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
Subject: [PATCH 09/12] lustre: Replace CURRENT_TIME macro
Date: Fri,  7 Apr 2017 17:57:07 -0700
Message-Id: <1491613030-11599-10-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CURRENT_TIME macro is not y2038 safe on 32 bit systems.

The patch replaces all the uses of CURRENT_TIME by
current_time() for filesystem times, and ktime_get_*
functions for others.

struct timespec is also not y2038 safe.
Retain timespec for timestamp representation here as lustre
uses it internally everywhere.
These references will be changed to use struct timespec64
in a separate patch.

This is also in preparation for the patch that transitions
vfs timestamps to use 64 bit time and hence make them
y2038 safe. current_time() is also planned to be transitioned
to y2038 safe behavior along with this change.

CURRENT_TIME macro will be deleted before merging the
aforementioned change.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 6 +++---
 drivers/staging/lustre/lustre/osc/osc_io.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 7b80040..2b4b6b9 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1472,17 +1472,17 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import)
 
 	/* We mark all of the fields "set" so MDS/OST does not re-set them */
 	if (attr->ia_valid & ATTR_CTIME) {
-		attr->ia_ctime = CURRENT_TIME;
+		attr->ia_ctime = current_time(inode);
 		attr->ia_valid |= ATTR_CTIME_SET;
 	}
 	if (!(attr->ia_valid & ATTR_ATIME_SET) &&
 	    (attr->ia_valid & ATTR_ATIME)) {
-		attr->ia_atime = CURRENT_TIME;
+		attr->ia_atime = current_time(inode);
 		attr->ia_valid |= ATTR_ATIME_SET;
 	}
 	if (!(attr->ia_valid & ATTR_MTIME_SET) &&
 	    (attr->ia_valid & ATTR_MTIME)) {
-		attr->ia_mtime = CURRENT_TIME;
+		attr->ia_mtime = current_time(inode);
 		attr->ia_valid |= ATTR_MTIME_SET;
 	}
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index f991bee..cbab800 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -216,7 +216,7 @@ static int osc_io_submit(const struct lu_env *env,
 		struct cl_object *obj = ios->cis_obj;
 
 		cl_object_attr_lock(obj);
-		attr->cat_mtime = LTIME_S(CURRENT_TIME);
+		attr->cat_mtime = ktime_get_real_seconds();
 		attr->cat_ctime = attr->cat_mtime;
 		cl_object_attr_update(env, obj, attr, CAT_MTIME | CAT_CTIME);
 		cl_object_attr_unlock(obj);
@@ -256,7 +256,7 @@ static void osc_page_touch_at(const struct lu_env *env,
 	       kms > loi->loi_kms ? "" : "not ", loi->loi_kms, kms,
 	       loi->loi_lvb.lvb_size);
 
-	attr->cat_ctime = LTIME_S(CURRENT_TIME);
+	attr->cat_ctime = ktime_get_real_seconds();
 	attr->cat_mtime = attr->cat_ctime;
 	valid = CAT_MTIME | CAT_CTIME;
 	if (kms > loi->loi_kms) {
-- 
2.7.4

