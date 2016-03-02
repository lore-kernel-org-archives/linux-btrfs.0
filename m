Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38809 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbcCBQAo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 11:00:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id l68so84278010wml.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 08:00:44 -0800 (PST)
From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: [PATCH] btrfs-convert: document -O|--features flag
Date: Wed,  2 Mar 2016 16:00:28 +0000
Message-Id: <1456934428-2420-1-git-send-email-vytas.dauksa@smoothwall.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy-pasted description found at mkfs.btrfs. I did not bother with
feature list as it seemed to be incomplete.
---
 Documentation/btrfs-convert.asciidoc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/btrfs-convert.asciidoc b/Documentation/btrfs-convert.asciidoc
index ca3417f..3ec7d55 100644
--- a/Documentation/btrfs-convert.asciidoc
+++ b/Documentation/btrfs-convert.asciidoc
@@ -83,6 +83,13 @@ rollback to the original ext2/3/4 filesystem if possible
 set filesystem label during conversion
 -L|--copy-label::
 use label from the converted filesystem
+-O|--features <feature1>[,<feature2>...]::
+A list of filesystem features turned on at btrfs-convert time. Not all features
+are supported by old kernels. To disable a feature, prefix it with '^'.
++
+To see all available features that btrfs-convert supports run:
++
++btrfs-convert -O list-all+
 -p|--progress::
 show progress of conversion, on by default
 --no-progress::
-- 
1.9.1

