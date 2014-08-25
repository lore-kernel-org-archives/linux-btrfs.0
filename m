Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58347 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752894AbaHYWJR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 18:09:17 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: typo in btrfs-progs master/v3.16.x
Date: Mon, 25 Aug 2014 16:09:16 -0600
Message-Id: <AD5C5B4A-E27D-4206-8552-5483EDB1BE98@colorremedies.com>
Cc: "dsterba@suse.cz Sterba" <dsterba@suse.cz>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

git diff mason/master sterba/integration-20140729

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 731c5c9..0bf06ee 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1527,16 +1527,16 @@ out:
 
 static const char * const cmd_scrub_start_usage[] = {
        "btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
-       "Start a new scrub. If a scrub is already running, the new one fails.",
+       "Start a new scrub",
        "",
        "-B     do not background",
        "-d     stats per device (-B only)",
        "-q     be quiet",
        "-r     read only mode",
-       "-R     raw print mode, print full data instead of summary",
+       "-R     raw print mode, print full data instead of summary"


Looks like a missing , at the end of this line. All other lines end in ,



Chris Murphy

