Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32256 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbaDOJVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 05:21:22 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F9LG21011687
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 17:21:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 4/4] btrfs-progs: Fix the return value when executing 'btrfs pro get' on a uncompress file.
Date: Tue, 15 Apr 2014 17:22:24 +0800
Message-ID: <1397553744-24465-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When executing 'btrfs pro get' on a file which is not compressed, return
value will always be 50 since prop_compress() return -ENOATTR.

But the codes have already check the errno to avoid unnecessary error
message, so the return value should also set to 0.

Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
---
 props.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/props.c b/props.c
index 4d0aeea..c09865b 100644
--- a/props.c
+++ b/props.c
@@ -142,10 +142,12 @@ static int prop_compression(enum prop_object_type type,
 		sret = fgetxattr(fd, xattr_name, NULL, 0);
 	if (sret < 0) {
 		ret = -errno;
-		if (ret != -ENODATA)
+		if (ret != -ENOATTR)
 			fprintf(stderr,
 				"ERROR: failed to %s compression for %s. %s\n",
 				value ? "set" : "get", object, strerror(-ret));
+		else
+			ret = 0;
 		goto out;
 	}
 	if (!value) {
-- 
1.9.2

