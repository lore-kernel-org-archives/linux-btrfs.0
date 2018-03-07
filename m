Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:52276 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754714AbeCGTC5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 14:02:57 -0500
Received: by mail-wm0-f46.google.com with SMTP id t3so6823168wmc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 11:02:57 -0800 (PST)
From: Diego <diegocg@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Improve error stats message
Date: Wed, 07 Mar 2018 20:02:51 +0100
Message-ID: <2011051.lkSedfDimf@archlinux>
In-Reply-To: <20180307182453.GF20688@carfax.org.uk>
References: <1588327.cr4xlG2VNd@archlinux> <20180307182453.GF20688@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El miércoles, 7 de marzo de 2018 19:24:53 (CET) Hugo Mills escribió:
>    On multi-device filesystems, the two are not necessarily the same.

Ouch. FWIW, I was moved to do this because I saw this conversation on
IRC which made me think that people aren't understanding what the
message means:

<nick1>       hi! I noticed bdev rd 13  as a kernel message
<nick1>       what does it mean
<nick2>       Well, that's not the whole message.
<nick2>       Can you paste the whole line in here? (Just one line)
<nick1>       [    3.404959] BTRFS info (device sda4): bdev /dev/sda4 errs: wr 0, rd 13, flush 0, corrupt 0, gen 0


Maybe something like this would be better:

BTRFS info (device sda4): disk /dev/sda4 errors: write 0, read 13, flush 0, corrupt 0, generation 0


---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ceb924ca0d6..cfa029468585 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7239,7 +7239,7 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 	if (!dev->dev_stats_valid)
 		return;
 	btrfs_err_rl_in_rcu(dev->fs_info,
-		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
+		"disk %s errors: write %u, read %u, flush %u, corrupt %u, generation %u",
 			   rcu_str_deref(dev->name),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
-- 
2.16.2




