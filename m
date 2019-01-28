Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E984C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E64920844
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548694751;
	bh=4MoP4x3WdQsy5scJJWksfvWarQP2V6vrYVzyBSFElY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=htfBJ/75fObv8nk+sv0MOC7v9CRxyeWPTxNxiXZNN5hv+jrf4HCta9IzItPmdireE
	 mt82G6rzHHH4yFvBht2vu+AEHZK6CozNfyIAmlAH4we9HWl7JJIAic+XfJoXIkaVHu
	 W+1HVYuS+m8DeHx8FRh0VYN6/Qw2SWSQ4+AVPzMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfA1Q7K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387974AbfA1QQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 11:16:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC402086C;
        Mon, 28 Jan 2019 16:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548692192;
        bh=4MoP4x3WdQsy5scJJWksfvWarQP2V6vrYVzyBSFElY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ey4oWji3zLpZM43GHqTq0ed9LHj7DqLwsBFIw2W5zshviI0JrJtwp5WpcbJ64imR2
         /z3xdICLM5VSTI9/U5QTTyGM4zBUOFufqFSkCQ3/ImR2RhmxoVyNLoFndCefjK9RlZ
         DqUHHmI5FVfQICzRTL3GzMXsb/VtOwSDZy9sqOFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 104/170] btrfs: harden agaist duplicate fsid on scanned devices
Date:   Mon, 28 Jan 2019 11:10:54 -0500
Message-Id: <20190128161200.55107-104-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128161200.55107-1-sashal@kernel.org>
References: <20190128161200.55107-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit a9261d4125c97ce8624e9941b75dee1b43ad5df9 ]

It's not that impossible to imagine that a device OR a btrfs image is
copied just by using the dd or the cp command. Which in case both the
copies of the btrfs will have the same fsid. If on the system with
automount enabled, the copied FS gets scanned.

We have a known bug in btrfs, that we let the device path be changed
after the device has been mounted. So using this loop hole the new
copied device would appears as if its mounted immediately after it's
been copied.

For example:

Initially.. /dev/mmcblk0p4 is mounted as /

  $ lsblk
  NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
  mmcblk0     179:0    0 29.2G  0 disk
  |-mmcblk0p4 179:4    0    4G  0 part /
  |-mmcblk0p2 179:2    0  500M  0 part /boot
  |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
  `-mmcblk0p1 179:1    0  256M  0 part /boot/efi

  $ btrfs fi show
     Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
     Total devices 1 FS bytes used 1.40GiB
     devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4

Copy mmcblk0 to sda

  $ dd if=/dev/mmcblk0 of=/dev/sda

And immediately after the copy completes the change in the device
superblock is notified which the automount scans using btrfs device scan
and the new device sda becomes the mounted root device.

  $ lsblk
  NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
  sda           8:0    1 14.9G  0 disk
  |-sda4        8:4    1    4G  0 part /
  |-sda2        8:2    1  500M  0 part
  |-sda3        8:3    1  256M  0 part
  `-sda1        8:1    1  256M  0 part
  mmcblk0     179:0    0 29.2G  0 disk
  |-mmcblk0p4 179:4    0    4G  0 part
  |-mmcblk0p2 179:2    0  500M  0 part /boot
  |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
  `-mmcblk0p1 179:1    0  256M  0 part /boot/efi

  $ btrfs fi show /
    Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
    Total devices 1 FS bytes used 1.40GiB
    devid    1 size 4.00GiB used 3.00GiB path /dev/sda4

The bug is quite nasty that you can't either unmount /dev/sda4 or
/dev/mmcblk0p4. And the problem does not get solved until you take sda
out of the system on to another system to change its fsid using the
'btrfstune -u' command.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9663b6aa2a56..1e8d216720a2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -696,6 +696,35 @@ static noinline int device_list_add(const char *path,
 			return -EEXIST;
 		}
 
+		/*
+		 * We are going to replace the device path for a given devid,
+		 * make sure it's the same device if the device is mounted
+		 */
+		if (device->bdev) {
+			struct block_device *path_bdev;
+
+			path_bdev = lookup_bdev(path);
+			if (IS_ERR(path_bdev)) {
+				mutex_unlock(&fs_devices->device_list_mutex);
+				return ERR_CAST(path_bdev);
+			}
+
+			if (device->bdev != path_bdev) {
+				bdput(path_bdev);
+				mutex_unlock(&fs_devices->device_list_mutex);
+				btrfs_warn_in_rcu(device->fs_info,
+			"duplicate device fsid:devid for %pU:%llu old:%s new:%s",
+					disk_super->fsid, devid,
+					rcu_str_deref(device->name), path);
+				return ERR_PTR(-EEXIST);
+			}
+			bdput(path_bdev);
+			btrfs_info_in_rcu(device->fs_info,
+				"device fsid %pU devid %llu moved old:%s new:%s",
+				disk_super->fsid, devid,
+				rcu_str_deref(device->name), path);
+		}
+
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
 			return -ENOMEM;
-- 
2.19.1

