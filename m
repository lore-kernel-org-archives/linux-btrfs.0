Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49509 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaDZJlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 05:41:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wdz6i-0000Vn-6N
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 11:41:16 +0200
Received: from p5b006ad9.dip0.t-ipconnect.de ([91.0.106.217])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 11:41:16 +0200
Received: from holger.hoffstaette by p5b006ad9.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 11:41:16 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: [PATCH] btrfs-progs: fix mkfs.btrfs segfault with --features option
Date: Sat, 26 Apr 2014 09:41:04 +0000 (UTC)
Message-ID: <pan.2014.04.26.09.41.04@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The mkfs.btrfs --features long option takes an argument but does not
declare it. Consequently getopt does not allocate an argument, which
makes an unconditional strdup() crash during options parsing.
Fix by declaring the argument in the options alias array.

Signed-off-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
---
 mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index dbd83f5..173972c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -350,7 +350,7 @@ static struct option long_options[] = {
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
-	{ "features", 0, NULL, 'O' },
+	{ "features", 1, NULL, 'O' },
 	{ NULL, 0, NULL, 0}
 };
 
-- 
1.9.2

