Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbbAWRwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 12:52:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A22C7ACE9
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 17:52:13 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3.19-rc] btrfs: add read-only check to sysfs handler of features
Date: Fri, 23 Jan 2015 18:52:11 +0100
Message-Id: <1422035531-22930-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't want to trigger the change on a read-only filesystem, similar
to what the label handler does.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

This emerged during the discussions about pending changes problems.

 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 92db3f648df4..00b9c46e351c 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -119,6 +119,9 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	ret = kstrtoul(skip_spaces(buf), 0, &val);
 	if (ret)
 		return ret;
-- 
2.1.3

