Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:34671 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbcFBIMD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 04:12:03 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A269FAC0287
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 17:11:56 +0900 (JST)
Subject: [PATCH 3/5] btrfs-progs: btrfs-crc: print usage on receiving invalid
 arguments
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <d5d8b5ad-e566-a263-2282-12807e5d8965@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 17:11:51 +0900
MIME-Version: 1.0
In-Reply-To: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Usage is only printed if -h option is set. However it's nice to
do it when wrong option is set or the number of argument is wrong.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  btrfs-crc.c | 10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index 86dfe05..55a4c61 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -22,7 +22,7 @@
  #include "crc32c.h"
  #include "utils.h"

-void print_usage(void)
+void print_usage(int status)
  {
  	printf("usage: btrfs-crc filename\n");
  	printf("    print out the btrfs crc for \"filename\"\n");
@@ -30,7 +30,7 @@ void print_usage(void)
  	printf("    brute force search for file names with the given crc\n");
  	printf("      -s seed    the random seed (default: random)\n");
  	printf("      -l length  the length of the file names (default: 10)\n");
-	exit(1);
+	exit(status);
  }

  int main(int argc, char **argv)
@@ -57,9 +57,9 @@ int main(int argc, char **argv)
  			seed = atol(optarg);
  			break;
  		case 'h':
-			print_usage();
+			print_usage(1);
  		case '?':
-			return 255;
+			print_usage(255);
  		}
  	}

@@ -68,7 +68,7 @@ int main(int argc, char **argv)

  	if (!loop) {
  		if (check_argc_min(argc - optind, 1))
-			return 255;
+			print_usage(255);

  		printf("%12u - %s\n", crc32c(~1, str, strlen(str)), str);
  		return 0;
-- 
2.5.5
