Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54878 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGCOu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 21:14:50 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 317593EE0B5
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 11:14:49 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 16C8745DE55
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 11:14:49 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0060745DE54
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 11:14:49 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id DF9F21DB8044
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 11:14:48 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 934021DB803A
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 11:14:48 +0900 (JST)
Message-ID: <5099C40C.6030003@jp.fujitsu.com>
Date: Wed, 07 Nov 2012 11:14:36 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/11/07 1:38), Stefan Behrens wrote:
> This patch series adds support for replacing disks at runtime.
> 
> It replaces the following steps in case a disk was lost:
>      mount ... -o degraded
>      btrfs device add new_disk
>      btrfs device delete missing
> 
> Or in case a disk just needs to be replaced because the error rate
> is increasing:
>      btrfs device add new_disk
>      btrfs device delete old_disk
> 
> Instead just run:
>      btrfs replace mountpoint old_disk new_disk
> 
> The device replace operation takes place at runtime on a live
> filesystem, you don't need to unmount it or stop active tasks.
> It is safe to crash or lose power during the operation, the
> process resumes with the next mount.
> 
> The copy usually takes place at 90% of the available platter
> speed if no additional disk I/O is ongoing during the copy
> operation, thus the degraded state without redundancy can be
> left quickly.
> 
> The copy process is started manually. It is a different project
> to react on an increased device I/O error rate with an automatic
> start of this procedure.
> 
> The patch series is based on btrfs-next and also available here:
> git://btrfs.giantdisaster.de/git/btrfs device-replace
> 
> The user mode part is the top commit of
> git://btrfs.giantdisaster.de/git/btrfs-progs master
> 
> 
> replace start [-Bfr] <path> <srcdev>|<devid> <targetdev>

I think that
 "btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <path>"
of the same synopsis as other subcommands is better.

- Tsutomu

>         Replace device of a btrfs filesystem.   On  a  live  filesystem,
>         duplicate  the  data  to  the  target  device which is currently
>         stored on the source device. If the source device is not  avail-
>         able anymore, or if the -r option is set, the data is built only
>         using the RAID redundancy mechanisms. After  completion  of  the
>         operation, the source device is removed from the filesystem.  If
>         the srcdev is a numerical value, it is assumed to be the  device
>         id  of the filesystem which is mounted at mount_point, otherwise
>         is is the path to the source device. If  the  source  device  is
>         disconnected, from the system, you have to use the devid parame-
>         ter format.  The targetdev needs to be same size or larger  than
>         the srcdev.
> 
>         Options
> 
>         -r     only  read  from  srcdev  if  no other zero-defect mirror
>                exists (enable this  if  your  drive  has  lots  of  read
>                errors, the access would be very slow)
> 
>         -f     force  using  and  overwriting targetdev even if it looks
>                like  containing  a  valid  btrfs  filesystem.  A   valid
>                filesystem  is  assumed  if  a  btrfs superblock is found
>                which contains a correct checksum. Devices which are cur-
>                rently  mounted  are never allowed to be used as the tar-
>                getdev
> 
>         -B     do not background
> 
> 
> replace status [-1] <path>
>         Print status  and  progress  information  of  a  running  device
>         replace operation.
> 
>         Options
> 
>         -1     print once instead of print continously until the replace
>                operation finishes (or is canceled)
> 
> 
> replace cancel <path>
>         Cancel a running device replace operation.
> 
> 
> Stefan Behrens (26):
>    Btrfs: rename the scrub context structure
>    Btrfs: remove the block device pointer from the scrub context struct
>    Btrfs: make the scrub page array dynamically allocated
>    Btrfs: in scrub repair code, optimize the reading of mirrors
>    Btrfs: in scrub repair code, simplify alloc error handling
>    Btrfs: cleanup scrub bio and worker wait code
>    Btrfs: add two more find_device() methods
>    Btrfs: Pass fs_info to btrfs_num_copies() instead of mapping_tree
>    Btrfs: pass fs_info to btrfs_map_block() instead of mapping_tree
>    Btrfs: add btrfs_scratch_superblock() function
>    Btrfs: pass fs_info instead of root
>    Btrfs: avoid risk of a deadlock in btrfs_handle_error
>    Btrfs: enhance btrfs structures for device replace support
>    Btrfs: introduce a btrfs_dev_replace_item type
>    Btrfs: add a new source file with device replace code
>    Btrfs: disallow mutually exclusiv admin operations from user mode
>    Btrfs: disallow some operations on the device replace target device
>    Btrfs: handle errors from btrfs_map_bio() everywhere
>    Btrfs: add code to scrub to copy read data to another disk
>    Btrfs: change core code of btrfs to support the device replace
>      operations
>    Btrfs: introduce GET_READ_MIRRORS functionality for btrfs_map_block()
>    Btrfs: changes to live filesystem are also written to replacement
>      disk
>    Btrfs: optionally avoid reads from device replace source drive
>    Btrfs: increase BTRFS_MAX_MIRRORS by one for dev replace
>    Btrfs: allow repair code to include target disk when searching
>      mirrors
>    Btrfs: add support for device replace ioctls
> 
>   fs/btrfs/Makefile          |    2 +-
>   fs/btrfs/check-integrity.c |   29 +-
>   fs/btrfs/compression.c     |    6 +-
>   fs/btrfs/ctree.h           |  127 ++-
>   fs/btrfs/dev-replace.c     |  843 ++++++++++++++++++++
>   fs/btrfs/dev-replace.h     |   44 ++
>   fs/btrfs/disk-io.c         |   79 +-
>   fs/btrfs/extent-tree.c     |    5 +-
>   fs/btrfs/extent_io.c       |   28 +-
>   fs/btrfs/extent_io.h       |    4 +-
>   fs/btrfs/inode.c           |   39 +-
>   fs/btrfs/ioctl.c           |  117 ++-
>   fs/btrfs/ioctl.h           |   45 ++
>   fs/btrfs/print-tree.c      |    3 +
>   fs/btrfs/reada.c           |   31 +-
>   fs/btrfs/scrub.c           | 1822 ++++++++++++++++++++++++++++++++------------
>   fs/btrfs/super.c           |   30 +-
>   fs/btrfs/transaction.c     |    7 +-
>   fs/btrfs/volumes.c         |  624 +++++++++++++--
>   fs/btrfs/volumes.h         |   26 +-
>   20 files changed, 3244 insertions(+), 667 deletions(-)
>   create mode 100644 fs/btrfs/dev-replace.c
>   create mode 100644 fs/btrfs/dev-replace.h
> 


