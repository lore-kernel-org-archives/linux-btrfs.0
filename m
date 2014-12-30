Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35163 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbaL3Byc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 20:54:32 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <takeuchi_satoru@jp.fujitsu.com>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v3] btrfs-progs: Documentation: add T/P/E description for resize cmd
Date: Tue, 30 Dec 2014 09:52:17 +0800
Message-ID: <1419904337-9945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20141229160712.GK6490@twin.jikos.cz>
References: <20141229160712.GK6490@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
changelog
	v1->v2:
		s/\'E\'(EiB)/or \'E\'(EiB)/ as suggested by Satoru, thanks.
	v2->v3:
		replace confusing format 'K'(KiB) etc. Thanks, David.
---
 Documentation/btrfs-filesystem.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index a8f2972..96c4420 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -102,8 +102,9 @@ If the prefix + or - is present the size is increased or decreased
 by the quantity <size>.
 If no units are specified, the unit of the <size> parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
-respectively.
+units designators: \'K\', \'M\', \'G\', \'T\', \'P\', or \'E\', which represent
+KiB, MiB, GiB, TiB, PiB, or EiB, respectively.
+
 +
 If \'max' is passed, the filesystem will occupy all available space on the
 device devid.
-- 
1.8.1.4

