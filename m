Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:62918 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbcFBINW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 04:13:22 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3EADBAC021A
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 17:13:16 +0900 (JST)
Subject: [PATCH 4/5] btrfs-progs: btrfs-crc: improve usage message
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <223f8f9d-908f-8f01-1454-09d954905a6e@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 17:13:10 +0900
MIME-Version: 1.0
In-Reply-To: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- If -c is set, filename argument is ignored.
- Describe about -h option

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  btrfs-crc.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/btrfs-crc.c b/btrfs-crc.c
index 55a4c61..c2b5f00 100644
--- a/btrfs-crc.c
+++ b/btrfs-crc.c
@@ -26,10 +26,12 @@ void print_usage(int status)
  {
  	printf("usage: btrfs-crc filename\n");
  	printf("    print out the btrfs crc for \"filename\"\n");
-	printf("usage: btrfs-crc filename -c crc [-s seed] [-l length]\n");
+	printf("usage: btrfs-crc -c crc [-s seed] [-l length]\n");
  	printf("    brute force search for file names with the given crc\n");
  	printf("      -s seed    the random seed (default: random)\n");
  	printf("      -l length  the length of the file names (default: 10)\n");
+	printf("usage: btrfs-crc -h\n");
+	printf("    print this message\n");
  	exit(status);
  }

-- 
2.5.5
