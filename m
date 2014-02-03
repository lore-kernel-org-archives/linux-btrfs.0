Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaBCSXt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:23:49 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6A00CAAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:23:48 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/6] btrfs: send: squeeze bitfilelds in fs_path
Date: Mon,  3 Feb 2014 19:23:47 +0100
Message-Id: <4d22a6e5765bed08ad03749246b0c57403648d56.1391447200.git.dsterba@suse.cz>
In-Reply-To: <cover.1391447200.git.dsterba@suse.cz>
References: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We know that buf_len is at most PATH_MAX, 4k, and can merge it with the
reversed member. This saves 3 bytes in favor of inline_buf.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ea427624e842..cb12c2ec37dc 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -53,8 +53,8 @@ struct fs_path {
 			char *end;
 
 			char *buf;
-			int buf_len;
-			unsigned int reversed:1;
+			unsigned short buf_len:15;
+			unsigned short reversed:1;
 			char inline_buf[];
 		};
 		char pad[PAGE_SIZE];
-- 
1.7.9

