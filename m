Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaJBQxy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:53:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id ED862AB1D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:53:52 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: remove unlikely from NULL checks
Date: Thu,  2 Oct 2014 18:53:52 +0200
Message-Id: <5d99a998f375b7bff7ddff0162a6eed4d4ca1318.1412265734.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265734.git.dsterba@suse.cz>
References: <cover.1412265734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlikely is implicit for NULL checks of pointers.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/async-thread.c | 10 +++++-----
 fs/btrfs/inode.c        |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 2da0a66790ba..4dabeb893b7c 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -92,7 +92,7 @@ __btrfs_alloc_workqueue(const char *name, int flags, int max_active,
 {
 	struct __btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
 
-	if (unlikely(!ret))
+	if (!ret)
 		return NULL;
 
 	ret->max_active = max_active;
@@ -116,7 +116,7 @@ __btrfs_alloc_workqueue(const char *name, int flags, int max_active,
 		ret->normal_wq = alloc_workqueue("%s-%s", flags,
 						 ret->max_active, "btrfs",
 						 name);
-	if (unlikely(!ret->normal_wq)) {
+	if (!ret->normal_wq) {
 		kfree(ret);
 		return NULL;
 	}
@@ -138,12 +138,12 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 {
 	struct btrfs_workqueue *ret = kzalloc(sizeof(*ret), GFP_NOFS);
 
-	if (unlikely(!ret))
+	if (!ret)
 		return NULL;
 
 	ret->normal = __btrfs_alloc_workqueue(name, flags & ~WQ_HIGHPRI,
 					      max_active, thresh);
-	if (unlikely(!ret->normal)) {
+	if (!ret->normal) {
 		kfree(ret);
 		return NULL;
 	}
@@ -151,7 +151,7 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(const char *name,
 	if (flags & WQ_HIGHPRI) {
 		ret->high = __btrfs_alloc_workqueue(name, flags, max_active,
 						    thresh);
-		if (unlikely(!ret->high)) {
+		if (!ret->high) {
 			__btrfs_destroy_workqueue(ret->normal);
 			kfree(ret);
 			return NULL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 344a322eb386..998e67fdf2f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9013,7 +9013,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 		spin_unlock(&root->delalloc_lock);
 
 		work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
-		if (unlikely(!work)) {
+		if (!work) {
 			if (delay_iput)
 				btrfs_add_delayed_iput(inode);
 			else
-- 
1.8.4.5

