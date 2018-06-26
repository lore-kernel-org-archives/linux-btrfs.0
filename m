Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:35510 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbeFZGBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 02:01:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D3BBDAC04DE
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 15:01:11 +0900 (JST)
To: Nikolay Borisov <nborisov@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Enabling quota may not correctly rescan on 4.17
Message-ID: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
Date: Tue, 26 Jun 2018 15:00:24 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Nikolay,

I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
to fail correctly rescanning quota when quota is enabled.

Simple reproducer:

$ mkfs.btrfs -f $DEV
$ mount $DEV /mnt
$ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
$ btrfs quota enbale /mnt
$ umount /mnt
$ btrfs check $DEV
...
checking quota groups
Counts for qgroup id: 0/5 are different
our:            referenced 1019904 referenced compressed 1019904
disk:           referenced 16384 referenced compressed 16384
diff:           referenced 1003520 referenced compressed 1003520
our:            exclusive 1019904 exclusive compressed 1019904
disk:           exclusive 16384 exclusive compressed 16384
diff:           exclusive 1003520 exclusive compressed 1003520
found 1413120 bytes used, error(s) found
...

This can be also observed in btrfs/114. (Note that progs < 4.17
returns error code 0 even if quota is not consistency and therefore
test will incorrectly pass.)

My observation is that this commit changed to call initial quota rescan
when quota is enabeld instead of first comit transaction after enabling
quota, and therefore if there is something not commited at that time,
their usage will not be accounted.

Actually this can be simply fixed by calling "btrfs rescan" again or
calling "btrfs fi sync" before "btrfs quota enable".

I think the commit itself makes the code much easier to read, so it may
be better to fix the problem in progs (i.e. calling sync before quota enable).

Do you have any thoughts?

Thanks,
Tomohiro Misono


