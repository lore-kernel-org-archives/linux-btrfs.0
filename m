Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:16603 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdHXHkC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:40:02 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CA94AAC0106
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 16:39:57 +0900 (JST)
Received: from G01JPEXCHYT16.g01.fujitsu.local (G01JPEXCHYT16.g01.fujitsu.local [10.128.194.55])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 11BD846E820
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 16:39:57 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: doc: fix btrfs-inspect-internal rootid doc
Message-ID: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
Date: Thu, 24 Aug 2017 16:39:53 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs inspect-internal rootid <path>" rejects a file to be specified in 
the implementation.
Therefore change "file or directory" to "directory" in the doc.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
   Documentation/btrfs-inspect-internal.asciidoc | 2 +-
   1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc
b/Documentation/btrfs-inspect-internal.asciidoc
index 62b1029..a1ed1a3 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -136,7 +136,7 @@ resize operation, this may be useful before 
executing the actual resize operatio
   specify the device 'id' to query, default is 1 if this option is not used

   *rootid* <path>::
-for a given file or directory, return the containing tree root id, for a
+for a given directory, return the containing tree root id, for a
   subvolume itself return it's own tree id (ie. subvol id)
   +
   NOTE: The result is undefined for the so-called empty subvolumes 
(identified by
--
2.9.5

