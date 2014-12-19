Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSQG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:29 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CD835AC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:28 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] btrfs-progs: corrupt block, add break after option U
Date: Fri, 19 Dec 2014 17:06:28 +0100
Message-Id: <e302cda244a100f60584530f2e7cceff408153bc.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resolves-Coverity-CID: 1258793
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-corrupt-block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index aeeb1b298f66..b477e878376b 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1068,6 +1068,7 @@ int main(int ac, char **av)
 				break;
 			case 'U':
 				chunk_tree = 1;
+				break;
 			case 'i':
 				inode = arg_strtou64(optarg);
 				break;
-- 
2.1.3

