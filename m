Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28975 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933433AbcJRAfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 20:35:50 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9I0Zn7v022143
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u9I0ZnBE031327
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:49 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u9I0ZnnR027403
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 00:35:49 GMT
From: Divya Indi <divya.indi@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: ashish.samant@oracle.com, bo.li.liu@oracle.com
Subject: [PATCH 1/3] btrfs-progs: Generic functions to retrieve chunks and their bg info
Date: Mon, 17 Oct 2016 17:35:13 -0700
Message-Id: <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
In-Reply-To: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An efficient alternative to retrieving block groups:
get_chunks(): Walk the chunk tree to retrieve the chunks.
get_bg_info(): For each retrieved chunk, lookup an exact match of block
group in the extent tree.

Signed-off-by: Divya Indi <divya.indi@oracle.com>
Reviewed-by: Ashish Samant <ashish.samant@oracle.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-inspect.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 4b7cea0..f435ea9 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -81,6 +81,72 @@ out:
 	return !!ret;
 }
 
+static void bg_flags_to_str(u64 flags, char *ret)
+{
+	int empty = 1;
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+		empty = 0;
+		strcpy(ret, "DATA");
+	}
+	if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+		if (!empty)
+			strcat(ret, "|");
+		strcat(ret, "METADATA");
+	}
+	if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+		if (!empty)
+			strcat(ret, "|");
+		strcat(ret, "SYSTEM");
+	}
+}
+
+/* Walking through the chunk tree to retrieve chunks. */
+
+static int get_chunks(int fd, struct btrfs_ioctl_search_args *chunk_args)
+{
+	struct btrfs_ioctl_search_key *sk;
+	int ret;
+	int e;
+
+	sk = &chunk_args->key;
+
+	sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
+	sk->min_objectid = sk->max_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	sk->max_type = sk->min_type = BTRFS_CHUNK_ITEM_KEY;
+	sk->nr_items = 4096;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, chunk_args);
+	e = errno;
+	if (ret < 0) {
+		fprintf(stderr, "ret %d error '%s'\n", ret,
+				strerror(e));
+	}
+	return ret;
+}
+
+/* Given the objectid, find the block group item in the extent tree */
+static int get_bg_info(int fd, struct btrfs_ioctl_search_args *bg_args,
+		       u64 objectid, unsigned long length)
+{
+	struct btrfs_ioctl_search_key *bg_sk;
+	int ret;
+	int e;
+
+	bg_sk = &bg_args->key;
+
+	bg_sk->min_objectid = bg_sk->max_objectid = objectid;
+	bg_sk->nr_items = 1;
+	bg_sk->min_offset = bg_sk->max_offset = length;
+
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, bg_args);
+	e = errno;
+	if (ret < 0) {
+		fprintf(stderr, "ret %d error '%s'\n", ret,
+				strerror(e));
+	}
+	return ret;
+}
 static const char * const cmd_inspect_inode_resolve_usage[] = {
 	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
 	"Get file system paths for the given inode",
-- 
1.7.1

