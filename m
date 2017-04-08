Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36070 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933687AbdDHA6j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:39 -0400
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
Subject: [PATCH 05/12] fs: ufs: Use ktime_get_real_ts64() for birthtime
Date: Fri,  7 Apr 2017 17:57:03 -0700
Message-Id: <1491613030-11599-6-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CURRENT_TIME is not y2038 safe.
Replace it with ktime_get_real_ts64().
Inode time formats are already 64 bit long and
accommodates time64_t.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/ufs/ialloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/ialloc.c b/fs/ufs/ialloc.c
index 9774555..d1dd8cc 100644
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -176,6 +176,7 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 	struct ufs_cg_private_info * ucpi;
 	struct ufs_cylinder_group * ucg;
 	struct inode * inode;
+	struct timespec64 ts;
 	unsigned cg, bit, i, j, start;
 	struct ufs_inode_info *ufsi;
 	int err = -ENOSPC;
@@ -323,8 +324,9 @@ struct inode *ufs_new_inode(struct inode *dir, umode_t mode)
 		lock_buffer(bh);
 		ufs2_inode = (struct ufs2_inode *)bh->b_data;
 		ufs2_inode += ufs_inotofsbo(inode->i_ino);
-		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, CURRENT_TIME.tv_sec);
-		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, CURRENT_TIME.tv_nsec);
+		ktime_get_real_ts64(&ts);
+		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, ts.tv_sec);
+		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, ts.tv_nsec);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		if (sb->s_flags & MS_SYNCHRONOUS)
-- 
2.7.4

