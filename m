From: Jim Meyering <jim@meyering.net>
Subject: disk-io.c (open_ctree): avoid leaks
Date: Tue, 09 Sep 2008 16:40:28 +0200
Message-ID: <87y7211ixv.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

These two variables (chunk_root and dev_root) that were not
tested for failed allocation weren't freed-upon-failure either:

changeset:   709:c40da2ab8c03
tag:         tip
user:        Jim Meyering <meyering@redhat.com>
date:        Tue Sep 09 16:35:47 2008 +0200
files:       disk-io.c
description:
disk-io.c (open_ctree): avoid leaks


diff --git a/disk-io.c b/disk-io.c
--- a/disk-io.c
+++ b/disk-io.c
@@ -1655,6 +1655,8 @@
 	bdi_destroy(&fs_info->bdi);
 #endif
 	kfree(fs_info);
+	kfree(chunk_root);
+	kfree(dev_root);
 	return ERR_PTR(err);
 }
 

