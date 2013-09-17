Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3IQPVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:21:36 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 189D9A5511
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 17:21:36 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs-progs: move chunk-recover to rescue group
Date: Tue, 17 Sep 2013 17:21:21 +0200
Message-Id: <59591179243e3386a4a506ab7197a24c0de05915.1379430631.git.dsterba@suse.cz>
In-Reply-To: <cover.1379430631.git.dsterba@suse.cz>
References: <cover.1379430631.git.dsterba@suse.cz>
In-Reply-To: <cover.1379430631.git.dsterba@suse.cz>
References: <cover.1379430631.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs.c        |  1 -
 cmds-chunk.c   |  2 +-
 cmds-rescue.c  |  1 +
 man/btrfs.8.in | 10 ++--------
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 14a27cb..dfae35f 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -248,7 +248,6 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
 		{ "rescue", cmd_rescue, NULL, &rescue_cmd_group, 0 },
-		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 115db61..985f676 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1745,7 +1745,7 @@ fail_rc:
 }
 
 const char * const cmd_chunk_recover_usage[] = {
-	"btrfs chunk-recover [options] <device>",
+	"btrfs rescue chunk-recover [options] <device>",
 	"Recover the chunk tree by scanning the devices one by one.",
 	"",
 	"-y	Assume an answer of `yes' to all questions",
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 35a61f8..35b3bb1 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -27,6 +27,7 @@ static const char * const rescue_cmd_group_usage[] = {
 
 const struct cmd_group rescue_cmd_group = {
 	rescue_cmd_group_usage, NULL, {
+		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 24777e6..2888941 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -69,9 +69,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBcheck\fP [\fIoptions\fP] \fI<device>\fP
 .PP
-\fBbtrfs\fP \fBrescue\fP [\fIoptions\fP] \fI<path>\fP
-.PP
-\fBbtrfs\fP \fBchunk-recover\fP [\fIoptions\fP] \fI<device>\fP
+\fBbtrfs\fP \fBrescue chunk-recover\fP [\fIoptions\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP
 .PP
@@ -502,11 +500,7 @@ create a new extent tree.
 .RE
 .TP
 
-\fBrescue\fR [\fIoptions\fP] <path>\fR
-Rescue toolbox.
-.TP
-
-\fBchunk-recover\fR [\fIoptions\fP] <device>\fR
+\fBrescue chunk-recover\fR [\fIoptions\fP] <device>\fR
 Recover the chunk tree by scanning the devices one by one.
 .RS
 
-- 
1.8.3.1

