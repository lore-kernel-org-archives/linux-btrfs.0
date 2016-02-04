Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:40473 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885AbcBDCBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Feb 2016 21:01:43 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E7989AC0484
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 10:51:27 +0900 (JST)
Received: from g01jpexchkw34.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 06E9BBD645A
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 10:51:27 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: Fix self-reference of man btrfs-subvolume
Message-ID: <56B2AE9A.5000204@jp.fujitsu.com>
Date: Thu, 4 Feb 2016 10:51:23 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-subvolume(8) is mentioned at "SEE ALSO" section of itself.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index c187fd8..96cfe4a 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -178,6 +178,5 @@ further details.
 SEE ALSO
 --------
 `mkfs.btrfs`(8),
-`btrfs-subvolume`(8),
 `btrfs-quota`(8),
 `btrfs-qgroup`(8),
-- 
2.7.0.rc3


