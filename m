Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49442 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaLSHXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 02:23:17 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 4FB473EE188
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:23:16 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 45B11AC036E
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:23:15 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D2E31E08004
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:23:14 +0900 (JST)
Message-ID: <5493D249.5020207@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 16:22:49 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: naota <naota@elisp.net>
Subject: [PATCH] btrfs-progs: Enhance the document of btrfs property
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Enhance the document of btrfs property as follows.

- Add the description about the candidates of <name>.
- Enrich the description of <object>.
- Fix typos and some redundancy.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reported-by: Naohiro Aota <naota@elisp.net>

---
 Documentation/btrfs-property.txt | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 3a71315..f8dcbab 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -11,8 +11,9 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-*btrfs property* is used to get/set/list property, like lable or compression
-state, for given btrfs object.
+*btrfs property* is used to get/set/list property for given btrfs object.
+See the description of *get* subcommand for more information about
+both btrfs object and property.
 
 *btrfs property* provides an unified and user-friendly method to tune different
 btrfs properties instead of using the traditional method like `chattr`(1) or
@@ -23,31 +24,36 @@ SUBCOMMAND
 *get* [-t <type>] <object> [<name>]::
 Gets a property from a btrfs object.
 +
-If no name is specified, all properties for the given object are
-printed.
-A filesystem object can be a the filesystem itself, a subvolume,
-an inode or a device.
+A btrfs object, which is set by <object>, can be a btrfs filesystem
+itself, a btrfs subvolume, an inode(file or directory) inside btrfs,
+or a device on which a btrfs exists.
 +
+Set the name of property by '<name>'. If no '<name>' is specified,
+all properties for the given object are printed. '<name>' is one of
+the followings.
++
+ro::::
+read-only flag of subvolume: true or false
+label::::
+label of device
+compression::::
+compression setting for an inode: lzo, zlib, or "" (empty string)
+
 The '-t <type>' option can be used to explicitly
 specify what type of object you meant. This is only needed when a
 property could be set for more then one object type.
 +
 Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
-+
-The <object> can be path of btrfs device, btrfs mount point, or any
-directories/files inside btrfs.
 
 *set* [-t <type>] <object> <name> <value>::
 Sets a property on a btrfs object.
 +
-See description of *get* subcommand for a description of objects and object
-types.
+See the description of *get* subcommand for the meaning of each option.
 
 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
 +
-Please see the help of *btrfs property get* for a description of
-objects and object types.
+See the description of *get* subcommand for the meaning of each option.
 
 EXIT STATUS
 -----------
-- 
1.8.3.1

