Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24881 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3AJLfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:05 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ35x030838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:04 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ38I001580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:03 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ37a022408
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:03 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/11] Btrfs-progs: add method to filter snapshots by parent uuid
Date: Thu, 10 Jan 2013 19:41:19 +0800
Message-Id: <1357818083-15531-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

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

