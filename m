Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:44855 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3ATVEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:40 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210439.XERD2891.eastrmfepo101.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:39 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 06/13] btrfs-show-super.c
Date: Sun, 20 Jan 2013 16:04:11 -0500
Message-Id: <1358715858-4469-7-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

remove extra blank line at EOF
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfs-show-super.c |  1 -
 man/Makefile       | 14 +++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index a9e2524..7c66d84 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -281,4 +281,3 @@ static void dump_superblock(struct btrfs_super_block *sb)
 	printf("dev_item.generation\t%llu\n", (unsigned long long)
 	       btrfs_stack_device_generation(&sb->dev_item));
 }
-
diff --git a/man/Makefile b/man/Makefile
index 4a90b75..f7b57f7 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -1,4 +1,4 @@
-GZIP=gzip
+GZIPCMD=gzip
 INSTALL= install
 
 prefix ?= /usr/local
@@ -12,22 +12,22 @@ MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
 all: $(MANPAGES)
 
 mkfs.btrfs.8.gz: mkfs.btrfs.8.in
-	$(GZIP) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
+	$(GZIPCMD) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
 
 btrfs.8.gz: btrfs.8.in
-	$(GZIP) -n -c btrfs.8.in > btrfs.8.gz
+	$(GZIPCMD) -n -c btrfs.8.in > btrfs.8.gz
 
 btrfsctl.8.gz: btrfsctl.8.in
-	$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
+	$(GZIPCMD) -n -c btrfsctl.8.in > btrfsctl.8.gz
 
 btrfsck.8.gz: btrfsck.8.in
-	$(GZIP) -n -c btrfsck.8.in > btrfsck.8.gz
+	$(GZIPCMD) -n -c btrfsck.8.in > btrfsck.8.gz
 
 btrfs-image.8.gz: btrfs-image.8.in
-	$(GZIP) -n -c btrfs-image.8.in > btrfs-image.8.gz
+	$(GZIPCMD) -n -c btrfs-image.8.in > btrfs-image.8.gz
 
 btrfs-show.8.gz: btrfs-show.8.in
-	$(GZIP) -n -c btrfs-show.8.in > btrfs-show.8.gz
+	$(GZIPCMD) -n -c btrfs-show.8.in > btrfs-show.8.gz
 
 clean :
 	rm -f $(MANPAGES)
-- 
1.8.1

