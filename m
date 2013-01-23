Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49248 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3AWIHA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 03:07:00 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 06/10] Btrfs-progs: add method to filter snapshots by parent uuid
Date: Wed, 23 Jan 2013 16:12:47 +0800
Message-Id: <1358928771-31960-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 6 ++++++
 btrfs-list.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/btrfs-list.c b/btrfs-list.c
index ec64a36..f5958cf 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1144,6 +1144,11 @@ static int filter_topid_equal(struct root_info *ri, u64 data)
 	return ri->top_id == data;
 }
 
+static int filter_by_parent(struct root_info *ri, u64 data)
+{
+	return !uuid_compare(ri->puuid, (u8 *)data);
+}
+
 static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_ROOTID]		= filter_by_rootid,
 	[BTRFS_LIST_FILTER_SNAPSHOT_ONLY]	= filter_snapshot,
@@ -1155,6 +1160,7 @@ static btrfs_list_filter_func all_filter_funcs[] = {
 	[BTRFS_LIST_FILTER_CGEN_LESS]		= filter_cgen_less,
 	[BTRFS_LIST_FILTER_CGEN_EQUAL]          = filter_cgen_equal,
 	[BTRFS_LIST_FILTER_TOPID_EQUAL]		= filter_topid_equal,
+	[BTRFS_LIST_FILTER_BY_PARENT]		= filter_by_parent,
 };
 
 struct btrfs_list_filter_set *btrfs_list_alloc_filter_set(void)
diff --git a/btrfs-list.h b/btrfs-list.h
index 580d4d1..cde7a3f 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -117,6 +117,7 @@ enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_CGEN_LESS,
 	BTRFS_LIST_FILTER_CGEN_MORE,
 	BTRFS_LIST_FILTER_TOPID_EQUAL,
+	BTRFS_LIST_FILTER_BY_PARENT,
 	BTRFS_LIST_FILTER_MAX,
 };
 
-- 
1.8.1.227.g44fe835

