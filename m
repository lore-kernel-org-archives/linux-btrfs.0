Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53186 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaJOXOt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:14:49 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so2446582wgh.33
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:14:48 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs-progs: check read extent errors when mapping
Date: Wed, 15 Oct 2014 16:14:19 -0700
Message-Id: <1413414861-28097-3-git-send-email-zab@zabbo.net>
In-Reply-To: <1413414861-28097-1-git-send-email-zab@zabbo.net>
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

coverity barked out a warning that btrfs-map-logical was storing but
ignoring errors from read_extent_from_disk().   So don't ignore 'em.  I
made extent reading errors fatal to match the fatal errors from mapping
mirrors above.

And while we're at it have read_extent_from_disk() return -errno pread
errors instead of -EIO or -1 (-EPERM).  The only other caller who tests
errors clobbers them with -EIO.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 btrfs-map-logical.c | 12 +++++++++++-
 extent_io.c         |  4 +++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 6b475fc..47d1104 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -76,8 +76,18 @@ static struct extent_buffer * debug_read_block(struct btrfs_root *root,
 			(unsigned long long)eb->dev_bytenr, device->name);
 		kfree(multi);
 
-		if (!copy || mirror_num == copy)
+		if (!copy || mirror_num == copy) {
 			ret = read_extent_from_disk(eb, 0, eb->len);
+			if (ret) {
+				fprintf(info_file,
+					"Error: failed to read extent: mirror %d logical %llu: %s\n",
+					mirror_num, (unsigned long long)eb->start,
+					strerror(-ret));
+				free_extent_buffer(eb);
+				eb = NULL;
+				break;
+			}
+		}
 
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      eb->start, eb->len);
diff --git a/extent_io.c b/extent_io.c
index 425af8a..5186e89 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -647,8 +647,10 @@ int read_extent_from_disk(struct extent_buffer *eb,
 {
 	int ret;
 	ret = pread(eb->fd, eb->data + offset, len, eb->dev_bytenr);
-	if (ret < 0)
+	if (ret < 0) {
+		ret = -errno;
 		goto out;
+	}
 	if (ret != len) {
 		ret = -EIO;
 		goto out;
-- 
1.9.3

