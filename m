Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752118AbaGCCMK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 22:12:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s632C6aC013420
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 10:12:06 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: update manpage with new option -y for btrfstune
Date: Thu, 3 Jul 2014 10:06:36 +0800
Message-ID: <1404353196-10914-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new -y option says yes to clear the seeding flag,
this is to facilitate scripting.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfstune.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index bf44bdf..2406b0b 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -24,7 +24,10 @@ Enable seeding forces a fs readonly so that you can use it to build other filesy
 Enable extended inode refs.
 -x::
 Enable skinny metadata extent refs.
-
+-y::
+Say yes to clear the seeding flag.
+Clear the seeding flag may cause the original filesystem to be writable which is dangerous.
+So you need to confirm that you really want to clear it.
 
 EXIT STATUS
 -----------
-- 
1.8.1.4

