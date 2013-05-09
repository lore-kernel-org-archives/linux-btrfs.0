Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab3EIBd0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 May 2013 21:33:26 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r491XQvo003073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 8 May 2013 21:33:26 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r491XN7l025898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 8 May 2013 21:33:25 -0400
Message-ID: <518AFCE3.6080307@redhat.com>
Date: Wed, 08 May 2013 20:33:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] blktrace: document -k option
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the -k option was missing from the usage() output and was present
only in the man page synopsis.  Say a few more words about it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/blktrace.c b/blktrace.c
index 89aaaac..4e96573 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -450,6 +450,7 @@ static char usage_str[] = "\n\n" \
         "[ -p <port number>   | --port=<port number>]\n" \
         "[ -s                 | --no-sendfile]\n" \
         "[ -I <devs file>     | --input-devs=<devs file>]\n" \
+        "[ -k                 | --kill]\n" \
         "[ -v <version>       | --version]\n" \
         "[ -V <version>       | --version]\n" \
 
@@ -467,6 +468,7 @@ static char usage_str[] = "\n\n" \
 	"\t-p Network port to use (default 8462)\n" \
 	"\t-s Make the network client NOT use sendfile() to transfer data\n" \
 	"\t-I Add devices found in <devs file>\n" \
+	"\t-k Kill a running trace\n" \
 	"\t-v Print program version info\n" \
 	"\t-V Print program version info\n\n";
 
diff --git a/doc/blktrace.8 b/doc/blktrace.8
index b5e69b7..7f13231 100644
--- a/doc/blktrace.8
+++ b/doc/blktrace.8
@@ -163,6 +163,13 @@ This only works when supplying a single device, or when piping the output
 via "-o -" with multiple devices.
 .RE
 
+\-k
+.br
+\-\-kill
+.RS
+Kill a running trace if blktrace dies
+.RE
+
 \-r \fIrel-path\fR
 .br
 \-\-relay=\fIrel-path\fR     

