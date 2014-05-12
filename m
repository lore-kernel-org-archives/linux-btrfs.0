Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbaELBim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 21:38:42 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4C1ccag026121
	for <linux-btrfs@vger.kernel.org>; Mon, 12 May 2014 09:38:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Remove unneeded assert in find_good_parent().
Date: Mon, 12 May 2014 09:39:42 +0800
Message-ID: <1399858782-15109-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_good_parent() uses assert to deal with the problem that clone
source's parent can't be found.
But in fact the assert is somewhat overkilled since subvol_uuid_search()
has enough error messages for debug and caller of find_good_parent() can
handle the problems in find_good_parent(), so the assert can be removed
without any problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-send.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cmds-send.c b/cmds-send.c
index ff17092..9a73b32 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -132,7 +132,10 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 		parent2 = subvol_uuid_search(&s->sus, s->clone_sources[i], NULL,
 				0, NULL, subvol_search_by_root_id);
 
-		assert(parent2);
+		if (!parent2) {
+			ret = -ENOENT;
+			goto out;
+		}
 		tmp = parent2->ctransid - parent->ctransid;
 		if (tmp < 0)
 			tmp *= -1;
-- 
1.9.2

