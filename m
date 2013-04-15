Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab3DOS7c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 14:59:32 -0400
Date: Mon, 15 Apr 2013 11:59:26 -0700
From: Zach Brown <zab@redhat.com>
To: Dan McGrath <danmcgrath.ca@gmail.com>
Cc: Jan Alexander Steffens <jan.steffens@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
Message-ID: <20130415185926.GD16091@lenny.home.zabbo.net>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
 <1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
 <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
 <CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK82gMGSGaNywR=RkEQcNbQiMW5-z2O3ZqkMwKtamEdRH+A7aQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Anyways, thought I would reply back with some insight on the matter
> and see what others had to say, since I am in no position to dictate
> the direction that brtfsck/fsck.btrfs should take as far as wrapper
> script or no is concerned. Look forward to your replies! o/

FWIW: debian has been carrying a patch to ignore fsck args to help it
run as fsck.btrfs.  I think modern versions of their btrfs-tools package
that are based on more recent btrfs-progs also include the hunk to
recognize being called as fsck.btrfs.

It might be worth finding someone who knows the history of the debian
package.  I'm certainly not that person :).  Here's the result of some
light googling:

  http://ftp.de.debian.org/debian/pool/main/b/btrfs-tools/btrfs-tools_0.19+20130131-3+really20121004-1.debian.tar.xz

debian/patches/08-fsck.patch:

Author: Sten Heinze <shze@gmx.de>
Description:
 Ignore all arguments starting with -a in btrfsck for the time being
 (Closes: #567681, #571300, #612809, #668832).

diff -Naurp btrfs-tools.orig/btrfsck.c btrfs-tools/btrfsck.c
--- btrfs-tools.orig/btrfsck.c	2012-12-10 10:44:57.283351955 +0100
+++ btrfs-tools/btrfsck.c	2012-12-10 10:56:20.971516720 +0100
@@ -3477,6 +3477,12 @@ static void print_usage(void)
 	exit(1);
 }
 
+static void print_info(void)
+{
+	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	exit(0);
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -3501,7 +3507,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "s:", long_options,
+		c = getopt_long(ac, av, "s:anry", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -3514,6 +3520,12 @@ int main(int ac, char **av)
 				break;
 			case '?':
 				print_usage();
+				break;
+			case 'a':
+			case 'n':
+			case 'r':
+			case 'y':
+				print_info();
 		}
 		if (option_index == 1) {
 			printf("enabling repair mode\n");

