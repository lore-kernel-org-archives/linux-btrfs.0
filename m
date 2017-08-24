Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:19457 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdHXHs6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:48:58 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3D944AC00FC
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 16:48:53 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 8EDC36926ED
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 16:48:52 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: doc: add figure 1 to btrfs quota doc
To: <linux-btrfs@vger.kernel.org>
Message-ID: <cda4441c-3623-dd32-e2ee-94b73a9c2512@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 16:48:31 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The document of btrfs quota is missing figure 1.

I notice the body is copy of http://sensille.com/qgroups.pdf (whi
ch is linked from 
https://btrfs.wiki.kernel.org/index.php/Quota_support), and insert the 
figure.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
  Documentation/btrfs-quota.asciidoc | 18 +++++++++++++++++-
  1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-quota.asciidoc 
b/Documentation/btrfs-quota.asciidoc
index ef2e5d3..5bd13cb 100644
--- a/Documentation/btrfs-quota.asciidoc
+++ b/Documentation/btrfs-quota.asciidoc
@@ -96,7 +96,23 @@ instead of '0/ID'.  For all higher levels, the ID can 
be chosen freely.
  Each qgroup can contain a set of lower level qgroups, thus creating a 
hierarchy
  of qgroups. Figure 1 shows an example qgroup tree.

-// TODO: insert Figure 1
+                          +---+
+                          |2/1|
+                          +---+
+                         /     \
+                   +---+/       \+---+
+                   |1/1|         |1/2|
+                   +---+         +---+
+                  /     \       /     \
+            +---+/       \+---+/       \+---+
+qgroups     |0/1|         |0/2|         |0/3|
+            +-+-+         +---+         +---+
+              |          /     \       /     \
+              |         /       \     /       \
+              |        /         \   /         \
+extents       1       2            3            4
+
+ Figure1: Sample qgroup hierarchy

  At the bottom, some extents are depicted showing which qgroups 
reference which
  extents.  It is important to understand the notion of 'referenced' vs
-- 
2.9.5

