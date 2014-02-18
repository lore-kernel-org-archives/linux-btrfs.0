Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:44637 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbaBRU3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 15:29:09 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 7/9] dcache: d_find_alias needn't recheck IS_ROOT && DCACHE_DISCONNECTED
Date: Tue, 18 Feb 2014 15:29:03 -0500
Message-Id: <1392755345-12830-7-git-send-email-bfields@redhat.com>
In-Reply-To: <1392755345-12830-1-git-send-email-bfields@redhat.com>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "J. Bruce Fields" <bfields@redhat.com>

If we get to this point and discover the dentry is not a root dentry, or
not DCACHE_DISCONNECTED--great, we always prefer that anyway.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/dcache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index efe3d3b..448ef98 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -753,12 +753,9 @@ again:
 		alias = discon_alias;
 		spin_lock(&alias->d_lock);
 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
-			if (IS_ROOT(alias) &&
-			    (alias->d_flags & DCACHE_DISCONNECTED)) {
-				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
-				return alias;
-			}
+			__dget_dlock(alias);
+			spin_unlock(&alias->d_lock);
+			return alias;
 		}
 		spin_unlock(&alias->d_lock);
 		goto again;
-- 
1.8.5.3

