Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:63822 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcKRFog (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 00:44:36 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 23357AC0342
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:44:29 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3050.s.css.fujitsu.com (Postfix) with SMTP id 03C047DC
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 14:44:28 +0900 (JST)
Message-Id: <201611180544.AA00017@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 18 Nov 2016 14:44:12 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: test: fix error of test target of Makefile
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test-cli to test target of Makefile.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index 4bd3e63..6c78841 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -298,7 +298,7 @@ test-inst: all
 		$(MAKE) DESTDIR=$$tmpdest install && \
 		$(RM) -rf -- $$tmpdest
 
-test: test-fsck test-mkfs test-convert test-misc test-fuzz
+test: test-fsck test-mkfs test-convert test-misc test-fuzz test-cli
 
 #
 # NOTE: For static compiles, you need to have all the required libs
-- 
2.9.3
