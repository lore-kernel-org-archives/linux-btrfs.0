Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33360 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdBCTiR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 14:38:17 -0500
Received: by mail-io0-f194.google.com with SMTP id 101so3261441iom.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 11:38:17 -0800 (PST)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: g.btrfs@cobb.uk.net, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH v2] btrfs-progs: better document btrfs receive security
Date: Fri,  3 Feb 2017 14:38:05 -0500
Message-Id: <20170203193805.96977-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds some extra documentation to the btrfs-receive manpage that
explains some of the security related aspects of btrfs-receive.  The
first part covers the fact that the subvolume being received is writable
until the receive finishes, and the second covers the current lack of
sanity checking of the send stream.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Suggested-by: Graham Cobb <g.btrfs@cobb.uk.net>

---
Chages since v1:
    * Updated the description based on suggestions from Graham Cobb.

Inspired by a recent thread on the ML.

This could probably be more thorough, but I felt it was more important
to get it documented as quickly as possible, and this should cover the
basic info that most people will care about.

 Documentation/btrfs-receive.asciidoc | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index a6838e5e..1ada396f 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -31,7 +31,7 @@ the stream, and print the stream metadata, one operation per line.
 
 3. default subvolume has changed or you didn't mount the filesystem at the toplevel subvolume
 
-A subvolume is made read-only after the receiving process finishes succesfully.
+A subvolume is made read-only after the receiving process finishes succesfully (see BUGS below).
 
 `Options`
 
@@ -68,6 +68,26 @@ dump the stream metadata, one line per operation
 +
 Does not require the 'path' parameter. The filesystem chanded.
 
+BUGS
+----
+*btrfs receive* sets the subvolume read-only after it completes
+successfully.  However, while the receive is in progress, users who have
+write access to files or directories in the receiving 'path' can add,
+remove, or modify files, in which case the resulting read-only subvolume
+will not be an exact copy of the sent subvolume.
+
+If the intention is to create an exact copy, the receiving 'path'
+should be protected from access by users until the receive operation
+has completed and the subvolume is set to read-only.
+
+Additionally, receive does not currently do a very good job of validating
+that an incremental send streams actually makes sense, and it is thus
+possible for a specially crafted send stream to create a subvolume with
+reflinks to arbitrary files in the same filesystem.  Because of this,
+users are advised to not use *btrfs receive* on send streams from
+untrusted sources, and to protect trusted streams when sending them
+across untrusted networks.
+
 EXIT STATUS
 -----------
 *btrfs receive* returns a zero exit status if it succeeds. Non zero is
-- 
2.11.0
