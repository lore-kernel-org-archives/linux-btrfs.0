Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:42143 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3ACR0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 12:26:07 -0500
Message-ID: <50E5BF2D.20909@jan-o-sch.net>
Date: Thu, 03 Jan 2013 18:26:05 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sami.liedes@iki.fi, chris.mason@fusionio.com, sensille@gmx.net
Subject: Re: GPF in read_extent_buffer while scrubbing on 3.7.0-rc8-00014-g27d7c2a
References: <20121206143458.GA24396@kashmir> <20121210222125.GA20072@kashmir> <20121214181149.GA15378@kashmir>
In-Reply-To: <20121214181149.GA15378@kashmir>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mathieu,

Sorry for the late reply. I had quite a good reproducer once for what I suspect
may be your problem here - but it suddenly stopped reproducing the problem and I
still haven't figured out why. (see https://patchwork.kernel.org/patch/1773611/
if you're interested)

Can you please give the following patch a try and report back if it helps you
(apply on top of cmason/for-linus, 57ba86c)? If it doesn't, you've got three
choices:

a) forget about the problem
b) send me a dump of your whole file system (space can be provided)
c) receive debug patches, apply them and send me the output

Thanks,
-Jan

------>8---------
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65f0367..d51185e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3324,8 +3324,6 @@ int close_ctree(struct btrfs_root *root)

 	btrfs_dev_replace_suspend_for_unmount(fs_info);

-	btrfs_scrub_cancel(fs_info);
-
 	/* wait for any defraggers to finish */
 	wait_event(fs_info->transaction_wait,
 		   (atomic_read(&fs_info->defrag_running) == 0));
@@ -3392,6 +3390,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
 	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_scrub_cancel(fs_info);

 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
