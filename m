Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532Ab3BTAzS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 19:55:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1K0tI3O026125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 19:55:18 -0500
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1K0tItF022440
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 19:55:18 -0500
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: define BTRFS_MAGIC as a u64 value
Date: Tue, 19 Feb 2013 16:55:13 -0800
Message-Id: <1361321713-20936-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

super.magic is an le64 but it's treated as an unterminated string when
compared against BTRFS_MAGIC which is defined as a string.  Instead
define BTRFS_MAGIC as a normal hex value and use endian helpers to
compare it to the super's magic.

I tested this by mounting an fs made before the change and made sure
that it didn't introduce sparse errors.  This matches a similar cleanup
that is pending in btrfs-progs.  David Sterba pointed out that we should
fix the kernel side as well :).

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/check-integrity.c | 3 +--
 fs/btrfs/ctree.h           | 2 +-
 fs/btrfs/disk-io.c         | 6 ++----
 fs/btrfs/volumes.c         | 3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 11d47bf..18af6f4 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -813,8 +813,7 @@ static int btrfsic_process_superblock_dev_mirror(
 	    (bh->b_data + (dev_bytenr & 4095));
 
 	if (btrfs_super_bytenr(super_tmp) != dev_bytenr ||
-	    strncmp((char *)(&(super_tmp->magic)), BTRFS_MAGIC,
-		    sizeof(super_tmp->magic)) ||
+	    super_tmp->magic != cpu_to_le64(BTRFS_MAGIC) ||
 	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE) ||
 	    btrfs_super_nodesize(super_tmp) != state->metablock_size ||
 	    btrfs_super_leafsize(super_tmp) != state->metablock_size ||
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9f72ec8..8d88d1e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -46,7 +46,7 @@ extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
 
-#define BTRFS_MAGIC "_BHRfS_M"
+#define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
 #define BTRFS_MAX_MIRRORS 3
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6baa77d..1d1ba22 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2407,8 +2407,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
-		    sizeof(disk_super->magic))) {
+	if (disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
 		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2815,8 +2814,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 
 		super = (struct btrfs_super_block *)bh->b_data;
 		if (btrfs_super_bytenr(super) != bytenr ||
-		    strncmp((char *)(&super->magic), BTRFS_MAGIC,
-			    sizeof(super->magic))) {
+		    super->magic != cpu_to_le64(BTRFS_MAGIC)) {
 			brelse(bh);
 			continue;
 		}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5670765..72b1cf1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -855,8 +855,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
 
 	if (btrfs_super_bytenr(disk_super) != bytenr ||
-	    strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
-		    sizeof(disk_super->magic)))
+	    disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
 		goto error_unmap;
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
-- 
1.7.11.7

