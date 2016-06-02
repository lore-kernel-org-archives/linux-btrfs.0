Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:17488 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbcFBIPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 04:15:17 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0C6D9AC01FC
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 17:15:10 +0900 (JST)
Subject: [PATCH 5/5] btrfs-progs: btrfs-crc: make argc check more strict
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <9919499d-5ffe-e7b2-1e08-922f33edeb23@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 17:14:57 +0900
MIME-Version: 1.0
In-Reply-To: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  btrfs-crc.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index c2b5f00..d433ff3 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -69,12 +69,14 @@ int main(int argc, char **argv)
  	str = argv[optind];

  	if (!loop) {
-		if (check_argc_min(argc - optind, 1))
+		if (check_argc_exact(argc - optind, 1))
  			print_usage(255);

  		printf("%12u - %s\n", crc32c(~1, str, strlen(str)), str);
  		return 0;
  	}
+	if (check_argc_exact(argc - optind, 0))
+		print_usage(255);

  	buf = malloc(length);
  	if (!buf)
-- 
2.5.5
