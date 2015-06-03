Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44741 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191AbbFCJbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 05:31:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t539UM8r022205
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 17:30:22 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: qgroup limit: error out if input value is negative
Date: Wed, 3 Jun 2015 17:27:03 +0800
Message-ID: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we pass a negative value to command qgroup limit, btrfs-progs
would convert it to unsigned long long silently. That's a little
confusing to user, why I can limit my quota to a negative value.

This patch add a check in parse_limit, if the input value is negative,
error out to user.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 00cc089..5ea4021 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -116,6 +116,10 @@ static int parse_limit(const char *p, unsigned long long *s)
 		*s = CLEAR_VALUE;
 		return 1;
 	}
+
+	if (p[0] == '-')
+		return 0;
+
 	size = strtoull(p, &endptr, 10);
 	switch (*endptr) {
 	case 'T':
-- 
1.8.4.2

