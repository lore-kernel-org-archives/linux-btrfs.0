Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 11:37:29 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2DFbSJn023254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 11:37:28 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r2DFbR8q007730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 11:37:28 -0400
Message-ID: <51409D37.6060704@redhat.com>
Date: Wed, 13 Mar 2013 10:37:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: document force option in mkfs usage(); add long
 opt
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I missed updating the mkfs.btrfs usage() when I added the
option to force fs overwrite.

Update that, and while we're at it add a long option, since
all other commands have long counterparts.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 41163e0..531e00a 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -39,7 +39,7 @@ mkfs.btrfs uses all the available storage for the filesystem.
 Specify how the data must be spanned across the devices specified. Valid
 values are raid0, raid1, raid10 or single.
 .TP
-\fB\-f\fR
+\fB\-f\fR, \fB\-\-force\fR
 Force overwrite when an existing filesystem is detected on the device.
 By default, mkfs.btrfs will not write to the device if it suspects that 
 there is a filesystem or partition table on the device already.
diff --git a/mkfs.c b/mkfs.c
index be13667..52ae511 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -327,6 +327,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10, dup or single\n");
+	fprintf(stderr, "\t -f --force force overwrite of existing filesystem\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -385,6 +386,7 @@ static char *parse_label(char *input)
 static struct option long_options[] = {
 	{ "alloc-start", 1, NULL, 'A'},
 	{ "byte-count", 1, NULL, 'b' },
+	{ "force", 0, NULL, 'f' },
 	{ "leafsize", 1, NULL, 'l' },
 	{ "label", 1, NULL, 'L'},
 	{ "metadata", 1, NULL, 'm' },

