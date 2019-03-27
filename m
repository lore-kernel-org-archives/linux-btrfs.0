Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A75C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 07:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DF32075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 07:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfC0HZI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 03:25:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:39668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbfC0HZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 03:25:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A68E8ADC7
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 07:25:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH URGENT 1/2] btrfs-progs: disk-io: Make super block write error more easy to read
Date:   Wed, 27 Mar 2019 15:24:59 +0800
Message-Id: <20190327072500.11156-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327072500.11156-1-wqu@suse.com>
References: <20190327072500.11156-1-wqu@suse.com>
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
ERROR: failed to write super block: I/O error
ERROR: failed to write super block for devid 1

This provides the basis for later super block flush error handling.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 797b9b79ea3c..238b1821be14 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1599,8 +1599,12 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE,
 				fs_info->super_bytenr);
-		if (ret != BTRFS_SUPER_INFO_SIZE)
+		if (ret != BTRFS_SUPER_INFO_SIZE) {
+			errno = EIO;
+			ret = -errno;
+			error("failed to write super block: %m");
 			goto write_err;
+		}
 		return 0;
 	}
 
@@ -1622,17 +1626,18 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
 		 */
 		ret = pwrite64(device->fd, fs_info->super_copy,
 				BTRFS_SUPER_INFO_SIZE, bytenr);
-		if (ret != BTRFS_SUPER_INFO_SIZE)
+		if (ret != BTRFS_SUPER_INFO_SIZE) {
+			errno = EIO;
+			ret = -errno;
+			error("failed to write super block %i: %m", i);
 			goto write_err;
+		}
 	}
 
 	return 0;
 
 write_err:
-	if (ret > 0)
-		fprintf(stderr, "WARNING: failed to write all sb data\n");
-	else
-		fprintf(stderr, "WARNING: failed to write sb: %m\n");
+	error("failed to write super block for devid %llu", device->devid);
 	return ret;
 }
 
-- 
2.21.0

