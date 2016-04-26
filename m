Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbcDZOdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:33:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 382BFACCA
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:33:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: sysfs: protect reading label by lock
Date: Tue, 26 Apr 2016 16:32:55 +0200
Message-Id: <f7692e58a8e6a7bd28160adfc664e9e8ccfa6fcc.1461681045.git.dsterba@suse.com>
In-Reply-To: <cover.1461681045.git.dsterba@suse.com>
References: <cover.1461681045.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the label setting ioctl races with sysfs label handler, we could get
mixed result in the output, part old part new. We should either get the
old or new label. The chances to hit this race are low.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3d14618ce54b..7b0da1dcb6df 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -367,7 +367,12 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 	char *label = fs_info->super_copy->label;
-	return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
+
+	spin_lock(&fs_info->super_lock);
+	snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
+	spin_unlock(&fs_info->super_lock);
+
+	return buf;
 }
 
 static ssize_t btrfs_label_store(struct kobject *kobj,
-- 
2.7.1

