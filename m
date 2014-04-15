Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39014 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752459AbaDOHDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 03:03:55 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F73rOA001781
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 15:03:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: Fix the return value when executing 'btrfs pro get' on a uncompress file.
Date: Tue, 15 Apr 2014 15:04:52 +0800
Message-ID: <1397545492-3054-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When executing 'btrfs pro get' on a file which is not compressed, return
value will always be 50 since prop_compress() return -ENOATTR.

But this should be ignored and other prop_XXX() returns 0, so when
prop_compress() is executed on uncompress file, it should return 0.

Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
---
 props.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/props.c b/props.c
index 4d0aeea..49ee982 100644
--- a/props.c
+++ b/props.c
@@ -146,6 +146,7 @@ static int prop_compression(enum prop_object_type type,
 			fprintf(stderr,
 				"ERROR: failed to %s compression for %s. %s\n",
 				value ? "set" : "get", object, strerror(-ret));
+		ret = 0;
 		goto out;
 	}
 	if (!value) {
-- 
1.9.2

