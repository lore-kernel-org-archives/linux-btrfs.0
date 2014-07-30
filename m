Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53477 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaG3H0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 03:26:45 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 348693EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 16:26:44 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 38125AC068A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 16:26:43 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 98B8D1DB804F
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 16:26:40 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id F0B9D3285DA
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 16:26:39 +0900 (JST)
Message-ID: <53D89E28.7040100@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 16:26:32 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: remove unnecessary NULL check after get_df()
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

If get_df() returns 0, "sargs" surely points to malloc'ed region.
So NULL check of sargs is not necessary.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bf87bbe..38011e5 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -201,7 +201,7 @@ static int cmd_filesystem_df(int argc, char **argv)
        }
        ret = get_df(fd, &sargs);
 
-       if (!ret && sargs) {
+       if (ret == 0) {
                print_df(sargs);
                free(sargs);
        } else {
-- 
1.9.3

