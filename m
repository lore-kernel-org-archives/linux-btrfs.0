Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([80.190.48.209]:38321 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2JHOZV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 10:25:21 -0400
Received: from leda (unknown [10.5.1.215])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mx.mylinuxtime.de (Postfix) with ESMTPSA id 9A42EBDC001
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2012 16:17:17 +0200 (CEST)
Date: Mon, 8 Oct 2012 16:17:13 +0200
From: Christian Hesse <list@eworm.de>
To: linux-btrfs@vger.kernel.org
Subject: fix btrfs-progs build
Message-ID: <20121008161713.218a6eb1@leda>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/9E8u6ic0gsRwW.zLpEcwrrL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/9E8u6ic0gsRwW.zLpEcwrrL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody,

man pages for btrfs-progs are compressed by gzip by default. In Makefile the
variable GZIP is use, this evaluates to 'gzip gzip' on my system. From man
gzip:

> The environment variable GZIP can hold a set of default options for gzip.
> These options are interpreted first and can be overwritten by explicit
> command line parameters.

So using any other variable name fixes this. Patch is attached.
-- 
main(a){char*c=/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=0;b=c[a++];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}

--MP_/9E8u6ic0gsRwW.zLpEcwrrL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=btrfs-progs.diff

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

--MP_/9E8u6ic0gsRwW.zLpEcwrrL--
