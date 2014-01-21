Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbaAUR4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 12:56:08 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: sysfs: don't show reserved incompat feature
Date: Tue, 21 Jan 2014 18:56:06 +0100
Message-Id: <cef639e3c9d6b2acde2e353d0e402b3c5472ca97.1390326770.git.dsterba@suse.cz>
In-Reply-To: <cover.1390326770.git.dsterba@suse.cz>
References: <cover.1390326770.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The COMPRESS_LZOv2 incompat featue is currently not implemented, the bit
is only reserved, no point to list it in sysfs.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ba94b277e98d..1a893860d66b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -198,7 +198,6 @@ BTRFS_FEAT_ATTR_INCOMPAT(mixed_backref, MIXED_BACKREF);
 BTRFS_FEAT_ATTR_INCOMPAT(default_subvol, DEFAULT_SUBVOL);
 BTRFS_FEAT_ATTR_INCOMPAT(mixed_groups, MIXED_GROUPS);
 BTRFS_FEAT_ATTR_INCOMPAT(compress_lzo, COMPRESS_LZO);
-BTRFS_FEAT_ATTR_INCOMPAT(compress_lzov2, COMPRESS_LZOv2);
 BTRFS_FEAT_ATTR_INCOMPAT(big_metadata, BIG_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
 BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
@@ -209,7 +208,6 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(default_subvol),
 	BTRFS_FEAT_ATTR_PTR(mixed_groups),
 	BTRFS_FEAT_ATTR_PTR(compress_lzo),
-	BTRFS_FEAT_ATTR_PTR(compress_lzov2),
 	BTRFS_FEAT_ATTR_PTR(big_metadata),
 	BTRFS_FEAT_ATTR_PTR(extended_iref),
 	BTRFS_FEAT_ATTR_PTR(raid56),
-- 
1.7.9

