From: Joe Perches <joe@perches.com>
Subject: [PATCH] btrfs: MAINTAINERS entry
Date: Sun, 11 Jan 2009 14:15:05 -0800
Message-ID: <1231712105.1739.112.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Now that btrfs is in mainline, perhaps
a maintainers entry is appropriate?

Perhaps:

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f65a26..138a54c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1021,6 +1021,14 @@ M:	mb@bu3sch.de
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
 
+BTRFS FILE SYSTEM
+P:	Chris Mason
+M:	chris.mason@oracle.com
+L:	linux-btrfs@vger.kernel.org
+W:	http://btrfs.wiki.kernel.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
+S:	Maintained
+
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org


