Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdJaRq2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5384ABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/11] btrfs: introduce free_device helper
Date: Tue, 31 Oct 2017 18:44:38 +0100
Message-Id: <9d2a0077ab55585d7d345fd9617934a327af24d2.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A helper to free a device and all it's dynamically allocated members,
like the rcu_string name or flush_bio. This is going to replace all
open coded places.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ab03e712aa49..35c546aade83 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -180,6 +180,13 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	return fs_devs;
 }
 
+static void free_device(struct btrfs_device *device)
+{
+	rcu_string_free(device->name);
+	bio_put(device->flush_bio);
+	kfree(device);
+}
+
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
@@ -220,6 +227,11 @@ void btrfs_cleanup_fs_uuids(void)
 	}
 }
 
+/*
+ * Returns a pointer to a new btrfs_device on success; ERR_PTR() on error.
+ * Returned struct is not linked onto any lists and must be destroyed using
+ * free_device.
+ */
 static struct btrfs_device *__alloc_device(void)
 {
 	struct btrfs_device *dev;
@@ -6256,8 +6268,8 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
  *		is generated.
  *
  * Return: a pointer to a new &struct btrfs_device on success; ERR_PTR()
- * on error.  Returned struct is not linked onto any lists and can be
- * destroyed with kfree() right away.
+ * on error.  Returned struct is not linked onto any lists and must be
+ * destroyed with free_device.
  */
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
-- 
2.14.0

