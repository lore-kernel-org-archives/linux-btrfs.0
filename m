Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:32986 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbcFBIGv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 04:06:51 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 48E1BAC01DF
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 17:06:45 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH 1/5] btrfs-progs: btrfs-crc: fix build error
Message-ID: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 17:06:37 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove the following build error.

   ====================================
   $ make btrfs-crc
       [CC]     btrfs-crc.o
       [LD]     btrfs-crc
   btrfs-crc.o: In function `usage':
   /home/sat/src/btrfs-progs/btrfs-crc.c:26: multiple definition of `usage'
   help.o:/home/sat/src/btrfs-progs/help.c:125: first defined here
   collect2: error: ld returned 1 exit status
   Makefile:294: recipe for target 'btrfs-crc' failed
   make: *** [btrfs-crc] Error 1
   =====================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  btrfs-crc.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index 723e0b7..86dfe05 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -22,7 +22,7 @@
  #include "crc32c.h"
  #include "utils.h"

-void usage(void)
+void print_usage(void)
  {
  	printf("usage: btrfs-crc filename\n");
  	printf("    print out the btrfs crc for \"filename\"\n");
@@ -57,7 +57,7 @@ int main(int argc, char **argv)
  			seed = atol(optarg);
  			break;
  		case 'h':
-			usage();
+			print_usage();
  		case '?':
  			return 255;
  		}
-- 
2.5.5
