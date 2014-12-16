Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43754 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLPJmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:42:47 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 5F0973EE0C2
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:42:45 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 74149AC0497
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:42:44 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1A73DE08005
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 18:42:44 +0900 (JST)
Message-ID: <548FFE8E.5040507@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 18:42:38 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: [PATCH] btrfs-progs: Add a brief explanation of btrfs property in
 man 8 btrfs
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

As Chris reported at the following mail, although
btrfs property has its own manpage, man 8 btrfs-property,
there is no explanation about it in man 8 btrfs.

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40134.html

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reported-by: Chris Murphy <lists@colorremedies.com>

---
 Documentation/btrfs.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index 3bdc6b4..2ed8483 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -85,6 +85,10 @@ COMMANDS
 	Replace btrfs devices. +
 	See `btrfs-replace`(8) for details.
 
+*property*::
+	Get/set a property from/to a btrfs object. +
+	See `btrfs-property`(8) for details.
+
 EXIT STATUS
 -----------
 *btrfs* returns a zero exit status if it succeeds. Non zero is returned in
@@ -113,3 +117,4 @@ SEE ALSO
 `btrfs-quota`(8),
 `btrfs-qgroup`(8),
 `btrfs-replace`(8),
+`btrfs-property`(8),
-- 
1.8.3.1

