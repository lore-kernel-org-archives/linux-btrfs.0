Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbcDZOdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:33:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F0B3CACCA
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:33:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: add check to sysfs handler of label
Date: Tue, 26 Apr 2016 16:32:52 +0200
Message-Id: <c473c6e1d1f9f7e0f2adf6d35bc4a479c1de059a.1461681045.git.dsterba@suse.com>
In-Reply-To: <cover.1461681045.git.dsterba@suse.com>
References: <cover.1461681045.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a sanity check for the fs_info as we will dereference it, similar to
what the 'store features' handler does.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 6a6bb600b1ff..3d14618ce54b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -377,6 +377,9 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 	size_t p_len;
 
+	if (!fs_info)
+		return -EPERM;
+
 	if (fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-- 
2.7.1

