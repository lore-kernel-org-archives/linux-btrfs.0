Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:58348 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab2HXN5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:57:20 -0400
Subject: [PATCH v1 0/4] BTRFS sysfs support
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Date: Fri, 24 Aug 2012 15:58:01 +0200
Message-ID: <20120824135322.20478.88578.stgit@venice.bhome>
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
patch which contains an update of the btrfs.txt file (the last one).

The goal of this attempt is to collect comments relating to
which information we should export and which not or the sysfs structure.

For now these information are read-only. In the future we could 
consider the idea to allow updates: for example to change the 
label of a filesystem.

Comments are welcome.
BR
G.Baroncelli


Changelog:

v0:	First issue
v1:	Source cleanup and replacing of the printk with pr_info/pr_warn/
        pr_crit

---

Goffredo Baroncelli (4):
      Add support for sysfs to btrfs.
      Add hook for sysfs to btrfs.
      Add a new Kconfig section to enable or disable the sysfs.
      Btrfs sysfs support documentation.


 fs/btrfs/Kconfig   |    9 
 fs/btrfs/super.c   |    4 
 fs/btrfs/sysfs.c   |  938 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h   |   31 ++
 fs/btrfs/volumes.c |   10 -
 5 files changed, 986 insertions(+), 6 deletions(-)
 create mode 100644 fs/btrfs/sysfs.h

