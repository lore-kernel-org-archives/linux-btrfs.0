Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55077 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751385AbdGRPll (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15FF4AABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:41:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: merge alloc_device helpers
Date: Tue, 18 Jul 2017 17:40:25 +0200
Message-Id: <2d1109681e592ddbbc227f4e39157f77bdd8e587.1500391979.git.dsterba@suse.com>
In-Reply-To: <cover.1500391979.git.dsterba@suse.com>
References: <cover.1500391979.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two helpers called in chain from one location, we can merge the
functionaliy.

Originally, alloc_fs_devices could fill the device uuid randomly if we
we didn't give the uuid buffer. This happens for seed devices but the
fsid is generated in btrfs_prepare_sprout, so we can remove it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c95f018d4a1e..39deba4e88e3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -152,7 +152,15 @@ struct list_head *btrfs_get_fs_uuids(void)
 	return &fs_uuids;
 }
 
-static struct btrfs_fs_devices *__alloc_fs_devices(void)
+/*
+ * alloc_fs_devices - allocate struct btrfs_fs_devices
+ * @fsid:	if not NULL, copy the uuid to fs_devices::fsid
+ *
+ * Return a pointer to a new struct btrfs_fs_devices on success, or ERR_PTR().
+ * The returned struct is not linked onto any lists and can be destroyed with
+ * kfree() right away.
+ */
+static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 {
 	struct btrfs_fs_devices *fs_devs;
 
@@ -166,31 +174,8 @@ static struct btrfs_fs_devices *__alloc_fs_devices(void)
 	INIT_LIST_HEAD(&fs_devs->resized_devices);
 	INIT_LIST_HEAD(&fs_devs->alloc_list);
 	INIT_LIST_HEAD(&fs_devs->list);
-
-	return fs_devs;
-}
-
-/**
- * alloc_fs_devices - allocate struct btrfs_fs_devices
- * @fsid:	a pointer to UUID for this FS.  If NULL a new UUID is
- *		generated.
- *
- * Return: a pointer to a new &struct btrfs_fs_devices on success;
- * ERR_PTR() on error.  Returned struct is not linked onto any lists and
- * can be destroyed with kfree() right away.
- */
-static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
-{
-	struct btrfs_fs_devices *fs_devs;
-
-	fs_devs = __alloc_fs_devices();
-	if (IS_ERR(fs_devs))
-		return fs_devs;
-
 	if (fsid)
 		memcpy(fs_devs->fsid, fsid, BTRFS_FSID_SIZE);
-	else
-		generate_random_uuid(fs_devs->fsid);
 
 	return fs_devs;
 }
@@ -2202,7 +2187,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	if (!fs_devices->seeding)
 		return -EINVAL;
 
-	seed_devices = __alloc_fs_devices();
+	seed_devices = alloc_fs_devices(NULL);
 	if (IS_ERR(seed_devices))
 		return PTR_ERR(seed_devices);
 
@@ -6568,6 +6553,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	BUG_ON(!mutex_is_locked(&uuid_mutex));
+	ASSERT(fsid);
 
 	fs_devices = fs_info->fs_devices->seed;
 	while (fs_devices) {
-- 
2.13.0

