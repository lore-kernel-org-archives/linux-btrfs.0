Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44998 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab3GDJyC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 05:54:02 -0400
Received: by mail-lb0-f169.google.com with SMTP id d10so1052233lbj.14
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 02:54:00 -0700 (PDT)
Date: Thu, 4 Jul 2013 13:51:38 +0400
From: Andrew Vagin <avagin@gmail.com>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Cc: kzak@redhat.com, xemul@openvz.org, Mark Fasheh <mfasheh@suse.com>
Subject: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130704095138.GB12359@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I want to resurrect an old problem. Currently stat(2) returns another
device than other places where the device is printed (/proc/pid/maps,
/proc/pid/fdinfo/, unix-diag). stat(2) reports devices, which is absent
in /proc/pid/mountinfo.

# cat /proc/self/mountinfo | grep mnt
40 32 0:32 / /mnt rw,relatime shared:27 - btrfs /dev/loop0 rw,noacl,space_cache

# cat /proc/2943/maps
00400000-00406000 r-xp 00000000 00:20 260 /mnt/xxx/sleep

# stat -L -c "%D" /proc/2943/map_files/400000-406000
23

We are not first who suffer from this problem:
https://bugzilla.redhat.com/show_bug.cgi?id=711881
http://marc.info/?l=linux-btrfs&m=130074451403261
https://bugzilla.openvz.org/show_bug.cgi?id=2653

This bug looks like KABI violation.

And about 2 years ago Mark Fasheh tried to fix this problem:
http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps

Eric Biederman sugested to not create a new method and use vfs_getattr,
but here is a few problems:
* fanotify doesn't have dentry, but its fdinfo contains device.
* vfs_getattr can fail and which device should be shown in this case?
* vfs_getattr gets much more parameters, so here is a question about
  performance degradation.

So I have a question: Can two inodes from different subvolumes have
equal inode numbers?

If someone have any suggestions how to fix this problem or any
explanation why this is not a problem at all, please write here.

Thanks.
