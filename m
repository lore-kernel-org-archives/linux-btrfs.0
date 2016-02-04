Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:34682 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbcBDFCd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 00:02:33 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 2A78DAC0CA6
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 14:02:25 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 75D0C46E8A2
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 14:02:24 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: describe btrfs-send requires read-only subvolume
Message-ID: <56B2DB56.6070104@jp.fujitsu.com>
Date: Thu, 4 Feb 2016 14:02:14 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both man btrfs-send(8) and usage message don't describe
btrfs-send needs read-only snapshot as its argument.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/btrfs-send.asciidoc | 1 +
 cmds-send.c                       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/btrfs-send.asciidoc b/Documentation/btrfs-send.asciidoc
index 1dba8a3..e05342f 100644
--- a/Documentation/btrfs-send.asciidoc
+++ b/Documentation/btrfs-send.asciidoc
@@ -12,6 +12,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 Sends the subvolume(s) specified by <subvol> to stdout.
+<subvol> should be read-only here.
 
 By default, this will send the whole subvolume. To do an incremental
 send, use '-p <parent>'.
diff --git a/cmds-send.c b/cmds-send.c
index 478ace1..3e34d75 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -711,6 +711,7 @@ const char * const cmd_send_usage[] = {
 	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
+	"<subvol> should be read-only here.",
 	"By default, this will send the whole subvolume. To do an incremental",
 	"send, use '-p <parent>'. If you want to allow btrfs to clone from",
 	"any additional local snapshots, use '-c <clone-src>' (multiple times",
-- 
2.5.0

