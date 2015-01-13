Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20323 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbbAMDyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 22:54:13 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D3rZH1001338
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 11:53:35 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: add missing options to qgroup limit
Date: Tue, 13 Jan 2015 11:53:16 +0800
Message-ID: <1421121196-13857-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs qgroup limit has two options -c and -e,. They were forgotten to add
to manpage.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-qgroup.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 8ce1c27..7e370bd 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -58,6 +58,15 @@ identified by <path>.
 +
 If <qgroupid> is not given, qgroup of the subvolume identified by <path>
 is used if possible.
++
+`Options`
++
+-c::::
+limit amount of data after compression. This is the default, it is currently not
+possible to turn off this option.
++
+-e::::
+limit space exclusively assigned to this qgroup.
 
 *remove* <src> <dst> <path>::
 Remove the relationship between child qgroup <src> and parent qgroup <dst> in
-- 
1.9.1

