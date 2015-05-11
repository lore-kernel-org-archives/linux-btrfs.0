Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661AbbEKIJK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:10 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87lfj028793
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 13/13] btrfs-progs: Update Doc for btrfs-property
Date: Mon, 11 May 2015 16:08:54 +0800
Message-ID: <1431331734-11714-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update offline related new function for btrfs-property.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Seperated from previous patch.
---
 Documentation/btrfs-property.asciidoc | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
index 8b9b7f0..c7239ef 100644
--- a/Documentation/btrfs-property.asciidoc
+++ b/Documentation/btrfs-property.asciidoc
@@ -32,7 +32,8 @@ The '-t <type>' option can be used to explicitly
 specify what type of object you meant. This is only needed when a
 property could be set for more then one object type.
 +
-Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
+Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]', 'd[evice]' and
+'o[ffline]'.
 +
 Set the name of property by '<name>'. If no '<name>' is specified,
 all properties for the given object are printed. '<name>' is one of
@@ -44,6 +45,20 @@ label::::
 label of device
 compression::::
 compression setting for an inode: lzo, zlib, or "" (empty string)
+fsid::::
+fsid for an offline btrfs: 36 bytes UUID string in `printf`(3) format:
+"%08x-%04x-%04x-%04x-%012x"
+chunk_tree_uuid::::
+chunk tree uuid for an offline btrfs: 36 bytes UUID, same as 'fsid'.
+
+
+NOTE: To use 'fsid' and 'chunk_tree_uuid' in 'offline' type, '-t offline' must
+be specified explicitly, as most offline operation are dangerous and user
+should be aware of the danger.
+
+WARNING: If process of changing 'fsid' or 'chunk_tree_uuid' is canceled, the
+filesystem will not be mountable as it is in a inconsistent status. To make it
+mountable again, the uuid change needs to be reran and ensure it completes.
 
 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
-- 
2.4.0

