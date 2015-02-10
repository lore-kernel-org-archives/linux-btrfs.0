Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42012 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754980AbbBJK1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:24 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQbci000925
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:37 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: qgroup: return EINVAL if level of parent is not higher than child's.
Date: Tue, 10 Feb 2015 18:24:03 +0800
Message-ID: <1423563845-9103-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we create a subvol inheriting a qgroup, we need to check the level
of them. Otherwise, there is a chance a qgroup can inherit another qgroup
at the same level.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5a1463d..d519055 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2244,6 +2244,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 				ret = -EINVAL;
 				goto out;
 			}
+
+			if ((srcgroup->qgroupid >> 48) <= (objectid >> 48)) {
+				ret = -EINVAL;
+				goto out;
+			}
 			++i_qgroups;
 		}
 	}
-- 
1.8.4.2

