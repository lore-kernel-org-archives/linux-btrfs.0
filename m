Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2GQKwH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 06:52:07 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: sort devices by id in fi show
Date: Tue, 17 Jul 2012 12:51:59 +0200
Message-Id: <1342522319-26017-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Devids are printed in descending order now, switch it to ascending.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 btrfs-show.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-show.c b/btrfs-show.c
index 8210fd2..2a85932 100644
--- a/btrfs-show.c
+++ b/btrfs-show.c
@@ -77,7 +77,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 
 	free(super_bytes_used);
 
-	list_for_each(cur, &fs_devices->devices) {
+	list_for_each_prev(cur, &fs_devices->devices) {
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-- 
1.7.6.233.gd79bc

