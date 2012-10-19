Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2JSGU0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:26 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9J6KO43006249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:25 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9J6KOXU009730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:24 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9J6KO60012314
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 01:20:24 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs-progs: add method to filter snapshots by parent uuid
Date: Fri, 19 Oct 2012 14:23:56 +0800
Message-Id: <1350627837-27639-4-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |    6 ++++++
 btrfs-list.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 462e049..369500d 100644
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
index 64d89e1..a18a314 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -118,6 +118,7 @@ enum btrfs_list_filter_enum {
 	BTRFS_LIST_FILTER_CGEN_LESS,
 	BTRFS_LIST_FILTER_CGEN_MORE,
 	BTRFS_LIST_FILTER_TOPID_EQUAL,
+	BTRFS_LIST_FILTER_BY_PARENT,
 	BTRFS_LIST_FILTER_MAX,
 };
 
-- 
1.7.1

