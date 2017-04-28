Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:34510 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968163AbdD1JMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:12:38 -0400
Received: by mail-wr0-f178.google.com with SMTP id l9so30206875wre.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 02:12:37 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id c5sm3386813wre.60.2017.04.28.02.12.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 02:12:36 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 1/3] Disambiguate between cases where add_tree_backref fails 
Message-Id: <A5B22E8A-045F-4214-A64F-622AB47CDCF3@redhat.com>
Date: Fri, 28 Apr 2017 11:12:35 +0200
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See https://bugzilla.redhat.com/show_bug.cgi?id=1435567 for an example
where the message occurs,

Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>
---
 cmds-check.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efb..2d3ebc1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6832,14 +6832,14 @@ static int process_extent_item(struct btrfs_root *root,
 			ret = add_tree_backref(extent_cache, key.objectid,
 					0, offset, 0);
 			if (ret < 0)
-				error("add_tree_backref failed: %s",
+				error("add_tree_backref failed (extent items tree block): %s",
 				      strerror(-ret));
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			ret = add_tree_backref(extent_cache, key.objectid,
 					offset, 0, 0);
 			if (ret < 0)
-				error("add_tree_backref failed: %s",
+				error("add_tree_backref failed (extent items shared block): %s",
 				      strerror(-ret));
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
@@ -7753,7 +7753,7 @@ static int run_next_block(struct btrfs_root *root,
 				ret = add_tree_backref(extent_cache,
 						key.objectid, 0, key.offset, 0);
 				if (ret < 0)
-					error("add_tree_backref failed: %s",
+					error("add_tree_backref failed (leaf tree block): %s",
 					      strerror(-ret));
 				continue;
 			}
@@ -7761,7 +7761,7 @@ static int run_next_block(struct btrfs_root *root,
 				ret = add_tree_backref(extent_cache,
 						key.objectid, key.offset, 0, 0);
 				if (ret < 0)
-					error("add_tree_backref failed: %s",
+					error("add_tree_backref failed (leaf shared block): %s",
 					      strerror(-ret));
 				continue;
 			}
@@ -7866,7 +7866,7 @@ static int run_next_block(struct btrfs_root *root,
 			ret = add_tree_backref(extent_cache, ptr, parent,
 					owner, 1);
 			if (ret < 0) {
-				error("add_tree_backref failed: %s",
+				error("add_tree_backref failed (non-leaf block): %s",
 				      strerror(-ret));
 				continue;
 			}
-- 
2.9.3

