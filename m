Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49208 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752874AbbJMMyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:54:02 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9DCrVUN019612
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 20:53:31 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: mkfs: Fix inaccurate mixed information
Date: Tue, 13 Oct 2015 20:52:19 +0800
Message-ID: <5f474fe3bd4d26284ec1e01afa6355e523d7477e.1444740703.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In current code, with a "BIG VOLUME" /dev/vdd2:
 # ./mkfs.btrfs -f -M /dev/vdd2
 SMALL VOLUME: forcing mixed metadata/data groups
 ...

This patch changed above output to:
 Using mixed metadata/data groups

And the "SMALL VOLUME" output only when we exactly using
SMALL VOLUME.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 29cab13..0064a78 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1505,7 +1505,10 @@ int main(int ac, char **av)
 		ret = 0;
 	}
 
-	if (!large_device_cnt || mixed) {
+	if (mixed) {
+		if (verbose)
+			printf("Using mixed metadata/data groups\n");
+	} else if (!large_device_cnt) {
 		if (verbose)
 			printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
 		mixed = 1;
-- 
1.8.5.1

