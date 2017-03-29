Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35163 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdC2Eha (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 00:37:30 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Wed, 29 Mar 2017 06:39:40 +0200
Message-Id: <20170329043940.23655-2-kilobyte@angband.pl>
In-Reply-To: <20170329043940.23655-1-kilobyte@angband.pl>
References: <20170329043940.23655-1-kilobyte@angband.pl>
Subject: [PATCH 2/2] btrfs: clear the RAID5/6 incompat flag once no longer needed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no known taint on a filesystem that was RAID5/6 once but has been
since converted to something non-experimental.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/disk-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a4c3e6628ec1..c720a7bc1b15 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3089,6 +3089,8 @@ int open_ctree(struct super_block *sb,
 	    BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		btrfs_alert(fs_info,
 		"btrfs RAID5/6 is EXPERIMENTAL and has known data-loss bugs");
+	} else {
+		btrfs_clear_fs_incompat(fs_info, RAID56);
 	}
 
 	/*
-- 
2.11.0

