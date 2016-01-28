Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:56920 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbcA1IBJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 03:01:09 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 90FB2AC023B
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 17:01:03 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 619B4165
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 17:01:03 +0900 (JST)
Message-Id: <201601280800.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 28 Jan 2016 17:00:33 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix size suffix in mkfs.btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no petabyte in the explanation of the suffix of
the size parameter. So, it's added.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Documentation/mkfs.btrfs.asciidoc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 0b145c7..312b816 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -154,8 +154,8 @@ Print help.
 SIZE UNITS
 ----------
 The default unit is 'byte'. All size parameters accept suffixes in the 1024
-base. The recognized suffixes are: 'k', 'm', 'g', 't', 'e', both uppercase and
-lowercase.
+base. The recognized suffixes are: 'k', 'm', 'g', 't', 'p', 'e', both uppercase
+and lowercase.
 
 MULTIPLE DEVICES
 ----------------
-- 
2.6.4
