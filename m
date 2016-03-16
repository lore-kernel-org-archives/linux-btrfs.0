Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:31718 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbcCPCBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 22:01:25 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 59451AC0280
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 11:01:19 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: Describe optarg of -m option in the manpage
 of receive
Message-ID: <56E8BE67.6030802@jp.fujitsu.com>
Date: Wed, 16 Mar 2016 11:01:11 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to devel branch (commit: 4685a560811a)
---
 Documentation/btrfs-receive.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index 84b85c1..758eebe 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -43,7 +43,7 @@ or on EOF.
 --max-errors <N>::
 Terminate as soon as N errors happened while processing commands from the send
 stream. Default value is 1. A value of 0 means no limit.
--m::
+-m <mountpoint>::
 The root mount point of the destination fs.
 +
 By default the mountpoint is searched in /proc/self/mounts.
-- 
2.5.0
