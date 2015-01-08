Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38541 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAHCld (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 21:41:33 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 068023EE188
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 11:41:32 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E2A0FAC06B5
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 11:41:30 +0900 (JST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 91BEC1DB8032
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 11:41:30 +0900 (JST)
Received: from WIN-R1VKH1IH438.jp.fujitsu.com (unknown [10.124.102.85])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 5F4EB18F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 11:41:30 +0900 (JST)
Message-Id: <201501080240.AA00006@WIN-R1VKH1IH438.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 08 Jan 2015 11:40:53 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix format of btrfs-replace
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current 'man btrfs-replace' is as follows:

========================================================================
...
...
           -f
               force using and overwriting <targetdev> even if it looks like
               containing a valid btrfs filesystem.

               A valid filesystem is assumed if a btrfs superblock is found
               which contains a correct checksum. Devices which are currently
               mounted are never allowed to be used as the <targetdev>. -B::::
               no background replace.
...
...
========================================================================

The format of 'B' option is wrong. So, fix it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com> 
---
NOTE: This patch based on v3.18.x branch.

 Documentation/btrfs-replace.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index 7402484..e8eac2c 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -52,6 +52,7 @@ containing a valid btrfs filesystem.
 A valid filesystem is assumed if a btrfs superblock is found which contains a
 correct checksum. Devices which are currently mounted are
 never allowed to be used as the <targetdev>.
++
 -B::::
 no background replace.
 
-- 
2.2.1

