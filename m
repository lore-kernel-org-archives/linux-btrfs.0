Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:48534 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3ATVEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:38 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210437.TZLL21186.eastrmfepo203.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:37 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Nageswara R Sastry <nasastry@in.ibm.com>, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 01/13] btrfs-progs: btrfs-image.c: Added NULL pointer check.
Date: Sun, 20 Jan 2013 16:04:06 -0500
Message-Id: <1358715858-4469-2-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nageswara R Sastry <nasastry@in.ibm.com>

Check for the return value of 'open_ctree()' before dereferencing it.

Signed-off-by: Nageswara R Sastry <nasastry@in.ibm.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfs-image.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..2a33a55 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -491,6 +491,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	int ret;
 
 	root = open_ctree(input, 0, 0);
+	BUG_ON(!root);
 	BUG_ON(root->nodesize != root->leafsize);
 
 	ret = metadump_init(&metadump, root, out, num_threads,
-- 
1.8.1

