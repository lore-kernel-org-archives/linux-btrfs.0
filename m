Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:59235 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2JOLTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 07:19:05 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 30.20 OK)
	with ESMTP id p03966o9EKhXnS for <linux-btrfs@vger.kernel.org>;
	Mon, 15 Oct 2012 13:19:02 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: use atoll() for mkfs.btrfs size option
Date: Mon, 15 Oct 2012 13:19:02 +0200
Message-Id: <1350299942-23468-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 32 bit systems, a numerical parameter of 2147483648 or above to
the mkfs.btrfs -b option does not work. The parameter is stored in
an u64 but is read using atol() and thus not read correctly.
This patch changes it to use atoll().
Specifying a multiplier (k, m or g) like "100g" in the mkfs.btrfs
parameter list would also be a working workaround.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
The patch is based on the master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

 mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 47f0c9c..e62f0e4 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -80,7 +80,7 @@ static u64 parse_size(char *s)
 		}
 		s[len - 1] = '\0';
 	}
-	ret = atol(s) * mult;
+	ret = atoll(s) * mult;
 	free(s);
 	return ret;
 }
-- 
1.7.12.3

