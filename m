Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaDYG2f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 02:28:35 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs-progs: set string end sing '\0' for property
Date: Fri, 25 Apr 2014 14:28:22 +0800
Message-Id: <1398407303-10900-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Set string "xattr_name" 's end with '\0' so that it won't be
violated in memory.

With this fix, xfstest/btrfs/048 can pass on my box.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 props.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/props.c b/props.c
index 4d0aeea..53223a3 100644
--- a/props.c
+++ b/props.c
@@ -135,6 +135,7 @@ static int prop_compression(enum prop_object_type type,
 	}
 	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
 	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
 
 	if (value)
 		sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
-- 
1.8.2.1

