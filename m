Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.sevenbyte.org ([5.9.90.188]:59316 "EHLO mail.sevenbyte.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbBULdQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Feb 2015 06:33:16 -0500
From: Stefan Tatschner <stefan@sevenbyte.org>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Tatschner <stefan@sevenbyte.org>
Subject: [PATCH] docs: fixed a grammar mistake
Date: Sat, 21 Feb 2015 12:12:42 +0100
Message-Id: <1424517162-6540-1-git-send-email-stefan@sevenbyte.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Tatschner <stefan@sevenbyte.org>
---

This patch is for the userspace tools btrfs-progs.

 Documentation/btrfs-scrub.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index 6ebce60..7750868 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -11,8 +11,8 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-*btrfs scrub* is used to scrub a btrfs filesystem, which will reading all data
-from all disks and verifying checksums.
+*btrfs scrub* is used to scrub a btrfs filesystem, which will read all data
+from all disks and verify checksums.
 
 SUBCOMMAND
 ----------
-- 
2.3.0

