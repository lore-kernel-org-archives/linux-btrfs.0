Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27995 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751829AbbGQCiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jul 2015 22:38:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6H2alAM019467
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 10:36:47 +0800
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Strange data backref offset?
Message-ID: <55A86AA8.6010404@cn.fujitsu.com>
Date: Fri, 17 Jul 2015 10:38:32 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

While I'm developing a new btrfs inband dedup mechanism, I found btrfsck 
and kernel doing strange behavior for clone.

[Reproducer]
# mount /dev/sdc -t btrfs /mnt/test
# dd if=/dev/zero of=/mnt/test/file1 bs=4K count=4
# sync
# ~/xfstests/src/cloner -s 4096 -l 4096 /mnt/test/file1 /mnt/test/file2
# sync

Then btrfs-debug-tree gives quite strange result on the data backref:
------
<EXTENT TREE>
         item 4 key (12845056 EXTENT_ITEM 16384) itemoff 16047 itemsize 111
                 extent refs 3 gen 6 flags DATA
                 extent data backref root 5 objectid 257 offset 0 count 1
                 extent data backref root 5 objectid 258 offset 
18446744073709547520 count 1

<FS TREE>
         item 8 key (257 EXTENT_DATA 0) itemoff 15743 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 0 nr 16384 ram 16384
                 extent compression 0
         item 9 key (257 EXTENT_DATA 16384) itemoff 15690 itemsize 53
                 extent data disk byte 12845056 nr 16384
                 extent data offset 4096 nr 4096 ram 16384
                 extent compression 0
------

The offset is file extent's key.offset - file exntent's offset,
Which is 0 - 4096, causing the overflow result.

Kernel and fsck all uses that behavior, so fsck can pass the strange thing.

But shouldn't the offset in data backref matches with the key.offset of 
the file extent?

And I'm quite sure the change of behavior can hugely break the fsck and 
kernel, but I'm wondering is this a known BUG or feature, and will it be 
handled?

Thanks,
Qu
