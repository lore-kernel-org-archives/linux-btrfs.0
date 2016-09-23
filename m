Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35700 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934834AbcIWVwM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 17:52:12 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 23 Sep 2016 23:51:57 +0200
Message-Id: <20160923215157.11497-1-kilobyte@angband.pl>
Subject: [PATCH] btrfs-progs: docs: document exit codes from scrub
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 Documentation/btrfs-scrub.asciidoc | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index 40e793c..e88e684 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -95,7 +95,14 @@ print separate statistics for each device of the filesystem
 EXIT STATUS
 -----------
 *btrfs scrub* returns a zero exit status if it succeeds. Non zero is
-returned in case of failure.
+returned in case of failure:
+
+1::::
+scrub couldn't be performed
+2::::
+there is nothing to resume
+3::::
+scrub found uncorrectable errors
 
 AVAILABILITY
 ------------
-- 
2.9.3

