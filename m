Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbcC2Vbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 17:31:49 -0400
From: Julio Montes <julio.montes@intel.com>
To: linux-btrfs@vger.kernel.org
Cc: Julio Montes <imc.coder@gmail.com>
Subject: [PATCH] btrfs-progs: fix unknown type name 'u64' in gccgo
Date: Tue, 29 Mar 2016 15:34:48 -0600
Message-Id: <1459287288-2942-1-git-send-email-julio.montes@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Julio Montes <imc.coder@gmail.com>

Signed-off-by: Julio Montes <imc.coder@gmail.com>
---
 ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index cab9ec2..7c80807 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -94,7 +94,7 @@ struct btrfs_ioctl_vol_args_v2 {
 	};
 	union {
 		char name[BTRFS_SUBVOL_NAME_MAX + 1];
-		u64 devid;
+		__u64 devid;
 	};
 };
 
-- 
2.1.0

