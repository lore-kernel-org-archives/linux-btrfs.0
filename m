Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:56682 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab2GQPCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 11:02:13 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp2) (RZmta 29.19 OK)
	with ESMTP id g04677o6GKBcbO for <linux-btrfs@vger.kernel.org>;
	Tue, 17 Jul 2012 17:02:11 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: suppress printk() if all device I/O stats are zero
Date: Tue, 17 Jul 2012 17:02:11 +0200
Message-Id: <79927ec7bfec05276fcec8b1d0392c4685ef4048.1342534465.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1342534465.git.sbehrens@giantdisaster.de>
References: <cover.1342534465.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1342534465.git.sbehrens@giantdisaster.de>
References: <cover.1342534465.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Code is added to suppress the I/O stats printing at mount time if all
statistic values are zero.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6f04dae..d11606c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4877,6 +4877,14 @@ void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 
 static void btrfs_dev_stat_print_on_load(struct btrfs_device *dev)
 {
+	int i;
+
+	for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++)
+		if (btrfs_dev_stat_read(dev, i) != 0)
+			break;
+	if (i == BTRFS_DEV_STAT_VALUES_MAX)
+		return; /* all values == 0, suppress message */
+
 	printk_in_rcu(KERN_INFO "btrfs: bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u\n",
 	       rcu_str_deref(dev->name),
 	       btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
-- 
1.7.11.2

