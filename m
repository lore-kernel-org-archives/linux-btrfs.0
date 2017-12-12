Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:38982 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdLLHIb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 02:08:31 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id C6C99AC0090
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 16:08:26 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id EE30DBD66E6
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 16:08:25 +0900 (JST)
Subject: [PATCH 2/2] btrfs-progs: doc: remove explanation of 'X' attribute
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6dabbe1b-87a2-77cd-4fca-9835a1573961@jp.fujitsu.com>
Message-ID: <93de4c81-b80e-068c-3f4b-30860febc7fe@jp.fujitsu.com>
Date: Tue, 12 Dec 2017 16:08:17 +0900
MIME-Version: 1.0
In-Reply-To: <6dabbe1b-87a2-77cd-4fca-9835a1573961@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

e2fsprogs has removed compression support since v1.43 and there is no field
'X' (no compress) for lxattr now. So, just remove the explanation.

Instead, "property get" can be used to check whether no compress flag is
set.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-man5.asciidoc | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index dd436cd1..caeec41b 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -642,12 +642,6 @@ long as this attribute is set (obviously the exception is unsetting the attribut
 'synchronous updates', for more details search `open`(2) for 'O_SYNC' and
 'O_DSYNC'
 
-*X*::
-'no compression', permanently turn off compression on the given file, other
-compression mount options will not affect that
-+
-When set on a directory, all newly created files will inherit this attribute.
-
 No other attributes are supported.  For the complete list please refer to the
 `chattr`(1) manual page.
 
-- 
2.13.6

