Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933108AbbIDN0A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:26:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPn2x030035
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:49 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs-progs: update manual for --extra-dev and -h for btrfs rescue
Date: Fri, 4 Sep 2015 21:24:19 +0800
Message-ID: <f559741efed751a44beacf2cd8bf0146b7df0615.1441357933.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
References: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--extra-dev and -h option was added to btrfs rescue command,
this patch update relative manual.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 Documentation/btrfs-rescue.asciidoc | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index 42aca64..11f133c 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -20,6 +20,8 @@ Recover the chunk tree by scanning the devices
 +
 `Options`
 +
+--extra-dev::::
+set extra device to search.
 -y::::
 assume an answer of 'yes' to all questions.
 -v::::
@@ -35,13 +37,22 @@ Recover bad superblocks from good copies.
 +
 `Options`
 +
+--extra-dev::::
+set extra device to search.
 -y::::
 assume an answer of 'yes' to all questions.
 -v::::
 verbose mode.
 
-*zero-log* <device>::
+*zero-log* [options] <device>::
 clear the filesystem log tree
++
+`Options`
++
+--extra-dev::::
+set extra device to search.
+-h::::
+help.
 
 This command will clear the filesystem log tree. This may fix a specific
 set of problem when the filesystem mount fails due to the log replay. See below
-- 
1.8.5.1

