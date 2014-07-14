Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57922 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaGNCp2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 22:45:28 -0400
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by fgwmail7.fujitsu.co.jp (Postfix) with ESMTP id E8A9E1795800
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 11:37:09 +0900 (JST)
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D42C53EE0C2
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 11:36:55 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D06BDAC0563
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 11:36:54 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 81814EF8001
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 11:36:54 +0900 (JST)
Received: from WIN-R1VKH1IH438.jp.fujitsu.com (unknown [10.124.102.85])
	by m1000.s.css.fujitsu.com (Postfix) with SMTP id 236E0620AF
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 11:36:54 +0900 (JST)
Message-Id: <201407140227.AA00004@WIN-R1VKH1IH438.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 14 Jul 2014 11:27:43 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix incorrect subvol name
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subvolume name is wrong. Fix it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Documentation/btrfs-convert.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index ed61d14..1eff0bf 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -13,7 +13,7 @@ DESCRIPTION
 -----------
 *btrfs-convert* is used to convert existed ext2/3/4 to btrfs filesystem,
 and the original filesystem image is accessible as from separate subvolume
-named 'ext2_subvol' as file image.
+named 'ext2_saved' as file image.
 
 OPTIONS
 -------
-- 
1.8.5.5

