Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:63358 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaDHLae (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 07:30:34 -0400
Message-ID: <5343DDCB.4010805@huawei.com>
Date: Tue, 8 Apr 2014 19:30:19 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <jbacik@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove useless ACL check
References: <1396955388-4189-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1396955388-4189-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

posix_acl_xattr_set() already does the check, and it's the only
way to feed in an ACL from userspace.
So the check here is useless, remove it.

Signed-off-by: zhang zhen <zhenzhang.zhang@huawei.com>
---
 fs/btrfs/acl.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index ff9b399..9a0124a 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -79,13 +79,6 @@ static int __btrfs_set_acl(struct btrfs_trans_handle *trans,
 	const char *name;
 	char *value = NULL;

-	if (acl) {
-		ret = posix_acl_valid(acl);
-		if (ret < 0)
-			return ret;
-		ret = 0;
-	}
-
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name = POSIX_ACL_XATTR_ACCESS;
-- 
1.6.0.2


.




