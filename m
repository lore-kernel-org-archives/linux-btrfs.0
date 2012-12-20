Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2LTIoO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 03:44:14 -0500
Message-ID: <50D2CF95.1070905@oracle.com>
Date: Thu, 20 Dec 2012 16:43:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com, kreijack@inwind.it,
        dsterba@suse.cz
Subject: [RFC PATCH v7 0/2] Btrfs: get/set label of a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Per David's comments upon v6, I missed a check up against the return value of btrfs_end_transaction for
btrfs_ioctl_fs_setlabel(), it was fixed in this version.

v7->v6:
- take care of btrfs_end_transaction() in btrfs_ioctl_fs_setlabel() rather than keeping silence.

The old versions can be found at:
v6:
http://www.spinics.net/lists/linux-btrfs/msg20922.html

v5:
http://www.spinics.net/lists/linux-btrfs/msg20888.html

v4:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21618

v3:
https://patchwork.kernel.org/patch/1124642/

v2:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12877

v1:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12872

Thanks,
-Jeff
