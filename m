Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbaLVHZE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 02:25:04 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBM7OXiM024724
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 15:24:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <takeuchi_satoru@jp.fujitsu.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: Documentation: add T/P/E description for resize cmd
Date: Mon, 22 Dec 2014 15:22:53 +0800
Message-ID: <1419232973-4623-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <54978DFE.6010507@jp.fujitsu.com>
References: <54978DFE.6010507@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
changelog
	v1->v2: s/\'E\'(EiB)/or \'E\'(EiB)/ as suggested by Satoru, thanks.
---
 Documentation/btrfs-filesystem.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index a8f2972..138ba6c 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -102,8 +102,8 @@ If the prefix + or - is present the size is increased or decreased
 by the quantity <size>.
 If no units are specified, the unit of the <size> parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
-respectively.
+units designators: \'K\'(KiB), \'M\'(MiB), \'G\'(GiB), \'T\'(TiB), \'P\'(PiB)
+or \'E\'(EiB).
 +
 If \'max' is passed, the filesystem will occupy all available space on the
 device devid.
-- 
1.8.1.4

