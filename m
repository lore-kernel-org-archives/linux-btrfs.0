Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:11577 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeDQGxb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 02:53:31 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 0CEF2AC00C7
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 15:53:25 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 64185BD66E1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 15:53:24 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: libbtrfsutil: python: use top=0 as default value
 in SubvolumeIterator
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2bdae96a-ef14-2a86-ccc0-5eaf98c87fd2@jp.fujitsu.com>
Date: Tue, 17 Apr 2018 15:53:06 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Document of SubvolumeIterator says:
  SubvolumeIterator(path, top=0, info=False, post_order=False)
    -> new subvolume iterator
  ...
  top -- if not zero, instead of only listing subvolumes beneath the
  given path, list subvolumes beneath the subvolume with this ID; passing
  BTRFS_FS_TREE_OBJECTID (5) here lists all subvolumes. The subvolumes
  are listed relative to the subvolume with this ID.
  ...

So, change the default value of @top from 5 to 0 accordingly.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/python/subvolume.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 069e606b..6ecde1f6 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -525,7 +525,7 @@ static int SubvolumeIterator_init(SubvolumeIterator *self, PyObject *args,
 	static char *keywords[] = {"path", "top", "info", "post_order", NULL};
 	struct path_arg path = {.allow_fd = true};
 	enum btrfs_util_error err;
-	unsigned long long top = 5;
+	unsigned long long top = 0;
 	int info = 0;
 	int post_order = 0;
 	int flags = 0;
-- 
2.14.3


