Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752436AbdFMJT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 18/19] btrfs-progs: Remove btrfs_read_super_device as there is no implementation
Date: Tue, 13 Jun 2017 17:19:34 +0800
Message-ID: <20170613091935.23277-19-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/volumes.h b/volumes.h
index 0f82281f..68bd98ae 100644
--- a/volumes.h
+++ b/volumes.h
@@ -212,7 +212,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *extent_root, u64 *start,
 			   u64 num_bytes, u64 type, int convert);
-int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       int flags);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
-- 
2.13.1



