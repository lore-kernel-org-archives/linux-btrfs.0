Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45159 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756167AbdDPRUO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 13:20:14 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH] btrfs-progs: docs: Fix newlines for man btrfstune
Date: Sun, 16 Apr 2017 19:20:02 +0200
Message-Id: <20170416172002.19261-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of newlines were missing, which resulted in only -S and -r to
show as option after xmlto is used to convert the documentation to a man
page.

The rest of the options would end up being appended to the explanation
of -r.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---

By the way, I have no idea why -r was showing up in the first place, because
it also had no newline before it.

I'm no asciidoc expert, but with consistent newlines, at least for me the
resulting man page does contain all options nicely listed.

 Documentation/btrfstune.asciidoc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index 04295ee3..bf4f495a 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -29,11 +29,13 @@ OPTIONS
 Enable seeding on a given device. Value 1 will enable seeding, 0 will disable it. +
 A seeding filesystem is forced to be mounted read-only. A new device can be added
 to the filesystem and will capture all writes keeping the seeding device intact.
+
 -r::
 (since kernel: 3.7)
 +
 Enable extended inode refs (hardlink limit per file in a directory is 65536),
 enabled by mkfs feature 'extref'.
+
 -x::
 (since kernel: 3.10)
 +
@@ -43,17 +45,21 @@ enabled by mkfs feature 'skinny-metadata'.
 All newly created extents will use the new representation. To completely switch
 the entire filesystem, run a full balance of the metadata. Please refer to
 `btrfs-balance`(8).
+
 -n::
 (since kernel: 3.14)
 +
 Enable no-holes feature (more efficient representation of file holes), enabled
 by mkfs feature 'no-holes'.
+
 -f::
 Allow dangerous changes, e.g. clear the seeding flag or change fsid. Make sure
 that you are aware of the dangers.
+
 -u::
 Change fsid to a randomly generated UUID or continue previous fsid change
 operation in case it was interrupted.
+
 -U <UUID>::
 Change fsid to 'UUID'.
 +
-- 
2.11.0

