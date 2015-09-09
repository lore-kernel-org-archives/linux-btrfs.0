Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5778 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753108AbbIINeH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 09:34:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t89DXnS5017488
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 21:33:49 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: close all_devices for btrfs-image
Date: Wed, 9 Sep 2015 21:32:23 +0800
Message-ID: <fbf4df28568fcc87e5e6ae264eef0247eaa63a38.1441805445.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
References: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

devices opened by check_mounted() in main() should close before
exit of btrfs-image.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-image.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index c7681f4..78ae828 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2881,5 +2881,7 @@ out:
 		}
 	}
 
+	btrfs_close_all_devices();
+
 	return !!ret;
 }
-- 
1.8.5.1

