Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:45555 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3ENA6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:58:52 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:58:51 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 00/12] VFS hot tracking
Date: Tue, 14 May 2013 08:59:32 +0800
Message-Id: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The patchset is trying to introduce hot tracking function in
VFS layer, which will keep track of real disk I/O in memory.
By it, you will easily know more details about disk I/O, and
then detect where disk I/O hot spots are. Also, specific FS
can take use of it to do accurate defragment, and hot relocation
support, etc.

  After V1 was sent out, Chandra Seetharaman has reviewed and
made a lot of comments, thanks a lot to him. Not it's time to
send out its V2 for external review, any comments or ideas are
appreciated, thanks.

NOTE:

  The patchset can be obtained via my kernel dev git on github:
git://github.com/wuzhy/kernel.git hot_tracking
  If you're interested, you can also review them via
https://github.com/wuzhy/kernel/commits/hot_tracking

  For how to use and more other info and performance report,
please check hot_tracking.txt in Documentation and following
links:
  1.) http://lwn.net/Articles/525651/
  2.) https://lkml.org/lkml/2012/12/20/199

Changelog from v1:
 - Refactored to be under RCU [Chandra Seetharaman]
 - Merged some code changes [Chandra Seetharaman]
 - Fixed some issues [Chandra Seetharaman]

v1:
 - Solved 64 bits inode number issue. [David Sterba]
 - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
 - Cleanup Some issues [David Sterba]
 - Use a static hot debugfs root [Greg KH]

rfcv4:
 - Introduce hot func registering framework [Zhiyong]
 - Remove global variable for hot tracking [Zhiyong]
 - Add btrfs hot tracking support [Zhiyong]

rfcv3:
 1.) Rewritten debugfs support based seq_file operation. [Dave Chinner]
 2.) Refactored workqueue support. [Dave Chinner]
 3.) Turn some Micro into be tunable [Zhiyong, Liu Zheng]
       TIME_TO_KICK, and HEAT_UPDATE_DELAY
 4.) Cleanedup a lot of other issues [Dave Chinner]

rfcv2:
 1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
 2.) Added memory shrinker [Dave Chinner]
 3.) Converted to one workqueue to update map info periodically [Dave Chinner]
 4.) Cleanedup a lot of other issues [Dave Chinner]

rfcv1:
 1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
 2.) The first three patches can probably just be flattened into one.
                                        [Marco Stornelli , Dave Chinner]

Zhi Yong Wu (12):
  VFS hot tracking: introduce some data structures
  VFS hot tracking: add i/o freq tracking hooks
  VFS hot tracking: add one workqueue to update hot map
  VFS hot tracking: register one shrinker
  VFS hot tracking, rcu: introduce one rcu macro for list
  VFS hot tracking, seq_file: introduce one set of rcu seq_list
    interfaces
  VFS hot tracking: add debugfs support
  VFS hot tracking: add one ioctl interface
  VFS hot tracking, procfs: add two proc interfaces
  VFS hot tracking, btrfs: add hot tracking support
  VFS hot tracking: add documentation
  VFS hot tracking: add fs hot type support

 Documentation/filesystems/00-INDEX         |    2 +
 Documentation/filesystems/hot_tracking.txt |  256 ++++++
 fs/Makefile                                |    2 +-
 fs/btrfs/ctree.h                           |    1 +
 fs/btrfs/super.c                           |   22 +-
 fs/compat_ioctl.c                          |    5 +
 fs/dcache.c                                |    2 +
 fs/direct-io.c                             |    5 +
 fs/hot_tracking.c                          | 1320 ++++++++++++++++++++++++++++
 fs/hot_tracking.h                          |   67 ++
 fs/ioctl.c                                 |   70 ++
 fs/namei.c                                 |    2 +
 fs/seq_file.c                              |   37 +
 include/linux/fs.h                         |    5 +
 include/linux/hot_tracking.h               |  175 ++++
 include/linux/rculist.h                    |    5 +
 include/linux/seq_file.h                   |    7 +
 kernel/sysctl.c                            |   14 +
 mm/filemap.c                               |    6 +
 mm/page-writeback.c                        |   12 +
 mm/readahead.c                             |    6 +
 21 files changed, 2019 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/filesystems/hot_tracking.txt
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

-- 
1.7.11.7

