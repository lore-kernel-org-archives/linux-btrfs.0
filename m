Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2GQKlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 06:41:17 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fsck: understand the -s option
Date: Tue, 17 Jul 2012 12:41:13 +0200
Message-Id: <1342521673-25510-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Short options have to be repeated at the getopt_long call.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfsck.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 088b9f4..2e81adc 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3499,7 +3499,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "", long_options,
+		c = getopt_long(ac, av, "s:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
-- 
1.7.6.233.gd79bc

