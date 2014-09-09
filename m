Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48796 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaIICJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 22:09:13 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D7E703EE0BB
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Sep 2014 11:09:11 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A6B2FAC058D
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Sep 2014 11:09:10 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 585BA1DB803A
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Sep 2014 11:09:10 +0900 (JST)
Received: from G01JPEXCHYT18.g01.fujitsu.local (G01JPEXCHYT18.g01.fujitsu.local [10.128.194.57])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id A70146D64C0
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Sep 2014 11:09:08 +0900 (JST)
Message-ID: <540E613C.5010401@jp.fujitsu.com>
Date: Tue, 9 Sep 2014 11:09:00 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: doc: fix invalid reference to setattr(8)
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

man 8 btrfs-property refers to `setattr(8)` which does not actually exist.
It should refer to `chattr (1)` instead.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 Documentation/btrfs-property.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 6b23e2e..9ed568c 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -64,4 +64,4 @@ SEE ALSO
 --------
 `mkfs.btrfs`(8),
 `lsattr`(1),
-`setattr`(8)
+`chattr`(1)
-- 
1.8.3.1

