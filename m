Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16525 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2L1DnV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:43:21 -0500
Message-ID: <50DD1524.2080003@oracle.com>
Date: Fri, 28 Dec 2012 11:42:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@gmail.com>, dsterba@suse.cz
Subject: [RFC PATCH v8 0/2] Btrfs: get/set label of a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is the updated version of introduce get/set_or_change label upon a mounted filesystem.

v8->v7:
btrfs_ioc_fs_getlabel():
- Examine the label length with strnlen().
- Tweak up warn() info if the label is not NUL terminated according to Goffredo's suggestions.

The old versions can be found at:
v7:
http://www.spinics.net/lists/linux-btrfs/msg20994.html

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
