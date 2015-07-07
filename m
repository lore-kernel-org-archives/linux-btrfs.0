Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57207 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbbGGCMh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 22:12:37 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t672ApgL015336
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Jul 2015 10:10:51 +0800
From: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Documentation: update btrfs-replace manual to support RAID5/6
Date: Tue, 7 Jul 2015 10:12:16 +0800
Message-ID: <1436235136-25282-1-git-send-email-wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Man manual need to be updated since RAID5/6 has been supported
by btrfs-replace.

Signed-off-by: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
---
 Documentation/btrfs-replace.asciidoc | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/btrfs-replace.asciidoc b/Documentation/btrfs-replace.asciidoc
index 774d850..5a14a40 100644
--- a/Documentation/btrfs-replace.asciidoc
+++ b/Documentation/btrfs-replace.asciidoc
@@ -13,11 +13,6 @@ DESCRIPTION
 -----------
 *btrfs replace* is used to replace btrfs managed devices with other device.
 
-NOTE: this is not currently supported for RAID5/6 profiles and must use the
-device add/delete workaround.
-It is recommended to see `btrfs-device`(8) for more details about btrfs device
-management.
-
 SUBCOMMAND
 ----------
 *cancel* <mount_point>::
-- 
1.9.1

