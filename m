Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C04C432C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B2020674
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK0PLA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:11:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:54854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbfK0PLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Nov 2019 10:11:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACEEDAFB5;
        Wed, 27 Nov 2019 15:10:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A79A5DA733; Wed, 27 Nov 2019 16:10:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fix devs_max constraints for raid1c3 and raid1c4
Date:   Wed, 27 Nov 2019 16:10:54 +0100
Message-Id: <20191127151054.24199-1-dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The value 0 for devs_max means to spread the allocated chunks over all
available devices, eg. stripe for RAID0 or RAID5. This got mistakenly
copied to the RAID1C3/4 profiles. The intention is to have exactly 3 and
4 copies respectively.

Fixes: 47e6f7423b91 ("btrfs: add support for 3-copy replication (raid1c3)")
Fixes: 8d6fac0087e5 ("btrfs: add support for 4-copy replication (raid1c4)")
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d8e5560db285..a6d3f08bfff3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -61,7 +61,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID1C3] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
-		.devs_max	= 0,
+		.devs_max	= 3,
 		.devs_min	= 3,
 		.tolerated_failures = 2,
 		.devs_increment	= 3,
@@ -73,7 +73,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID1C4] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
-		.devs_max	= 0,
+		.devs_max	= 4,
 		.devs_min	= 4,
 		.tolerated_failures = 3,
 		.devs_increment	= 4,
-- 
2.24.0

