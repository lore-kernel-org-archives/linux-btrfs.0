Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754885AbaG3HiD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 03:38:03 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <takeuchi_satoru@jp.fujitsu.com>, <dsterba@suse.cz>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: correct manpage option description for scrub
Date: Wed, 30 Jul 2014 15:32:05 +0800
Message-ID: <1406705525-349-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <53D88C08.6050704@jp.fujitsu.com>
References: <53D88C08.6050704@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The -f option of scrub means to
    "force starting new scrub even if a scrub is already running"
*not*
    "force to check whether scrub has started or resumed in userspace"
as described originally.

So replace the orignal description in the manpage and code.

Also, add description of the potential failure as follows
    "If a scrub is already running running, it fails."

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>
---
changelog
	v1->v2: adopt more precise expression of the checking behavior
		add description of potential failure
---
 Documentation/btrfs-scrub.txt | 6 +++---
 cmds-scrub.c                  | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index 7b27d63..b8d3b65 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -18,7 +18,7 @@ SUBCOMMAND
 ----------
 *start* [-BdqrRf] [-c <ioprio_class> -n <ioprio_classdata>] <path>|<device>::
 Start a scrub on all devices of the filesystem identified by <path> or on
-a single <device>.
+a single <device>. If a scrub is already running, the new one fails.
 +
 Without options, scrub is started as a background process.
 Progress can be obtained with the *scrub status* command. Scrubbing
@@ -47,8 +47,8 @@ manpage).
 -n <ioprio_classdata>::::
 Set IO priority classdata (see `ionice`(1) manpage).
 -f::::
-force to check whether scrub has started or resumed in userspace.
-this is useful when scrub stat record file is damaged.
+Force starting new scrub even if a scrub is already running.
+This is useful when scrub stat record file is damaged.
 
 *cancel* <path>|<device>::
 If a scrub is running on the filesystem identified by <path>, cancel it.
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 03eb9ba..8c3d61c 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1529,7 +1529,7 @@ out:
 
 static const char * const cmd_scrub_start_usage[] = {
 	"btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
-	"Start a new scrub",
+	"Start a new scrub. If a scrub is already running, the new one fails.",
 	"",
 	"-B     do not background",
 	"-d     stats per device (-B only)",
@@ -1538,7 +1538,7 @@ static const char * const cmd_scrub_start_usage[] = {
 	"-R     raw print mode, print full data instead of summary"
 	"-c     set ioprio class (see ionice(1) manpage)",
 	"-n     set ioprio classdata (see ionice(1) manpage)",
-	"-f     force to skip checking whether scrub has started/resumed in userspace ",
+	"-f     force starting new scrub even if a scrub is already running.",
 	"       this is useful when scrub stats record file is damaged",
 	NULL
 };
-- 
1.8.1.4

