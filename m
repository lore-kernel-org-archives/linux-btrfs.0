Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbcA0NGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 08:06:44 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DFB49ADB9
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 13:06:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: sysfs: check initialization state before updating features
Date: Wed, 27 Jan 2016 14:06:29 +0100
Message-Id: <1453899989-1710-1-git-send-email-dsterba@suse.com>
In-Reply-To: <1453889679-25588-1-git-send-email-dsterba@suse.com>
References: <1453889679-25588-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the mount phase is not finished, we can't update the sysfs files.

Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
v2: fix compilation error

 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 6986886243bf..539e7b5e3f86 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -804,6 +804,9 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	fs_devs = fs_info->fs_devices;
 	fsid_kobj = &fs_devs->fsid_kobj;
 
+	if (!fsid_kobj->state_initialized)
+		return;
+
 	/*
 	 * FIXME: this is too heavy to update just one value, ideally we'd like
 	 * to use sysfs_update_group but some refactoring is needed first.
-- 
1.8.4.5

