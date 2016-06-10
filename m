Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:36143 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbcFJN6K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 09:58:10 -0400
Received: by mail-qg0-f67.google.com with SMTP id k43so5315961qgk.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 06:58:09 -0700 (PDT)
From: Noah Massey <noah.massey@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Noah Massey <noah.massey@gmail.com>
Subject: [PATCH] btrfs-progs: doc: add missing newline in btrfs-convert
Date: Fri, 10 Jun 2016 09:57:55 -0400
Message-Id: <1465567075-9153-1-git-send-email-noah.massey@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Noah Massey <noah.massey@gmail.com>
---
 Documentation/btrfs-convert.asciidoc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-convert.asciidoc b/Documentation/btrfs-convert.asciidoc
index 28f9a39..ab3577d 100644
--- a/Documentation/btrfs-convert.asciidoc
+++ b/Documentation/btrfs-convert.asciidoc
@@ -90,6 +90,7 @@ are supported by old kernels. To disable a feature, prefix it with '^'.
 To see all available features that btrfs-convert supports run:
 +
 +btrfs-convert -O list-all+
++
 -p|--progress::
 show progress of conversion, on by default
 --no-progress::
-- 
2.8.1

