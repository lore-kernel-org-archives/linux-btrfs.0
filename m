Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D79C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F143220811
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 06:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfBEGxR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:53:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:53916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbfBEGxR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 01:53:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D868AFC7
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2019 06:53:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: Port kernel fs_devices::total_rw_bytes to btrfs-progs
Date:   Tue,  5 Feb 2019 14:53:11 +0800
Message-Id: <20190205065312.19743-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Unlike kernel, btrfs-progs doesn't (yet) support devices grow/shrink,
the port only needs to handle open_ctree() time initialization (at
read_one_dev()), and btrfs_add_device() used for mkfs.

This provide the basis for incoming unification of chunk allocator
behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 3 +++
 volumes.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/volumes.c b/volumes.c
index 2c6aaf42c5fb..2611a932c01c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -744,6 +744,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, fs_info->fs_devices->metadata_uuid, ptr,
 			    BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
+	fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 	ret = 0;
 
 out:
@@ -2060,6 +2061,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	fill_device_from_item(leaf, dev_item, device);
 	device->dev_root = fs_info->dev_root;
+	fs_info->fs_devices->total_rw_bytes +=
+		btrfs_device_total_bytes(leaf, dev_item);
 	return ret;
 }
 
diff --git a/volumes.h b/volumes.h
index e30bcef7dba5..dbe9d3dea647 100644
--- a/volumes.h
+++ b/volumes.h
@@ -77,6 +77,9 @@ struct btrfs_fs_devices {
 	u64 latest_devid;
 	u64 latest_trans;
 	u64 lowest_devid;
+
+	u64 total_rw_bytes;
+
 	int latest_bdev;
 	int lowest_bdev;
 	struct list_head devices;
-- 
2.20.1

