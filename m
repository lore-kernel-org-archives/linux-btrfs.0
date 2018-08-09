Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45242 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeHIUcE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:04 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 07/17] btrfs: disable device replace in HMZONED mode
Date: Fri, 10 Aug 2018 03:04:40 +0900
Message-Id: <20180809180450.5091-8-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To enable device replacing feature in HMZONED mode, we should avoid write
replicating from replace source device to replace target device so that we
do not write to a location after the position of a zone's device write
pointer. In addition, scrub process should be modified to dispatch the
write I/Os sequentially and to fill holes between the extents. Finally,
write pointers of the zones should be synchronized to match with RAID
siblings in a RAID case.

It needs more works to solve all these issues. So disable the device
replace feature in HMZONED mode for now.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/dev-replace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 839a35008fd8..cde61fb217db 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -416,6 +416,9 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_device *src_device = NULL;
 
+	if (btrfs_fs_incompat(fs_info, HMZONED))
+		return -EOPNOTSUPP;
+
 	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
 					    srcdev_name, &src_device);
 	if (ret)
-- 
2.18.0

