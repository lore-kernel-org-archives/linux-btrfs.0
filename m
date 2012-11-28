Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2K1Ko7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:44:59 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Arendt <admin@prnet.org>
Subject: [PATCH 1/2] Btrfs: skip adding an acl attribute if we don't have to
Date: Wed, 28 Nov 2012 18:43:11 +0800
Message-Id: <1354099392-2820-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the acl can be exactly represented in the traditional file
mode permission bits, we don't set another acl attribute.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/acl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 0c16e3d..e15d2b0 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -121,6 +121,8 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
 			ret = posix_acl_equiv_mode(acl, &inode->i_mode);
 			if (ret < 0)
 				return ret;
+			if (ret == 0)
+				acl = NULL;
 		}
 		ret = 0;
 		break;
-- 
1.7.7.6

