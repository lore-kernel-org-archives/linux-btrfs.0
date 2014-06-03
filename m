Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:34022 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaFCLiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 07:38:10 -0400
From: Christian Hesse <mail@eworm.de>
To: linux-btrfs@vger.kernel.org
Cc: Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] btrfs-progs: fix compiler warning
Date: Tue,  3 Jun 2014 13:37:45 +0200
Message-Id: <1401795465-27713-1-git-send-email-mail@eworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gcc 4.9.0 gives a warning: format ‘%d’ expects argument of type ‘int’,
but argument 2 has type ‘u64’

Using %llu and casting to unsigned long long (same as bytenr) fixes this.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 btrfs-select-super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 15e6921..d7cd187 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -100,8 +100,8 @@ int main(int ac, char **av)
 	/* we don't close the ctree or anything, because we don't want a real
 	 * transaction commit.  We just want the super copy we pulled off the
 	 * disk to overwrite all the other copies
-	 */ 
-	printf("using SB copy %d, bytenr %llu\n", num,
+	 */
+	printf("using SB copy %llu, bytenr %llu\n", (unsigned long long)num,
 	       (unsigned long long)bytenr);
 	return ret;
 }
-- 
2.0.0

