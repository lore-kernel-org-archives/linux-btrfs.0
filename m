Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56840 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753076AbeDIDmE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Apr 2018 23:42:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id A38FF48AE782
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 11:41:56 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: mark -f option of btrfs scrub start deprecated
Date: Mon, 9 Apr 2018 11:38:09 +0800
Message-ID: <1523245089-2788-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since in the commit below detect the scrub information automatically,
-f option is no more need.
Let's make it deprecated.
commit d5fd05a773e2
("btrfs-progs: scrub, detect stale information in the status file")

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Documentation/btrfs-scrub.asciidoc | 9 ++++++---
 cmds-scrub.c                       | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index d2d20627..89bca18e 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -75,9 +75,12 @@ set IO priority class (see `ionice`(1) manpage)
 -n <ioprio_classdata>::::
 set IO priority classdata (see `ionice`(1) manpage)
 -f::::
-force starting new scrub even if a scrub is already running,
-this can useful when scrub status file is damaged and reports a running
-scrub although it is not, but should not normally be necessary
+*deprecated, will be removed.*
++
+An option to force starting new scrub when scrub status file is damaged and
+reports a running scrub although it is not, since whether a scrub is really
+running can be judged automatically now, this option should not be necessary
+anymore.
 
 *status* [-d] <path>|<device>::
 Show status of a running scrub for the filesystem identified by 'path' or
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 6b909f20..8cf1e5df 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1569,7 +1569,7 @@ static const char * const cmd_scrub_start_usage[] = {
 	"-R     raw print mode, print full data instead of summary",
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
-	"-f     force starting new scrub even if a scrub is already running",
+	"-f     (deprecated) force starting new scrub even if a scrub is already running",
 	"       this is useful when scrub stats record file is damaged",
 	NULL
 };
-- 
2.14.3



