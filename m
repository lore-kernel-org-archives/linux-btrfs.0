Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48219 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKCtw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 22:49:52 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 882D63EE1C4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:50 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9A7BBAC0461
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:49 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4F2831DB8032
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:49 +0900 (JST)
Received: from g01jpexchkw34.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id A14123284B8
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:49:48 +0900 (JST)
Message-ID: <53E82F3F.4020006@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 11:49:35 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs: random fixes for usage string of btrfs scrub
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

- Add missing description about "-R" option in the command
  usage of "btrfs scrub resume".

- Add missing comma to avoid the following misformatted command
  usage of "btrfs scrub start". See the line of "-R" option.

===
usage: btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>

    Start a new scrub
                                                                                                                             
    -B     do not background
    -d     stats per device (-B only)
    -q     be quiet
    -r     read only mode
    -R     raw print mode, print full data instead of summary-c     set ioprio class (see ionice(1) manpage)
    -n     set ioprio classdata (see ionice(1) manpage)
    -f     force to skip checking whether scrub has started/resumed in userspace
           this is useful when scrub stats record file is damaged
===

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-scrub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 0bf06ee..bd80a64 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1533,10 +1533,10 @@ static const char * const cmd_scrub_start_usage[] = {
 	"-d     stats per device (-B only)",
 	"-q     be quiet",
 	"-r     read only mode",
-	"-R     raw print mode, print full data instead of summary"
+	"-R     raw print mode, print full data instead of summary",
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
-	"-f     force to skip checking whether scrub has started/resumed in userspace ",
+	"-f     force to skip checking whether scrub has started/resumed in userspace",
 	"       this is useful when scrub stats record file is damaged",
 	NULL
 };
@@ -1605,6 +1605,7 @@ static const char * const cmd_scrub_resume_usage[] = {
 	"-d     stats per device (-B only)",
 	"-q     be quiet",
 	"-r     read only mode",
+	"-R     raw print mode, print full data instead of summary",
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
 	NULL
-- 
1.9.3

