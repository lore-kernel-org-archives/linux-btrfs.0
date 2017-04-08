Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45107 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdDHWiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 18:38:10 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH] btrfs-progs: Fix missing newline in man 5 btrfs
Date: Sun,  9 Apr 2017 00:37:47 +0200
Message-Id: <20170408223747.28157-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The text compress_lzo:: would show up directly after 'bigger than the
page size' on the same line.
---
 Documentation/btrfs-man5.asciidoc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index c8ef1c96..90f16057 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -455,6 +455,7 @@ big_metadata::
 (since: 3.4)
 +
 the filesystem uses 'nodesize' bigger than the page size
+
 compress_lzo::
 (since: 2.6.38)
 +
-- 
2.11.0

