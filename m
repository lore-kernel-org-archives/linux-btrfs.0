Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:47164 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753102AbdK2NsV (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 08:48:21 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: convert: Fix a bug in rollback check which overwrite return value
Date: Wed, 29 Nov 2017 21:48:05 +0800
Message-Id: <20171129134806.32324-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 1170ac307900 ("btrfs-progs: convert: Introduce function to check if
convert image is able to be rolled back") reworked rollback check
condition, by checking 1:1 mapping of each file extent.

The idea itself has nothing wrong, but error handler is not implemented
correctly, which over writes the return value and always try to rollback
the fs even it fails to pass the check.

Fix it by correctly return the error before rollback the fs.

Fixes: 1170ac307900 ("btrfs-progs: convert: Introduce function to check if convert image is able to be rolled back")
Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index af2855316fee..89f9261172ca 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1443,6 +1443,8 @@ next:
 		}
 	}
 	btrfs_release_path(&path);
+	if (ret)
+		return ret;
 	/*
 	 * For HOLES mode (without NO_HOLES), we must ensure file extents
 	 * cover the whole range of the image
-- 
2.15.0

