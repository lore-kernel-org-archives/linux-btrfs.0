Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaJJRbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 13:31:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A5DCBAB1D
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 17:31:14 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: document the limit balance filter
Date: Fri, 10 Oct 2014 19:31:13 +0200
Message-Id: <1412962273-15269-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-balance.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index 89fd44901a9d..e1ad6511571c 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -102,6 +102,11 @@ specified as <start..end>.
 Convert each selected block group to the given profile name identified by
 parameters.
 
+*limit*::::
+Process only given number of chunks, after all filters apply. This can be used
+to specifically target a chunk in connection with other filters (drange,
+vrange) or just simply limit the amount of work done by a single balance run.
+
 *soft*::::
 Takes no parameters. Only has meaning when converting between profiles.
 When doing convert from one profile to another and soft mode is on,
-- 
2.1.1

