Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbeHFIHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:07:46 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DE59AE1A
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 06:00:17 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: Doc: Update btrfs-qgroup for the rescan condition
Date: Mon,  6 Aug 2018 14:00:08 +0800
Message-Id: <20180806060008.9556-4-wqu@suse.com>
In-Reply-To: <20180806060008.9556-1-wqu@suse.com>
References: <20180806060008.9556-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new section, RESCAN CONDITION, to explain why and when we need a
full quota rescan when assigning/removing qgroup relationship.

Also, since 'remove' shares the same options of 'assign', add reference
to 'assign' options for 'remove' subcommand.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-qgroup.asciidoc | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index fee173860000..d1c8fedc94d4 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -49,8 +49,10 @@ identified by <path>.
 --rescan::::
 (Default) Automatically schedule quota rescan if the new qgroup assignment
 leads to quota inconsistency.
+Check `RESCAN CONDITION` for more info.
 --no-rescan::::
-Explicitly ask not to do a rescan.
+Explicitly ask not to do a rescan, even if the assigning makes quota
+inconsistent.
 
 *create* <qgroupid> <path>::
 Create a subvolume quota group.
@@ -83,6 +85,10 @@ limit space exclusively assigned to this qgroup.
 *remove* <src> <dst> <path>::
 Remove the relationship between child qgroup <src> and parent qgroup <dst> in
 the btrfs filesystem identified by <path>.
++
+`Options`
++
+The same as *assign* subcommand.
 
 *show* [options] <path>::
 Show all qgroups in the btrfs filesystem identified by <path>.
@@ -131,6 +137,20 @@ If multiple <attr>s is given, use comma to separate.
 To retrieve information after updating the state of qgroups,
 force sync of the filesystem identified by <path> before getting information.
 
+RESCAN CONDITION
+----------------
+Btrfs quota only keep records of how many bytes are referred to ('rfer') and
+how many bytes are owned exclusively ('excl').
+It doesn't keep any record of which extent is owned exclusively or shared.
+
+This means when qgroup relationship changes, extents owners change and qgroups
+number are no longer consistent unless we do a full rescan.
+
+However there are cases we can avoid full rescan, if a subvolume whose 'rfer'
+number equals its 'excl' number, which means all bytes are exclusive owned,
+then assigning/removing this subvolume only needs to add/subtract 'rfer' number
+from its parent qgroup.
+
 EXIT STATUS
 -----------
 *btrfs qgroup* returns a zero exit status if it succeeds. Non zero is
-- 
2.18.0

