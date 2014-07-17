Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4426 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752548AbaGQCqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 22:46:36 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6H2kXfo028206
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 10:46:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: correct manpage option description for scrub
Date: Thu, 17 Jul 2014 10:40:39 +0800
Message-ID: <1405564839-28702-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The -f option of scrub means to skip checking running scrub,
not to force checking.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-scrub.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index 7b27d63..1af9b9f 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -47,7 +47,7 @@ manpage).
 -n <ioprio_classdata>::::
 Set IO priority classdata (see `ionice`(1) manpage).
 -f::::
-force to check whether scrub has started or resumed in userspace.
+force to skip checking whether scrub has started or resumed in userspace.
 this is useful when scrub stat record file is damaged.
 
 *cancel* <path>|<device>::
-- 
1.8.1.4

