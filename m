Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755255AbbB0I0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8PovX019932
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/7] btrfs-progs: Add stack get/set functions for btrfs_qgroup_status_item.
Date: Fri, 27 Feb 2015 16:26:37 +0800
Message-ID: <1425025599-30048-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This provides the basis for later qgroup related changes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ctree.h b/ctree.h
index 1914a70..bf29e85 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2079,6 +2079,15 @@ BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
 BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
 		   scan, 64);
 
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_version,
+			 struct btrfs_qgroup_status_item, version, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_generation,
+			 struct btrfs_qgroup_status_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_flags,
+			 struct btrfs_qgroup_status_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_status_scan,
+			 struct btrfs_qgroup_status_item, scan, 64);
+
 /* btrfs_qgroup_info_item */
 BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
 		   generation, 64);
-- 
2.3.0

