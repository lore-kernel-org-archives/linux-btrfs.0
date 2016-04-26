Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbcDZOdC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:33:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B080CACCA
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:32:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs: add read-only check to sysfs handler of features
Date: Tue, 26 Apr 2016 16:32:49 +0200
Message-Id: <b35d435987ef7e1374f4144d9488dc87eb248486.1461681045.git.dsterba@suse.com>
In-Reply-To: <cover.1461681045.git.dsterba@suse.com>
References: <cover.1461681045.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

We don't want to trigger the change on a read-only filesystem, similar
to what the label handler does.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 539e7b5e3f86..6a6bb600b1ff 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -120,6 +120,9 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	ret = kstrtoul(skip_spaces(buf), 0, &val);
 	if (ret)
 		return ret;
-- 
2.7.1

