Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45566 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdFEXcU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 19:32:20 -0400
Received: from blackbox.mgt.dpl.mendix.net (blackbox.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::c])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 5436020293
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Jun 2017 01:32:18 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: send operates on ro snapshots only
Date: Tue,  6 Jun 2017 01:32:18 +0200
Message-Id: <20170605233218.12421-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While talking to another btrfs user on IRC today, it became clear that a
major point of confusion in the btrfs send manual is that it's not
telling the user soon enough that send/receive solely operates on
subvolume snapshots instead of the original (read/write) subvolumes.

So, change the first few alineas to explicitely mention snapshots
instead. Technically, snapshots are also just subvolumes, but requiring
this level of technical detailed knowledge doesn't help the user which
is just trying out things.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 Documentation/btrfs-send.asciidoc | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/btrfs-send.asciidoc b/Documentation/btrfs-send.asciidoc
index 1c5ccbe6..ef345f68 100644
--- a/Documentation/btrfs-send.asciidoc
+++ b/Documentation/btrfs-send.asciidoc
@@ -3,7 +3,7 @@ btrfs-send(8)
 
 NAME
 ----
-btrfs-send - generate a stream of changes between two subvolumes
+btrfs-send - generate a stream of changes between two subvolume snapshots
 
 SYNOPSIS
 --------
@@ -13,20 +13,21 @@ DESCRIPTION
 -----------
 
 This command will generate a stream of instructions that describe changes
-between two subvolumes. The stream can be consumed by the *btrfs receive*
-command to replicate the sent subvolume on a different filesystem.
+between two subvolume snapshots. The stream can be consumed by the *btrfs
+receive* command to replicate the sent snapshot on a different filesystem.
 The command operates in two modes: full and incremental.
 
-All subvolumes involved in one send command must be read-only (ie. the
-read-only snapshots and this status cannot be changed if there's a running send
-operation that uses the subvolume).
+All snapshots involved in one send command must be read-only, and this status
+cannot be changed as long as there's a running send operation that uses the
+snapshot.
 
-In the full mode, the entire subvolume data and metadata will end up in the
+In the full mode, the entire snapshot data and metadata will end up in the
 stream.
 
-In the incremental mode (options '-p' and '-c'), there can be one or more
-parent subvolumes that will establish the base for determining the changes.
-The final stream will be smaller compared to the full mode.
+In the incremental mode (options '-p' and '-c'), previously sent snapshots that
+are available on both the sending and receiving side can be used to reduce the
+amount of information that has to be sent to reconstruct the sent snapshot on a
+different filesystem.
 
 It is allowed to omit the '-p <parent>' option when '-c <clone-src>' options
 are given, in which case *btrfs send* will determine a suitable parent among the
-- 
2.11.0

