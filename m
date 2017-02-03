Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34804 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbdBCNtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 08:49:22 -0500
Received: by mail-io0-f196.google.com with SMTP id c80so2245236iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 05:49:22 -0800 (PST)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH] btrfs-progs: better document btrfs receive security
Date: Fri,  3 Feb 2017 08:48:58 -0500
Message-Id: <20170203134858.75210-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds some extra documentation to the btrfs-receive manpage that
explains some of the security related aspects of btrfs-receive.  The
first part covers the fact that the subvolume being received is writable
until the receive finishes, and the second covers the current lack of
sanity checking of the send stream.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

---
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
@@ -68,6 +68,26 @@ dump the stream metadata, one line per operation
 +
 Does not require the 'path' parameter. The filesystem chanded.
 
+SECURITY
+--------
+Because of how *btrfs receive* works, subvolumes that are in the
+process of being received are writable.  As a result of this, there
+is a possibility that a subvolume for which the receive operation just
+completed may not be identical to the originally sent subvolume.
+
+To avoid this in cases where more than one user may have access to the
+area the received subvolumes are being stored, it is reccommended to
+receive subvolumes into a staging area which is only accessible to the
+user who is running receive, and then move then into the final destination
+when the receive command completes.
+
+Additionally, receive does not currently do a very good job of validating
+that an incremental send streams actually makes sense, and it is thus
+possible for a specially crafted send stream to create a subvolume with
+reflinks to arbitrary files in the same filesystem.  Because of this,
+users are advised to not use *btrfs receive* on send streams from
+untrusted sources.
+
 EXIT STATUS
 -----------
 *btrfs receive* returns a zero exit status if it succeeds. Non zero is
-- 
2.11.0

