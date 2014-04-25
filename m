Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25810 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaDYKoP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:44:15 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: set string end sing '\0' for property
Date: Fri, 25 Apr 2014 18:44:03 +0800
Message-Id: <1398422643-6741-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
References: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Set string "xattr_name" 's end with '\0' so that it won't be
violated in memory.

With this fix, xfstest/btrfs/048 can pass on my box.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: avoid buffer overflow of malloc().

 props.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/props.c b/props.c
index 9ff63ca..cc87454 100644
--- a/props.c
+++ b/props.c
@@ -131,13 +131,14 @@ static int prop_compression(enum prop_object_type type,
 		goto out;
 	}
 
-	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name));
+	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
 	if (!xattr_name) {
 		ret = -ENOMEM;
 		goto out;
 	}
 	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
 	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
 
 	if (value)
 		sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
-- 
1.7.7

