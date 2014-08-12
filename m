Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37796 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHLIaN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 04:30:13 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 4E2013EE0C2
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 17:30:11 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 580EDAC0409
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 17:30:10 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0A26B1DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 17:30:10 +0900 (JST)
Received: from G01JPEXCHYT16.g01.fujitsu.local (G01JPEXCHYT16.g01.fujitsu.local [10.128.194.55])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 3DB306D6371
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 17:30:09 +0900 (JST)
Message-ID: <53E9D08A.3070404@jp.fujitsu.com>
Date: Tue, 12 Aug 2014 17:30:02 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a misformatting in 'man btrfs-replace'
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Just fix the following misformatting in 'man btrfs-replace'.

===============================================================================
-f                                                                                                                
    force using and overwriting <targetdev> even if it looks like containing
    a valid btrfs filesystem.

    A valid filesystem is assumed if a btrfs superblock is found which
    contains a correct checksum. Devices which are currently mounted are never
    allowed to be used as the <targetdev>. -B:::: no background replace.
                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
===============================================================================
 
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 Documentation/btrfs-replace.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index eecf9b0..476e351 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -49,6 +49,7 @@ containing a valid btrfs filesystem.
 A valid filesystem is assumed if a btrfs superblock is found which contains a
 correct checksum. Devices which are currently mounted are
 never allowed to be used as the <targetdev>.
++
 -B::::
 no background replace.
 
-- 
1.9.3

