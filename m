Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbbJLNYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOFqt026183
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:15 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 00/11] btrfs-progs: Use btrfs_open_dir to avoid show error of ioctl or tree search
Date: Mon, 12 Oct 2015 21:22:53 +0800
Message-ID: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use btrfs_open_dir() instead of open_file_or_dir(), to show error before
real action(in ioctl or tree search), to make the error message exact
and unified.

It can also make code simple:
  85 insertions(+), 185 deletions(-)

Also include some small bug fix.

Before patch:
  # grep open_file_or_dir *.c
  btrfs-fragments.c:      fd = open_file_or_dir(path, &dirstream);
  cmds-balance.c: fd = open_file_or_dir(path, &dirstream);
  cmds-balance.c: fd = open_file_or_dir(path, &dirstream);
  cmds-balance.c: fd = open_file_or_dir(path, &dirstream);
  cmds-balance.c: fd = open_file_or_dir(path, &dirstream);
  cmds-balance.c: fd = open_file_or_dir(path, &dirstream);
  cmds-filesystem.c:      fd = open_file_or_dir(path, &dirstream);
  cmds-filesystem.c:      fd = open_file_or_dir(path, &dirstream);
  cmds-filesystem.c:              fd = open_file_or_dir(argv[i], &dirstream);
  cmds-filesystem.c:      fd = open_file_or_dir(path, &dirstream);
  cmds-fi-usage.c:                fd = open_file_or_dir(argv[i], &dirstream);
  cmds-inspect.c: fd = open_file_or_dir(argv[optind+1], &dirstream);
  cmds-inspect.c: fd = open_file_or_dir(argv[optind+1], &dirstream);
  cmds-inspect.c:                         path_fd = open_file_or_dir(full_path, &dirs);
  cmds-inspect.c: fd = open_file_or_dir(argv[2], &dirstream);
  cmds-inspect.c: fd = open_file_or_dir(argv[1], &dirstream);
  cmds-inspect.c: fd = open_file_or_dir(argv[optind], &dirstream);
  cmds-qgroup.c:  fd = open_file_or_dir(path, &dirstream);
  cmds-qgroup.c:  fd = open_file_or_dir(path, &dirstream);
  cmds-qgroup.c:  fd = open_file_or_dir(path, &dirstream);
  cmds-qgroup.c:  fd = open_file_or_dir(path, &dirstream);
  cmds-quota.c:   fd = open_file_or_dir(path, &dirstream);
  cmds-quota.c:   fd = open_file_or_dir(path, &dirstream);
  cmds-replace.c: fd = open_file_or_dir(path, &dirstream);
  cmds-replace.c: fd = open_file_or_dir(path, &dirstream);
  cmds-subvolume.c:       fddst = open_file_or_dir(dstdir, &dirstream);
  cmds-subvolume.c:       fd = open_file_or_dir(dname, &dirstream);
  cmds-subvolume.c:       fd = open_file_or_dir(subvol, &dirstream);
  cmds-subvolume.c:       fddst = open_file_or_dir(dstdir, &dirstream1);
  cmds-subvolume.c:       fd = open_file_or_dir(subvol, &dirstream2);
  cmds-subvolume.c:       fd = open_file_or_dir(subvol, &dirstream);
  cmds-subvolume.c:       fd = open_file_or_dir(path, &dirstream);
  cmds-subvolume.c:       fd = open_file_or_dir(subvol, &dirstream);
  cmds-subvolume.c:       fd = open_file_or_dir(fullpath, &dirstream1);
  cmds-subvolume.c:       mntfd = open_file_or_dir(mnt, &dirstream2);
  cmds-subvolume.c:       fd = open_file_or_dir(argv[optind], &dirstream);
  props.c:        fd = open_file_or_dir3(object, &dirstream, open_flags);
  utils.c:                fdmnt = open_file_or_dir(mp, dirstream);
  utils.c:                fdmnt = open_file_or_dir(path, dirstream);
  utils.c: * Do the following checks before calling open_file_or_dir():
  utils.c:        ret = open_file_or_dir(path, dirstream);
  utils.c:int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
  utils.c:int open_file_or_dir(const char *fname, DIR **dirstream)
  utils.c:        return open_file_or_dir3(fname, dirstream, O_RDWR);
  utils.c:        fd = open_file_or_dir(path, &dirstream);
  #

After patch:
  # grep open_file_or_dir *.c
  cmds-filesystem.c:              fd = open_file_or_dir(argv[i], &dirstream); *1
  props.c:        fd = open_file_or_dir3(object, &dirstream, open_flags);
  utils.c:                ret = open_file_or_dir(mp, dirstream);
  utils.c: * Do the following checks before calling open_file_or_dir():
  utils.c:        ret = open_file_or_dir(path, dirstream);
  utils.c:int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
  utils.c:int open_file_or_dir(const char *fname, DIR **dirstream)
  utils.c:        return open_file_or_dir3(fname, dirstream, O_RDWR);
  utils.c:        fd = open_file_or_dir(path, &dirstream);
  #
  *1: It is used to open dir or file, can not use btrfs_open_dir()
      instead.

Zhao Lei (11):
  btrfs-progs: subvolume: use btrfs_open_dir for btrfs subvolume command
  btrfs-progs: filesystem: use btrfs_open_dir for btrfs filesystem
    command
  btrfs-progs: balance: use btrfs_open_dir for btrfs balance command
  btrfs-progs: inspect: Bypass unnecessary clean function in open_error
  btrfs-progs: inspect: set return value of error case
  btrfs-progs: inspect: use btrfs_open_dir for btrfs inspect command
  btrfs-progs: qgroup: use btrfs_open_dir for btrfs qgroup command
  btrfs-progs: quota: use btrfs_open_dir for btrfs quota command
  btrfs-progs: use btrfs_open_dir in open_path_or_dev_mnt
  btrfs-progs: replace: use btrfs_open_dir for btrfs replace command
  btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command

 btrfs-fragments.c |  6 ++----
 cmds-balance.c    | 30 ++++++++++-------------------
 cmds-device.c     | 13 ++-----------
 cmds-fi-usage.c   |  4 +---
 cmds-filesystem.c | 19 +++++++------------
 cmds-inspect.c    | 26 +++++++++-----------------
 cmds-qgroup.c     | 24 ++++++++----------------
 cmds-quota.c      | 12 ++++--------
 cmds-replace.c    | 29 ++++++----------------------
 cmds-scrub.c      | 28 +++++-----------------------
 cmds-subvolume.c  | 56 +++++++++++++++++++------------------------------------
 utils.c           | 21 +++++++++++----------
 utils.h           |  2 +-
 13 files changed, 85 insertions(+), 185 deletions(-)

-- 
1.8.5.1

