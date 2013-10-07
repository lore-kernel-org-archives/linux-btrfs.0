Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3JGVnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:17 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhHWd003431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:17 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/12] btrfs-progs: don't leak path in verify_space_cache
Date: Mon,  7 Oct 2013 14:43:01 -0700
Message-Id: <1381182185-10896-9-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-check.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ebba58e..b6035d7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3228,13 +3228,13 @@ static int verify_space_cache(struct btrfs_root *root,
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
-		return ret;
+		goto out;
 	ret = 0;
 	while (1) {
 		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				return ret;
+				goto out;
 			if (ret > 0) {
 				ret = 0;
 				break;
@@ -3274,6 +3274,8 @@ static int verify_space_cache(struct btrfs_root *root,
 		ret = check_cache_range(root, cache, last,
 					cache->key.objectid +
 					cache->key.offset - last);
+
+out:
 	btrfs_free_path(path);
 
 	if (!ret &&
-- 
1.7.11.7

