Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44088 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbaEHDIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 23:08:48 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4838hG2024654
	for <linux-btrfs@vger.kernel.org>; Thu, 8 May 2014 11:08:43 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: update man page for btrfs-show-super
Date: Thu, 8 May 2014 11:03:58 +0800
Message-ID: <1399518238-3337-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1399518238-3337-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1399518238-3337-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add '-f' option for btrfs-show-super manpage,
This option implies that sys chunk array and backup roots info
will show up.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-show-super.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-show-super.txt b/Documentation/btrfs-show-super.txt
index e8e17ab..074700f 100644
--- a/Documentation/btrfs-show-super.txt
+++ b/Documentation/btrfs-show-super.txt
@@ -20,8 +20,13 @@ Mainly used for debug purpose.
 
 OPTIONS
 -------
+-f::
+Print full superblock information.
++
+Including the system chunk array and backup roots.
+
 -a::
-Print all the superblock information.
+Print information of all superblocks.
 +
 If this option is given, '-i' option will be ignored.
 
-- 
1.8.1.4

