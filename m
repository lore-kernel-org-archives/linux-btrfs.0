Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44741 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753327AbbFCJbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 05:31:55 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t539UNWi022208
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 17:30:23 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: qgroup limit: add a check for invalid input of 'T/G/M/K'
Date: Wed, 3 Jun 2015 17:27:04 +0800
Message-ID: <1433323624-2194-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a check to error out in the following case:

 # ./btrfs qgroup limit  T /mnt/
Invalid size argument given

Without this patch, btrfs-progs would parse the input as 0
and continue.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 5ea4021..9545a20 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -121,6 +121,9 @@ static int parse_limit(const char *p, unsigned long long *s)
 		return 0;
 
 	size = strtoull(p, &endptr, 10);
+	if (p == endptr)
+		return 0;
+
 	switch (*endptr) {
 	case 'T':
 	case 't':
-- 
1.8.4.2

