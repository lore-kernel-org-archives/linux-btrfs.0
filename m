Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41320 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888AbbFWXDF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 19:03:05 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH] btrfs-progs: man mkfs.btrfs: document -O^
Date: Wed, 24 Jun 2015 00:46:13 +0200
Message-Id: <1435099573-26222-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 Documentation/mkfs.btrfs.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index fd20ca5..a9aa3cb 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -112,7 +112,7 @@ Do not perform whole device TRIM operation by default.
 
 -O|--features <feature1>[,<feature2>...]::
 A list of filesystem features turned on at mkfs time. Not all features are
-supported by old kernels.
+supported by old kernels. To disable a feature, prefix it with '^'.
 +
 To see all features run:
 +
-- 
2.1.4

