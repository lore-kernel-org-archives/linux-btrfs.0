Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632AbcAUScI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 13:32:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D58D0AC20
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 18:32:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: sysfs: fix typo in compat_ro attribute definition
Date: Thu, 21 Jan 2016 19:32:00 +0100
Message-Id: <ba2d084055fd3f67af120070f5620173efd867c8.1453400624.git.dsterba@suse.com>
In-Reply-To: <cover.1453400624.git.dsterba@suse.com>
References: <cover.1453400624.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 9c09522125a6..72408e2c4ea8 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -56,7 +56,7 @@ static struct btrfs_feature_attr btrfs_attr_##_name = {			     \
 #define BTRFS_FEAT_ATTR_COMPAT(name, feature) \
 	BTRFS_FEAT_ATTR(name, FEAT_COMPAT, BTRFS_FEATURE_COMPAT, feature)
 #define BTRFS_FEAT_ATTR_COMPAT_RO(name, feature) \
-	BTRFS_FEAT_ATTR(name, FEAT_COMPAT_RO, BTRFS_FEATURE_COMPAT, feature)
+	BTRFS_FEAT_ATTR(name, FEAT_COMPAT_RO, BTRFS_FEATURE_COMPAT_RO, feature)
 #define BTRFS_FEAT_ATTR_INCOMPAT(name, feature) \
 	BTRFS_FEAT_ATTR(name, FEAT_INCOMPAT, BTRFS_FEATURE_INCOMPAT, feature)
 
-- 
2.6.3

