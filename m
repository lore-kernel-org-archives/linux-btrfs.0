Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39014 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbaDOHDx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 03:03:53 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F73oev001772
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 15:03:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: Convert man page for btrfs-property.
Date: Tue, 15 Apr 2014 15:04:50 +0800
Message-ID: <1397545492-3054-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert the man page for the newly added btrfs-property subcommand.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile           |  1 +
 Documentation/btrfs-property.txt | 69 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 Documentation/btrfs-property.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index dfacb93..241b41d 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -31,6 +31,7 @@ MAN8_TXT += btrfs-qgroup.txt
 MAN8_TXT += btrfs-replace.txt
 MAN8_TXT += btrfs-dedup.txt
 MAN8_TXT += btrfs-restore.txt
+MAN8_TXT += btrfs-property.txt
 
 MAN_TXT = $(MAN8_TXT)
 MAN_XML = $(patsubst %.txt,%.xml,$(MAN_TXT))
diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
new file mode 100644
index 0000000..82466f9
--- /dev/null
+++ b/Documentation/btrfs-property.txt
@@ -0,0 +1,69 @@
+btrfs-property(8)
+=================
+
+NAME
+----
+btrfs-property - get/set/list properties for given btrfs object.
+
+SYNOPSIS
+--------
+'btrfs property' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs property' is used to get/set/list property, like lable or compression
+state, for given btrfs object.
+
+'btrfs property' provides an unified and user-friendly method to tune different
+btrfs properties instead of using the traditional method like `chattr`(1) or
+`lsattr`(1).
+
+SUBCOMMAND
+----------
+'get' [-t <type>] <object> [<name>]::
+Gets a property from a btrfs object.
++
+If no name is specified, all properties for the given object are
+printed.
+A filesystem object can be a the filesystem itself, a subvolume,
+an inode or a device.
++
+The '-t <type>' option can be used to explicitly
+specify what type of object you meant. This is only needed when a
+property could be set for more then one object type.
++
+Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
++
+The <object> can be path of btrfs device, btrfs mount point, or any
+directories/files inside btrfs.
+
+'set' [-t <type>] <object> <name> <value>::
+Sets a property on a btrfs object.
++
+See description of 'get' subcommand for a description of objects and object
+types.
+
+'list' [-t <type>] <object>::
+Lists available properties with their descriptions for the given object.
++
+Please see the help of 'btrfs property get' for a description of
+objects and object types.
+
+EXIT STATUS
+-----------
+'btrfs property' returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
+`lsattr`(1),
+`setattr`(8)
-- 
1.9.2

