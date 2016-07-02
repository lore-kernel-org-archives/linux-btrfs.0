Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbcGBHSK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jul 2016 03:18:10 -0400
From: Pavel Raiskup <praiskup@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: bug-tar <bug-tar@gnu.org>
Subject: stat() on btrfs reports the st_blocks with delay (data loss in archivers)
Date: Sat, 02 Jul 2016 09:18:07 +0200
Message-ID: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are optimizations in archivers (tar, rsync, ...) that rely on up2date
st_blocks info.  For example, in GNU tar there is optimization check [1]
whether the 'st_size' reports more data than the 'st_blocks' can hold --> then
tar considers that file is sparse (and does additional steps).

It looks like btrfs doesn't show correct value in 'st_blocks' until the data
are synced.  ATM, there happens that:

    a) some "tool" creates sparse file
    b) that tool does not sync explicitly and exits ..
    c) tar is called immediately after that to archive the sparse file
    d) tar considers [2] the file is completely sparse (because st_blocks is
       zero) and archives no data.  Here comes data loss.

Because we fixed 'btrfs' to report non-zero 'st_blocks' when the file data is
small and is in-lined (no real data blocks) -- I consider this is too bug in
btrfs worth fixing.

[1] http://git.savannah.gnu.org/cgit/paxutils.git/tree/lib/system.h?id=ec72abd9dd63bbff4534ec77e97b1a6cadfc3cf8#n392
[2] http://git.savannah.gnu.org/cgit/tar.git/tree/src/sparse.c?id=ac065c57fdc1788a2769fb119ed0c8146e1b9dd6#n273

Tested on kernel:
kernel-4.5.7-300.fc24.x86_64

Originally reported here, reproducer available there:
https://bugzilla.redhat.com/show_bug.cgi?id=1352061

Pavel

