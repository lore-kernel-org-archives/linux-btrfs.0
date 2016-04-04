Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33026 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbcDDLAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 07:00:23 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2] btrfs: fix typo in btrfs_statfs()
Date: Mon,  4 Apr 2016 11:59:57 +0100
Message-Id: <1459767597-10208-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correct a typo in the chunk_mutex name.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

I noticed this typo while fixing bug 114281 [0]. Sending a second version
because the first one didn't ammend cleanly after the latest changes in the
'for-next' branch.

Thanks,
Luis

[0] https://bugzilla.kernel.org/show_bug.cgi?id=114281

 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7e766ffc..9c79337 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2050,7 +2050,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	int mixed = 0;
 
 	/*
-	 * holding chunk_muext to avoid allocating new chunks, holding
+	 * holding chunk_mutex to avoid allocating new chunks, holding
 	 * device_list_mutex to avoid the device being removed
 	 */
 	rcu_read_lock();
-- 
2.6.4

