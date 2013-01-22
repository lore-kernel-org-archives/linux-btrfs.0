Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:51142 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3AVUwA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 15:52:00 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122205159.TCRB17456.eastrmfepo201.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 15:51:59 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Christian Hesse <list@eworm.de>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH] fix btrfs-progs build
Date: Tue, 22 Jan 2013 15:51:19 -0500
Message-Id: <1358887879-6297-2-git-send-email-gene@czarc.net>
In-Reply-To: <1358887879-6297-1-git-send-email-gene@czarc.net>
References: <20130121164628.GK19967@twin.jikos.cz>
 <1358887879-6297-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Christian Hesse <list@eworm.de>

Hello everybody,

man pages for btrfs-progs are compressed by gzip by default. In Makefile the
variable GZIP is use, this evaluates to 'gzip gzip' on my system. From man
gzip:

> The environment variable GZIP can hold a set of default options for gzip.
> These options are interpreted first and can be overwritten by explicit
> command line parameters.

So using any other variable name fixes this. Patch is attached.

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 man/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
