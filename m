Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55171 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKCtk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 22:49:40 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9C7583EE0BB
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:38 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A6B4DAC0485
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:37 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5D0951DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:37 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id AE079BD6464
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:36 +0900 (JST)
Message-ID: <53E82F2F.3020800@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 11:49:19 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs: add missing descriptions of '--max-errors' in btrfs-receive
 documentation
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Fix the lack of description of "--max-erros" option in
both man and command usage of btrfs receive.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 Documentation/btrfs-receive.txt | 2 +-
 cmds-receive.c                  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
index 78dc511..beb963c 100644
--- a/Documentation/btrfs-receive.txt
+++ b/Documentation/btrfs-receive.txt
@@ -7,7 +7,7 @@ btrfs-receive - receive subvolumes from stdin/file.
 
 SYNOPSIS
 --------
-*btrfs receive* [-ve] [-f <infile>] <mount>
+*btrfs receive* [-ve] [-f <infile>] [--max-errors <N>] <mount>
 
 DESCRIPTION
 -----------
diff --git a/cmds-receive.c b/cmds-receive.c
index 9a6d6d9..ed33258 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1120,9 +1120,9 @@ int cmd_receive(int argc, char **argv)
 }
 
 const char * const cmd_receive_usage[] = {
-	"btrfs receive [-ve] [-f <infile>] <mount>",
+	"btrfs receive [-ve] [-f <infile>] [--max-errors <N>] <mount>",
 	"Receive subvolumes from stdin.",
-	"Receives one or more subvolumes that were previously ",
+	"Receives one or more subvolumes that were previously",
 	"sent with btrfs send. The received subvolumes are stored",
 	"into <mount>.",
 	"btrfs receive will fail in case a receiving subvolume",
-- 
1.9.3

