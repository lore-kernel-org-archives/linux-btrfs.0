Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26696 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755828AbaFZC6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wVQ5027099
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:31 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 5/6] btrfs-progs: limit minimal num of args for btrfs-image
Date: Thu, 26 Jun 2014 10:53:05 +0800
Message-ID: <1403751186-31559-5-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-image requires at least 2 args to run,
one for the source dev/file, the other for the target dev/file.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index e0aabfd..b13f236 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2521,6 +2521,9 @@ int main(int argc, char *argv[])
 	}
 
 	argc = argc - optind;
+	if (argc < 2)
+		print_usage();
+
 	dev_cnt = argc - 1;
 
 	if (create) {
-- 
1.8.1.4

