Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33675 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbDPXdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 19:33:49 -0400
Received: by qcrf4 with SMTP id f4so15599401qcr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2015 16:33:49 -0700 (PDT)
Received: from ?IPv6:2001:470:8:414::10? (wolf.welp.gs. [2001:470:8:414::10])
        by mx.google.com with ESMTPSA id n13sm6742373qkh.8.2015.04.16.16.33.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Apr 2015 16:33:48 -0700 (PDT)
Message-ID: <553046DA.7090809@gmail.com>
Date: Thu, 16 Apr 2015 19:33:46 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: have restore set atime/mtime
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The inode is already found, use the data and make restore friendlier.

Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
---
 cmds-restore.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index d2fc951..95ac487 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -567,12 +567,22 @@ static int copy_file(struct btrfs_root *root, int
fd, struct btrfs_key *key,
 		fprintf(stderr, "Ran out of memory\n");
 		return -ENOMEM;
 	}
+	struct timespec times[2];
+	int times_ok=0;

 	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
 	if (ret == 0) {
 		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_inode_item);
 		found_size = btrfs_inode_size(path->nodes[0], inode_item);
+		struct btrfs_timespec bts;
+		read_eb_member(path->nodes[0], inode_item, struct btrfs_inode_item,
atime, &bts);
+		times[0].tv_sec=bts.sec;
+		times[0].tv_nsec=bts.nsec;
+		read_eb_member(path->nodes[0], inode_item, struct btrfs_inode_item,
atime, &bts);
+		times[1].tv_sec=bts.sec;
+		times[1].tv_nsec=bts.nsec;
+		times_ok=1;
 	}
 	btrfs_release_path(path);

@@ -680,6 +690,8 @@ set_size:
 		if (ret)
 			return ret;
 	}
+	if (times_ok)
+		futimens(fd, times);
 	return 0;
 }

-- 
2.1.4

