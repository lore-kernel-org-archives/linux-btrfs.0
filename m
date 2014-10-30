Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17729 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbaJ3GeJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 02:34:09 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix the argument requirement for '--subvol-extents'
Date: Thu, 30 Oct 2014 14:34:06 +0800
Message-ID: <1414650846-23767-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following commit changed the argument requirement for
'--subvol-extents', which causes it to call arg_strtou64() on NULL,
resulting a segfault.
d34cbe76 btrfs-progs: check: do not require argument for --subvol-extents

This patch revert the patch and change the help string and man page to
make it no longer confusing.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.txt | 2 ++
 cmds-check.c                  | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 8a8073f..821bfc9 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -32,6 +32,8 @@ create a new CRC tree.
 create a new extent tree.
 --check-data-csum::
 verify checkums of data blocks.
+--subvol-extents <subvolid>::
+show extent state for a subvolume.
 
 EXIT STATUS
 -----------
diff --git a/cmds-check.c b/cmds-check.c
index 2a5f823..923fb10 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7544,7 +7544,7 @@ static struct option long_options[] = {
 	{ "init-extent-tree", 0, NULL, 0 },
 	{ "check-data-csum", 0, NULL, 0 },
 	{ "backup", 0, NULL, 0 },
-	{ "subvol-extents", no_argument, NULL, 'E' },
+	{ "subvol-extents", 1, NULL, 'E' },
 	{ "qgroup-report", 0, NULL, 'Q' },
 	{ NULL, 0, NULL, 0}
 };
@@ -7560,7 +7560,7 @@ const char * const cmd_check_usage[] = {
 	"--init-extent-tree          create a new extent tree",
 	"--check-data-csum           verify checkums of data blocks",
 	"--qgroup-report             print a report on qgroup consistency",
-	"--subvol-extents            print subvolume extents and sharing state",
+	"--subvol-extents <subvolid> print subvolume extents and sharing state",
 	NULL
 };
 
-- 
2.1.2

