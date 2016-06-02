Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:34886 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbcFBIK3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 04:10:29 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0870AAC0102
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 17:10:24 +0900 (JST)
Subject: [PATCH 2/5] btrfs-progs: btrfs-crc should be ignored by git
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <b1cdc8c7-10f3-3304-a0eb-37db267e2400@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 17:10:18 +0900
MIME-Version: 1.0
In-Reply-To: <08faf8d3-0cc4-5164-b583-f69c8c3eb5bc@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a binary built from btrfs-crc.c

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  .gitignore | 1 +
  1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index a27cb0d..aaf9702 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@ btrfs-zero-log
  btrfs-corrupt-block
  btrfs-select-super
  btrfs-calc-size
+btrfs-crc
  btrfstune
  libbtrfs.a
  libbtrfs.so
-- 
2.5.5
