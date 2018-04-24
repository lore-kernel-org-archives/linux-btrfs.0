Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42243 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752193AbeDXFqx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 01:46:53 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 6A84249F19D1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:46:49 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in backref.c
Date: Tue, 24 Apr 2018 13:52:31 +0800
Message-ID: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no delayed ref in btrfs-progs, so remove related comments.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 backref.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/backref.c b/backref.c
index 27309e07a1e9..c144dbf060f2 100644
--- a/backref.c
+++ b/backref.c
@@ -155,19 +155,6 @@ static void init_pref_state(struct pref_state *prefstate)
  * - if you cannot add the parent or a correct key, then we will look into the
  *   block later to set a correct key
  *
- * delayed refs
- * ============
- *        backref type | shared | indirect | shared | indirect
- * information         |   tree |     tree |   data |     data
- * --------------------+--------+----------+--------+----------
- *      parent logical |    y   |     -    |    -   |     -
- *      key to resolve |    -   |     y    |    y   |     y
- *  tree block logical |    -   |     -    |    -   |     -
- *  root for resolving |    y   |     y    |    y   |     y
- *
- * - column 1:       we've the parent -> done
- * - column 2, 3, 4: we use the key to find the parent
- *
  * on disk refs (inline or keyed)
  * ==============================
  *        backref type | shared | indirect | shared | indirect
@@ -735,9 +722,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 }
 
 /*
- * this adds all existing backrefs (inline backrefs, backrefs and delayed
- * refs) for the given bytenr to the refs list, merges duplicates and resolves
- * indirect refs to their parent bytenr.
+ * this adds all existing backrefs (inline backrefs, backrefs for the given
+ * bytenr to the refs list, merges duplicates and resolves indirect refs to
+ * their parent bytenr.
  * When roots are found, they're added to the roots list
  *
  * FIXME some caching might speed things up
-- 
2.17.0



