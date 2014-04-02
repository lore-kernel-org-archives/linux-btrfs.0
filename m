Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758211AbaDBI3L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:11 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SxNr015004
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 26/27] btrfs-progs: Convert man page for mkfs.btrfs.
Date: Wed, 2 Apr 2014 16:29:37 +0800
Message-ID: <1396427378-10487-27-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for mkfs.btrfs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile       |   2 +-
 Documentation/mkfs.btrfs.txt | 133 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mkfs.btrfs.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 4100ddd..97a775a 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -13,7 +13,7 @@ MAN8_TXT += btrfs-show-super.txt
 MAN8_TXT += btrfstune.txt
 MAN8_TXT += btrfs-zero-log.txt
 MAN8_TXT += fsck.btrfs.txt
-#MAN8_TXT += mkfs.btrfs.txt
+MAN8_TXT += mkfs.btrfs.txt
 
 # Sub commands for btrfs
 MAN8_TXT += btrfs-subvolume.txt
diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
new file mode 100644
index 0000000..bafe065
--- /dev/null
+++ b/Documentation/mkfs.btrfs.txt
@@ -0,0 +1,133 @@
+mkfs.btrfs(8)
+=============
+
+NAME
+----
+mkfs.btrfs - create a btrfs filesystem
+
+SYNOPSIS
+--------
+'mkfs.btrfs'
+$$[-A|--alloc-start <alloc-start>]$$
+$$[-b|--byte-count <byte-count>]$$
+$$[-d|--data <data-profile>]$$
+$$[-f|--force]$$
+$$[-n|--nodesize <nodesize>]$$
+$$[-l|--leafsize <leafsize>]$$
+$$[-L|--label <label>]$$
+$$[-m|--metadata <metadata profile>]$$
+$$[-M|--mixed]$$
+$$[-s|--sectorsize <sectorsize>]$$
+$$[-r|--rootdir <rootdir>]$$
+$$[-K|--nodiscard]$$
+$$[-O|--features <feature1>[<,feature2...>]]$$
+$$[-h]$$
+$$[-V|--version]$$
+$$<device> [<device>...]$$
+
+DESCRIPTION
+-----------
+'mkfs.btrfs'
+is used to create a btrfs filesystem (usually in a disk partition, or an array
+of disk partitions).
+
+<device>
+is the special file corresponding to the device (e.g /dev/sdXX ).
+If multiple devices are specified, btrfs is created
+spanning across the specified  devices.
+
+OPTIONS
+-------
+-A|--alloc-start <offset>::
+Specify the offset from the start of the device to start the btrfs filesystem. The default value is zero, or the start of the device.
+
+-b|--byte-count <size>::
+Specify the size of the resultant filesystem. If this option is not used,
+mkfs.btrfs uses all the available storage for the filesystem.
+
+-d|--data <type>::
+Specify how the data must be spanned across the devices specified. Valid
+values are 'raid0', 'raid1', 'raid5', 'raid6', 'raid10' or 'single'.
+
+-f|--force::
+Force overwrite when an existing filesystem is detected on the device.
+By default, mkfs.btrfs will not write to the device if it suspects that 
+there is a filesystem or partition table on the device already.
+
+-n|--nodesize <size>
++
+-l|--leafsize <size>::
+Specify the nodesize, the tree block size in which btrfs stores
+data. The default value is 16KB (16384) or the page size, whichever is
+bigger. Must be a multiple of the sectorsize, but not larger than
+65536. Leafsize always equals nodesize and the options are aliases.
+
+-L|--label <name>::
+Specify a label for the filesystem.
++
+NOTE: <name> should be less than 256 characters.
+
+
+-m|--metadata <profile>::
+Specify how metadata must be spanned across the devices specified. Valid
+values are 'raid0', 'raid1', 'raid5', 'raid6', 'raid10', 'single' or 'dup'.
++
+Single device
+will have dup set by default except in the case of SSDs which will default to
+single. This is because SSDs can remap blocks internally so duplicate blocks
+could end up in the same erase block which negates the benefits of doing
+metadata duplication.
+
+-M|--mixed::
+Mix data and metadata chunks together for more efficient space 
+utilization.  This feature incurs a performance penalty in
+larger filesystems.  It is recommended for use with filesystems
+of 1 GiB or smaller.
+
+-s|--sectorsize <size>::
+Specify the sectorsize, the minimum data block allocation unit.
++
+The default
+value is the page size. If the sectorsize differs from the page size, the
+created filesystem may not be mountable by current kernel. Therefore it is not
+recommended to use this option unless you are going to mount it on a system
+with the appropriate page size.
+
+-r|--rootdir <rootdir>::
+Specify a directory to copy into the newly created btrfs filesystem.
++
+NOTE: '-r' option is done completely in userland, and don't need root
+privilege to mount the filesystem.
+
+-K|--nodiscard::
+Do not perform whole device TRIM operation by default.
+
+-O|--features <feature1>[,<feature2>...]::
+A list of filesystem features turned on at mkfs time. Not all features are
+supported by old kernels.
++
+To see all features run::::
+mkfs.btrfs -O list-all
+
+-V|--version::
+Print the 'mkfs.btrfs' version and exit.
+
+-h::
+Print help.
+
+UNIT
+----
+As default the unit is the byte, however it is possible to append a suffix
+to the arguments like 'k' for KBytes, 'm' for MBytes...
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`btrfsck`(8)
-- 
1.9.1

