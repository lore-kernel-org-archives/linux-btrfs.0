Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:56580 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbF3X5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 19:57:16 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0D841AC0221
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2015 08:57:14 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id D2786F9
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2015 08:57:13 +0900 (JST)
Message-Id: <201506302356.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 01 Jul 2015 08:56:52 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix short explanation of restore in btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Short explanation of restore is wrong. Fix it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Documentation/btrfs.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index 1b3aa29..72d0e0a 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -75,7 +75,7 @@ COMMANDS
 	See `btrfs-rescue`(8) for details.
 
 *restore*::
-	Manage a btrfs filesystem, including label setting/sync and so on. +
+	Try to restore files from damaged btrfs filesystem. +
 	See `btrfs-restore`(8) for details.
 
 *scrub*::
-- 
2.3.1

----
Tsutomu Itoh  t-itoh@jp.fujitsu.com

