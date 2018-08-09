Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38890 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeHIUcB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:01 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 06/17] btrfs: disable direct IO in HMZONED mode
Date: Fri, 10 Aug 2018 03:04:39 +0900
Message-Id: <20180809180450.5091-7-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Direct write I/Os can be directed at existing extents that have already
been written. Such write requests are prohibited on host-managed zoned
block devices. So disable direct IO support for a volume with HMZONED mode
enabled.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 212fa71317d6..05f5e05ccf37 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8523,6 +8523,9 @@ static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
 	unsigned int blocksize_mask = fs_info->sectorsize - 1;
 	ssize_t retval = -EINVAL;
 
+	if (btrfs_fs_incompat(fs_info, HMZONED))
+		goto out;
+
 	if (offset & blocksize_mask)
 		goto out;
 
-- 
2.18.0

