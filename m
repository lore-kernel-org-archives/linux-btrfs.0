Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB04BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BF72075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732159AbfC0JrF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:47:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:56698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfC0JrF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 05:47:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 976AEACBC
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 09:47:04 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH URGENT v1.1 1/2] btrfs-progs: disk-io: Make super block write error easier to read
Date:   Wed, 27 Mar 2019 17:46:51 +0800
Message-Id: <20190327094652.16078-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327094652.16078-1-wqu@suse.com>
References: <20190327094652.16078-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When we failed to write super blocks, we just output something like:
  WARNING: failed to write sb: I/O error
Or
  WARNING: failed to write all sb data

There is no info about which device failed and there are two different
error message for the same write error.

This patch will change it to something more detailed:
ERROR: failed to write super block for devid 1: write error: I/O error

This provides the basis for later super block flush error handling.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 797b9b79ea3c..f7fb7026cd94 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1599,8 +1599,13 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE,
 				fs_info->super_bytenr);
-		if (ret != BTRFS_SUPER_INFO_SIZE)
-			goto write_err;
+		if (ret != BTRFS_SUPER_INFO_SIZE) {
+			errno = EIO;
+			error(
+		"failed to write super block for devid %llu: write error: %m",
+				device->devid);
+			return -EIO;
+		}
 		return 0;
 	}
 
@@ -1622,18 +1627,16 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		 */
 		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE, bytenr);
-		if (ret != BTRFS_SUPER_INFO_SIZE)
-			goto write_err;
+		if (ret != BTRFS_SUPER_INFO_SIZE) {
+			errno = EIO;
+			error(
+		"failed to write super block for devid %llu: write error: %m",
+				device->devid);
+			return -errno;
+		}
 	}
 
 	return 0;
-
-write_err:
-	if (ret > 0)
-		fprintf(stderr, "WARNING: failed to write all sb data\n");
-	else
-		fprintf(stderr, "WARNING: failed to write sb: %m\n");
-	return ret;
 }
 
 int write_all_supers(struct btrfs_fs_info *fs_info)
-- 
2.21.0

