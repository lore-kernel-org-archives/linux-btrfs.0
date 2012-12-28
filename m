Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21174 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2L1DHA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:07:00 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36xCq021181
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:59 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36wJw017797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:59 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36wlH027298
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:58 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] Btrfs-progs: add method to filter snapshots by parent uuid
Date: Fri, 28 Dec 2012 11:13:01 +0800
Message-Id: <1356664382-24423-8-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |    6 ++++++
 btrfs-list.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 308b54c..efce966 100644
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
index f5dbd47..d71d2b0 100644
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
1.7.1

