Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaISBuN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 21:50:13 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 386B13EE0BB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 10:50:11 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 96E51AC08B3
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 10:50:09 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 874731DB803C
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 10:50:08 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id D8A1046E49E
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 10:50:07 +0900 (JST)
Message-ID: <541B8BC7.2080208@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 10:49:59 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: fix many typos in documents
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

There are many trivial typos in Documentation/*.txt.
All of these use "exist status" to mean "exit status"
by mistake. I guess someone first made this mistake
and it has spread by copy-and-paste :-D

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/btrfs-balance.txt          | 2 +-
 Documentation/btrfs-check.txt            | 2 +-
 Documentation/btrfs-device.txt           | 2 +-
 Documentation/btrfs-filesystem.txt       | 2 +-
 Documentation/btrfs-inspect-internal.txt | 2 +-
 Documentation/btrfs-property.txt         | 2 +-
 Documentation/btrfs-qgroup.txt           | 2 +-
 Documentation/btrfs-quota.txt            | 2 +-
 Documentation/btrfs-receive.txt          | 2 +-
 Documentation/btrfs-replace.txt          | 2 +-
 Documentation/btrfs-rescue.txt           | 2 +-
 Documentation/btrfs-restore.txt          | 2 +-
 Documentation/btrfs-scrub.txt            | 2 +-
 Documentation/btrfs-send.txt             | 2 +-
 Documentation/btrfs-subvolume.txt        | 2 +-
 Documentation/btrfs.txt                  | 2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index de93c92..89fd449 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -117,7 +117,7 @@ Profile names, used in profiles and convert are one of: 'raid0', 'raid1',
 
 EXIT STATUS
 -----------
-*btrfs balance* returns a zero exist status if it succeeds. Non zero is
+*btrfs balance* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 961d5ae..8a8073f 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -35,7 +35,7 @@ verify checkums of data blocks.
 
 EXIT STATUS
 -----------
-*btrfs check* returns a zero exist status if it succeeds. Non zero is
+*btrfs check* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 0f7917d..46c54b9 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -100,7 +100,7 @@ Reset stats to zero after reading them.
 
 EXIT STATUS
 -----------
-*btrfs device* returns a zero exist status if it succeeds. Non zero is
+*btrfs device* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index c9c0b00..b0d5820 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -102,7 +102,7 @@ NOTE: the maximum allowable length shall be less than 256 chars
 
 EXIT STATUS
 -----------
-*btrfs filesystem* returns a zero exist status if it succeeds. Non zero is
+*btrfs filesystem* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-inspect-internal.txt b/Documentation/btrfs-inspect-internal.txt
index 5ae4997..05b306a 100644
--- a/Documentation/btrfs-inspect-internal.txt
+++ b/Documentation/btrfs-inspect-internal.txt
@@ -52,7 +52,7 @@ The result is undefined for the so-called empty subvolumes (identified by inode
 
 EXIT STATUS
 -----------
-*btrfs inspect-internal* returns a zero exist status if it succeeds. Non zero is
+*btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 9ed568c..3a71315 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -51,7 +51,7 @@ objects and object types.
 
 EXIT STATUS
 -----------
-*btrfs property* returns a zero exist status if it succeeds. Non zero is
+*btrfs property* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 55c4747..3e13373 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -92,7 +92,7 @@ is used if possible.
 
 EXIT STATUS
 -----------
-*btrfs qgroup* returns a zero exist status if it succeeds. Non zero is
+*btrfs qgroup* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-quota.txt b/Documentation/btrfs-quota.txt
index c092e32..57d6b7e 100644
--- a/Documentation/btrfs-quota.txt
+++ b/Documentation/btrfs-quota.txt
@@ -41,7 +41,7 @@ wait for rescan operation to finish(can be already in progress).
 
 EXIT STATUS
 -----------
-*btrfs quota* returns a zero exist status if it succeeds. Non zero is
+*btrfs quota* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
index beb963c..ed1e247 100644
--- a/Documentation/btrfs-receive.txt
+++ b/Documentation/btrfs-receive.txt
@@ -44,7 +44,7 @@ stream. Default value is 1. A value of 0 means no limit.
 
 EXIT STATUS
 -----------
-*btrfs receive* returns a zero exist status if it succeeds. Non zero is
+*btrfs receive* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index eecf9b0..b329fc0 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -66,7 +66,7 @@ Cancel a running device replace operation.
 
 EXIT STATUS
 -----------
-*btrfs replace* returns a zero exist status if it succeeds. Non zero is
+*btrfs replace* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-rescue.txt b/Documentation/btrfs-rescue.txt
index 82297fa..e0acf09 100644
--- a/Documentation/btrfs-rescue.txt
+++ b/Documentation/btrfs-rescue.txt
@@ -42,7 +42,7 @@ verbose mode.
 
 EXIT STATUS
 -----------
-*btrfs rescue* returns a zero exist status if it succeeds. Non zero is
+*btrfs rescue* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index 2fa2801..57805d7 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -68,7 +68,7 @@ ignore case (--path-regrex only).
 
 EXIT STATUS
 -----------
-*btrfs restore* returns a zero exist status if it succeeds. Non zero is
+*btrfs restore* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index b8d3b65..e9ce1ef 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -82,7 +82,7 @@ Print separate statistics for each device of the filesystem.
 
 EXIT STATUS
 -----------
-*btrfs scrub* returns a zero exist status if it succeeds. Non zero is
+*btrfs scrub* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
index ce926a7..6721428 100644
--- a/Documentation/btrfs-send.txt
+++ b/Documentation/btrfs-send.txt
@@ -43,7 +43,7 @@ An alternative would be to use pipes.
 
 EXIT STATUS
 -----------
-*btrfs send* returns a zero exist status if it succeeds. Non zero is
+*btrfs send* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs-subvolume.txt b/Documentation/btrfs-subvolume.txt
index 789e462..4ee2aa3 100644
--- a/Documentation/btrfs-subvolume.txt
+++ b/Documentation/btrfs-subvolume.txt
@@ -155,7 +155,7 @@ Show information of a given subvolume in the <path>.
 
 EXIT STATUS
 -----------
-*btrfs subvolume* returns a zero exist status if it succeeds. Non zero is
+*btrfs subvolume* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
 AVAILABILITY
diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index 2d121a8..3bdc6b4 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -87,7 +87,7 @@ COMMANDS
 
 EXIT STATUS
 -----------
-*btrfs* returns a zero exist status if it succeeds. Non zero is returned in
+*btrfs* returns a zero exit status if it succeeds. Non zero is returned in
 case of failure.
 
 AVAILABILITY
-- 1.8.3.1 

