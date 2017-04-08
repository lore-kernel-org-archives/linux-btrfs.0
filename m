Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34606 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdDHA6M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:12 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
Subject: [PATCH 00/12] Delete CURRENT_TIME, CURRENT_TIME_SEC and current_fs_time
Date: Fri,  7 Apr 2017 17:56:58 -0700
Message-Id: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The series contains the last unmerged uses of CURRENT_TIME,
CURRENT_TIME_SEC, and current_fs_time().
The series also deletes these apis.

All the patches except [PATCH 9/12] and [PATCH 10/12] are resend patches.
These patches fix new instances of CURRENT_TIME.
cifs and ceph patches have been squashed so that we have one patch per
filesystem.

We want to get these merged onto 4.12 release so that I can post the series
that changes vfs timestamps to use 64 bits for 4.13 release.

I'm proposing these to be merged through Andrew's tree.

Filesystem maintainers, please let Andrew know if you will be picking up
the patch in your trees.

Let me know if anybody has other preferences for merging.

Deepa Dinamani (12):
  fs: f2fs: Use ktime_get_real_seconds for sit_info times
  trace: Make trace_hwlat timestamp y2038 safe
  fs: cifs: Replace CURRENT_TIME by other appropriate apis
  fs: ceph: CURRENT_TIME with ktime_get_real_ts()
  fs: ufs: Use ktime_get_real_ts64() for birthtime
  audit: Use timespec64 to represent audit timestamps
  fs: btrfs: Use ktime_get_real_ts for root ctime
  fs: ubifs: Replace CURRENT_TIME_SEC with current_time
  lustre: Replace CURRENT_TIME macro
  apparmorfs: Replace CURRENT_TIME with current_time()
  time: Delete CURRENT_TIME_SEC and CURRENT_TIME
  time: Delete current_fs_time() function

 drivers/block/rbd.c                             |  2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |  6 +++---
 drivers/staging/lustre/lustre/osc/osc_io.c      |  4 ++--
 fs/btrfs/root-tree.c                            |  3 ++-
 fs/ceph/mds_client.c                            |  4 +++-
 fs/cifs/cifsencrypt.c                           |  4 +++-
 fs/cifs/cifssmb.c                               | 10 ++++-----
 fs/cifs/inode.c                                 | 28 +++++++++++++------------
 fs/f2fs/segment.c                               |  2 +-
 fs/f2fs/segment.h                               |  5 +++--
 fs/ubifs/dir.c                                  | 12 +++++------
 fs/ubifs/file.c                                 | 12 +++++------
 fs/ubifs/ioctl.c                                |  2 +-
 fs/ubifs/misc.h                                 | 10 ---------
 fs/ubifs/sb.c                                   | 14 +++++++++----
 fs/ubifs/xattr.c                                |  6 +++---
 fs/ufs/ialloc.c                                 |  6 ++++--
 include/linux/audit.h                           |  4 ++--
 include/linux/fs.h                              |  1 -
 include/linux/time.h                            |  3 ---
 kernel/audit.c                                  | 10 ++++-----
 kernel/audit.h                                  |  2 +-
 kernel/auditsc.c                                |  6 +++---
 kernel/time/time.c                              | 14 -------------
 kernel/trace/trace_entries.h                    |  6 +++---
 kernel/trace/trace_hwlat.c                      | 14 ++++++-------
 kernel/trace/trace_output.c                     |  9 ++++----
 net/ceph/messenger.c                            |  6 ++++--
 net/ceph/osd_client.c                           |  4 ++--
 security/apparmor/apparmorfs.c                  |  2 +-
 30 files changed, 100 insertions(+), 111 deletions(-)

-- 
2.7.4

