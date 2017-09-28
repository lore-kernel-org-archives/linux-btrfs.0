Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:55368 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdI1UzD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 16:55:03 -0400
Received: by mail-qt0-f196.google.com with SMTP id x54so3424816qth.12
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 13:55:02 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com, dsterba@suse.cz,
        jeffm@suse.com
Subject: [PATCH] btrfs-progs: fix invalid assert in backref.c
Date: Thu, 28 Sep 2017 16:55:00 -0400
Message-Id: <1506632100-6293-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This should be verify'ing that we have an empty key, not that we have a
filled out key.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
Dave this is on top of your ext/jeffm/extent-cache branch and fixes the segfault
you reported.

 backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/backref.c b/backref.c
index 8fc0fae779f2..8615f6b8677a 100644
--- a/backref.c
+++ b/backref.c
@@ -465,7 +465,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 
 		ASSERT(ref->root_id);
 		ASSERT(!ref->parent);
-		ASSERT(ref->key_for_search.type);
+		ASSERT(!ref->key_for_search.type);
 		BUG_ON(!ref->wanted_disk_byte);
 		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0);
 		if (!extent_buffer_uptodate(eb)) {
-- 
2.7.4

