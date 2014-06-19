Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23499 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756872AbaFSBcA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:32:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VRrc019668
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:27 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] Btrfs-progs: btrfs-restore, document updates
Date: Thu, 19 Jun 2014 09:27:09 +0800
Message-ID: <1403141229-25565-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add some missing options, also improve some confusing
expressions.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-restore.txt | 26 ++++++++++++++++++--------
 cmds-restore.c                  |  7 ++++---
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index d774343..85b0797 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -24,7 +24,7 @@ https://btrfs.wiki.kernel.org/index.php/Restore
 OPTIONS
 -------
 -s::
-get snapshots.
+get snapshots, btrfs restore skips snapshots in default.
 
 -x::
 get extended attributes.
@@ -38,17 +38,17 @@ ignore errors.
 -o::
 overwrite directories/files in <path>.
 
--t <location>::
-use <location> to read root tree.
+-t <bytenr>::
+use <bytenr> to read root tree.
 
--f <offset>::
-use <offset> to read fs tree.
+-f <bytenr>::
+only restore files that are under specified root whose root bytenr is <bytenr>.
 
--u <block>::
-use given superblock mirror identified by <block>.
+-u <mirror>::
+use given superblock mirror identified by <mirror>, it can be 0,1,2.
 
 -r <rootid>::
-use <rootid> as root objectid.
+only restore files that are under specified root whose objectid is <rootid>.
 
 -d::
 find dir.
@@ -56,6 +56,16 @@ find dir.
 -l::
 list tree roots.
 
+-D|--dry-run::
+dry run (only list files that would be recovered).
+
+--path-regex <regex>::
+restore only filenames matching regex, you have to use following syntax (possibly quoted):
+^/(|home(|/username(|/Desktop(|/.*))))$
+
+-c::
+ignore case(--path-regrex only).
+
 EXIT STATUS
 -----------
 *btrfs restore* returns a zero exist status if it succeeds. Non zero is
diff --git a/cmds-restore.c b/cmds-restore.c
index 3a29ed6..74f35a4 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1111,9 +1111,9 @@ const char * const cmd_restore_usage[] = {
 	"-v              verbose",
 	"-i              ignore errors",
 	"-o              overwrite",
-	"-t <location>   tree location",
-	"-f <offset>     filesystem location",
-	"-u <block>      super mirror",
+	"-t <bytenr>     tree location",
+	"-f <bytenr>     filesystem location",
+	"-u <mirror>     super mirror",
 	"-r <rootid>     root objectid",
 	"-d              find dir",
 	"-l              list tree roots",
@@ -1122,6 +1122,7 @@ const char * const cmd_restore_usage[] = {
 	"                restore only filenames matching regex,",
 	"                you have to use following syntax (possibly quoted):",
 	"                ^/(|home(|/username(|/Desktop(|/.*))))$",
+	"-c              ignore case(--path-regrex only)",
 	NULL
 };
 
-- 
1.9.0

