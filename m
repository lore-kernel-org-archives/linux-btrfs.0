Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CE3C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E9C20854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42E9C20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbeJEE0K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:10 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45758 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbeJEE0J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:09 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 2718B20395
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: fix ncopies raid_attr for RAID56
Date:   Thu,  4 Oct 2018 23:24:41 +0200
Message-Id: <20181004212443.26519-5-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

RAID5 and RAID6 profile store one copy of the data, not 2 or 3. These
values are not used anywhere by the way.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7045814fc98d..d82b3d735ebe 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -96,7 +96,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_min	= 2,
 		.tolerated_failures = 1,
 		.devs_increment	= 1,
-		.ncopies	= 2,
+		.ncopies	= 1,
 		.raid_name	= "raid5",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
@@ -108,7 +108,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_min	= 3,
 		.tolerated_failures = 2,
 		.devs_increment	= 1,
-		.ncopies	= 3,
+		.ncopies	= 1,
 		.raid_name	= "raid6",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
-- 
2.19.0.329.g76f2f5c1e3

