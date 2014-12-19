Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSQG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:06:26 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 87552AC19
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 16:06:25 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] btrfs-progs: corrupt block, add missing break to option I
Date: Fri, 19 Dec 2014 17:06:25 +0100
Message-Id: <42b74f46eeeae9aa4b93e4316d56e7a165a492ae.1419005022.git.dsterba@suse.cz>
In-Reply-To: <cover.1419005022.git.dsterba@suse.cz>
References: <cover.1419005022.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using -I would imply -d.

Resolves-Coverity-CID: 1258792
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-corrupt-block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index af9ae4d4047c..aeeb1b298f66 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1096,6 +1096,7 @@ int main(int ac, char **av)
 				break;
 			case 'I':
 				corrupt_item = 1;
+				break;
 			case 'd':
 				delete = 1;
 				break;
-- 
2.1.3

