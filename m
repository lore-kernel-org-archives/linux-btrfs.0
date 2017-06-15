Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40205 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752072AbdFOMwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 08:52:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0C17BAD54
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 12:52:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Manually implement device_total_bytes getter/setter
Date: Thu, 15 Jun 2017 15:52:34 +0300
Message-Id: <1497531155-9703-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1497531155-9703-1-git-send-email-nborisov@suse.com>
References: <1497531155-9703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The device->total_bytes member needs to always be rounded down to sectorsize
so that it corresponds to the value of super->total_bytes. However, there are
multiple places where the setter is fed a value which is not rounded which
can cause a fs to be unmountable due to the check introduced in
99e3ecfcb9f4 ("Btrfs: add more validation checks for superblock")

This patch adds the necessary WARN_ON in the setter to catch future offenders.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0334452a7be1..c64b16a2b28d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1552,8 +1552,25 @@ static inline void btrfs_set_##name(type *s, u##bits val)		\
 	s->member = cpu_to_le##bits(val);				\
 }
 
+
+static inline u64 btrfs_device_total_bytes(struct extent_buffer *eb,
+					   struct btrfs_dev_item *s)
+{
+	BUILD_BUG_ON(sizeof(u64) !=
+		     sizeof(((struct btrfs_dev_item *)0))->total_bytes);
+	return btrfs_get_64(eb, s, offsetof(struct btrfs_dev_item, total_bytes));
+}
+static inline void btrfs_set_device_total_bytes(struct extent_buffer *eb,
+						struct btrfs_dev_item *s,
+						u64 val)
+{
+	BUILD_BUG_ON(sizeof(u64) != sizeof(((struct btrfs_dev_item *)0))->total_bytes);
+	WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize));
+	btrfs_set_64(eb, s, offsetof(struct btrfs_dev_item, total_bytes), val);
+}
+
+
 BTRFS_SETGET_FUNCS(device_type, struct btrfs_dev_item, type, 64);
-BTRFS_SETGET_FUNCS(device_total_bytes, struct btrfs_dev_item, total_bytes, 64);
 BTRFS_SETGET_FUNCS(device_bytes_used, struct btrfs_dev_item, bytes_used, 64);
 BTRFS_SETGET_FUNCS(device_io_align, struct btrfs_dev_item, io_align, 32);
 BTRFS_SETGET_FUNCS(device_io_width, struct btrfs_dev_item, io_width, 32);
-- 
2.7.4

