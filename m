Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935908AbeFSFMd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 01:12:33 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Paul Jones <paul@pauljones.id.au>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs-progs: Fix wrong optind re-initialization to allow mixed option and non-option
Date: Tue, 19 Jun 2018 13:12:24 +0800
Message-Id: <20180619051224.21876-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function handle_global_options(), we reset @optind to 1.
However according to man page of getopt(3) NOTES section, if we need to
rescan options later, @optind should be reset to 0 to initialize the
internal variables correctly.

This explains the reason why in cmd_check(), getopt_long() doesn't
handle the following command correctly:
"btrfs check /dev/data/btrfs --check-data-csum"

While mkfs.btrfs handles mixed non-option and option correctly:
"mkfs.btrfs -f /dev/data/disk1 --data raid1 /dev/data/disk2"

Cc: Paul Jones <paul@pauljones.id.au>
Cc: Hugo Mills <hugo@carfax.org.uk>
Fixes: 010ceab56e06 ("btrfs-progs: rework option parser to use getopt for global options")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 2d39f2ced3e8..ebc4a507165d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -169,7 +169,7 @@ static int cmd_version(int argc, char **argv)
  * Parse global options, between binary name and first non-option argument
  * after processing all valid options (including those with arguments).
  *
- * Returns index to argv where parsting stopped, optind is reset to 1
+ * Returns index to argv where parsting stopped, optind is reset to 0
  */
 static int handle_global_options(int argc, char **argv)
 {
@@ -205,7 +205,13 @@ static int handle_global_options(int argc, char **argv)
 	}
 
 	shift = optind;
-	optind = 1;
+	/*
+	 * optind must to be init to 0 other than 1.
+	 * Since later subcommand will call getopt_long() again, we need
+	 * to re-initialize the internal variables correct.
+	 * Check getopt(3) NOTES sections.
+	 */
+	optind = 0;
 
 	return shift;
 }
-- 
2.17.1

