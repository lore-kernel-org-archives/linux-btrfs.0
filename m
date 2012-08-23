Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:47359 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236Ab2HWMRr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 08:17:47 -0400
Received: from venice.bhome (151.24.44.165) by smtp207.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F970547F248 for linux-btrfs@vger.kernel.org; Thu, 23 Aug 2012 14:11:54 +0200
Subject: [PATCH v0 0/4] BTRFS sysfs support
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Thu, 23 Aug 2012 14:12:36 +0200
Message-ID: <20120823120505.12203.11658.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
The following series restores the BTRFS sysfs support. My idea is to
exporting some information via sysfs to get rid of some ioctl(s) which
are particular solution of a more general problem: exporting information
from kernel space to user space.

These patches export basically the fields of the following structure:
- btrfs_device
- btrfs_fs_info
- btrfs_fs_devices

You can read more about which information are exported reading the
patch (the last one) which contains an update of the btrfs.txt file.

The goal of this first attempt is to collect comments relating to
which information we should export and which not or the sysfs structure.

For now these information are read-only. In the future we could 
consider the idea to make some action: for example to change the 
label of a filesystem.

Comments are welcome.
BR
G.Baroncelli



---

Goffredo Baroncelli (4):
      Add support for sysfs to btrfs.
      Add hook for sysfs to btrfs.
      Add a new Kconfig section to enable or disable the sysfs.
      Btrfs sysfs support documentation.


 fs/btrfs/Kconfig   |    9 +
 fs/btrfs/super.c   |    4 
 fs/btrfs/sysfs.c   |  933 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h   |   31 ++
 fs/btrfs/volumes.c |   15 +
 5 files changed, 986 insertions(+), 6 deletions(-)
 create mode 100644 fs/btrfs/sysfs.h

