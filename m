Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51497 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2ILEar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 00:30:47 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 4A2723EE0BB
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:46 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3332045DEB5
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:46 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 1CB9E45DEB7
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:46 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id F354C1DB803B
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:45 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id AC59CE08003
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:45 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id 84B2260FF9
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:45 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.87])
	by m1000.s.css.fujitsu.com (Postfix) with SMTP id 452E760F43
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 13:30:45 +0900 (JST)
Message-Id: <201209120430.AA00006@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 12 Sep 2012 13:30:19 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix arguments check of qgroup limit
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Segmentation fault occurred in the following command.

 # btrfs qgroup limit
 Segmentation fault

So, we should check a minimum number of arguments.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-qgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 15534ea..1525c11 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -374,6 +374,9 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		}
 	}
 
+	if (check_argc_min(argc - optind, 2))
+		usage(cmd_qgroup_limit_usage);
+
 	if (!parse_limit(argv[optind], &size)) {
 		fprintf(stderr, "Invalid size argument given\n");
 		return 1;

