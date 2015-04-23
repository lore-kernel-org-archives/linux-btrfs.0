Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34602 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966600AbbDWQu2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:50:28 -0400
Received: by qkgx75 with SMTP id x75so14301824qkg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 09:50:28 -0700 (PDT)
Message-ID: <553922D2.90303@gmail.com>
Date: Thu, 23 Apr 2015 12:50:26 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: restore: document metadata restore.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <55392221.6090502@gmail.com>

This was lost in the cleanup of 71a559

Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
---
 Documentation/btrfs-restore.asciidoc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/btrfs-restore.asciidoc b/Documentation/btrfs-restore.asciidoc
index 20fc366..89e0c87 100644
--- a/Documentation/btrfs-restore.asciidoc
+++ b/Documentation/btrfs-restore.asciidoc
@@ -29,6 +29,9 @@ get snapshots, btrfs restore skips snapshots in default.
 -x::
 get extended attributes.
 
+-m|--metadata::
+restore owner, mode and times.
+
 -v::
 verbose.
 
-- 
2.1.4

