Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43142 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQLWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 06:22:14 -0500
Message-ID: <50CF0053.4050906@oracle.com>
Date: Mon, 17 Dec 2012 19:21:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com
Subject: [RFC PATCH V5 0/2] Btrfs: get/set label of mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch set is trying to make Btrfs support get/set label for a mounted file sytem via ioctl(2).
There are a couple of changes according to Miao's comments which were shown as following.

Changes of V5->V4 in kernel:
- Revise the ioctl number of BTRFS_IOC_GET_FSLABEL/BTRFS_IOC_SET_FSLABEL to 49/50 separately.
- Replace btrfs_root_readonly() check up with mnt_want_write_file().
- Validate the input label length, return -EINVAL if the specified length is exceeding
  "BTRFS_LABEL_SIZE -1".

Changes of V5->V4 in user space:
- Revise the ioctl number accordingly.
- Don't proceed to get/set the label upon a mounted file system if the dev patch is specified, i.e.
btrfs filesystem label /dev/sdaX [new label]
  Instead, alert the user to execute this command against the mount point, i.e.
btrfs filesystem label /btrfs_mount_path [new label]
- Validate the input label length for changing the label upon an unmounted file system as well.
  We does not check it up currently, the command just keeping silent and truncate the label
  characters which are beyond "BTRFS_LABEL_SIZE - 1".


Tests:
======
/dev/sda6 on /btrfs type btrfs (rw)

jeff@koala:~/oss/btrfs-progs$ sudo ./btrfs filesystem label /btrfs 
btrfs_label

Failure if the length is exceeding 255.
jeff@koala:~/oss/btrfs-progs$ sudo ./btrfs filesystem label /btrfs `perl -e 'print "A"x256'`
ERROR: unable to set label Invalid argument

Otherwise, that's ok.
jeff@koala:~/oss/btrfs-progs$ sudo ./btrfs filesystem label /btrfs `perl -e 'print "A"x255'`

jeff@koala:~/oss/btrfs-progs$ sudo ./btrfs filesystem label /btrfs
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


The old versions can be found at:
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
