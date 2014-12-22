Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57397 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753692AbaLVCDr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 21:03:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBM23IgY004467
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 10:03:18 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Documentation: add T/P/E description for resize cmd
Date: Mon, 22 Dec 2014 10:01:42 +0800
Message-ID: <1419213702-3945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-filesystem.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index a8f2972..f2bd50d 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -102,8 +102,8 @@ If the prefix + or - is present the size is increased or decreased
 by the quantity <size>.
 If no units are specified, the unit of the <size> parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
-respectively.
+units designators: \'K\'(KiB), \'M\'(MiB), \'G\'(GiB), \'T\'(TiB), \'P\'(PiB),
+\'E\'(EiB).
 +
 If \'max' is passed, the filesystem will occupy all available space on the
 device devid.
-- 
1.8.1.4

