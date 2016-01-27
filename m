Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbcA0KOz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 05:14:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 118EDAAC4
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 10:14:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sysfs: check initialization state before updating features
Date: Wed, 27 Jan 2016 11:14:39 +0100
Message-Id: <1453889679-25588-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the mount phase is not finished, we can't update the sysfs files.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 6986886243bf..1ae146a8093c 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -804,6 +804,9 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	fs_devs = fs_info->fs_devices;
 	fsid_kobj = &fs_devs->fsid_kobj;
 
+	if (!fsid_kobj.state_initialized)
+		return;
+
 	/*
 	 * FIXME: this is too heavy to update just one value, ideally we'd like
 	 * to use sysfs_update_group but some refactoring is needed first.
-- 
1.8.4.5

