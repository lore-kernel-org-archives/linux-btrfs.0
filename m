From: Christian Hesse <mail@earthworm.de>
Subject: missing include in btrfsck.c
Date: Mon, 31 May 2010 15:45:24 +0200
Message-ID: <201005311545.25546.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_117AMVw7IlO4dPr"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_117AMVw7IlO4dPr
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello everybody,

compiling btrfs-progs from current git I get an error in btrfsck.c about 
undefined references. The attached patch adds an include for sys/stat.h which 
fixes the problem for me.

Regards,
Chris

--Boundary-00=_117AMVw7IlO4dPr
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="btrfsck.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfsck.diff"

Signed-off-by: Christian Hesse <mail@earthworm.de>
--- btrfsck.c	2010-05-31 15:24:40.000000000 +0200
+++ btrfsck.c	2010-05-31 15:23:26.000000000 +0200
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
+#include <sys/stat.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"

--Boundary-00=_117AMVw7IlO4dPr--
