Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34940 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcAXWBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 17:01:25 -0500
Received: by mail-ig0-f179.google.com with SMTP id t15so23775469igr.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 14:01:25 -0800 (PST)
MIME-Version: 1.0
From: John Smith <lenovomi@gmail.com>
Date: Sun, 24 Jan 2016 23:00:55 +0100
Message-ID: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
Subject: uknown issues - different sha256 hash - files corruption
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear,

I have cubox-i4, running debian with 4.4 kernel. The icy box
IB-3664SU3 enclosure is attached into cubox using esata port,
enclosure uses JM393 and JM539 chipsets.

I use btrfs volume in raid0 created from the two drives, and lvm ext4
volume that contains two drives also. When I copy (using rsync) big
file (the one i copied is 130GB) from ext4 to btrfs the sha256 hash is
differs.

I did 2 tests, copy the source file from ext4 to btrfs, count sha256
hash, each time the destination file on btrfs has different hash
compared to the source file located on ext4 and even hashes from both
runs of target files on btrfs differs.

I run cmp -l <(hexdump source_file_ext4) <(hexdump target_file_btrfs).
The snapshot of the result is here http://paste.debian.net/367678/,
the is so many bytes with differences. The size of the source and
target file is exactly the same.


I also copied around 600GB of data set that contains small files,
music, videos, etc... and i did sha256 on all the files ext4 vs btrfs
- all was fine.

Any idea what can cause that issue or how can i debug it in more detail?


Thank you!

Best,
John
