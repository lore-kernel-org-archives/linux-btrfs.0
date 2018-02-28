Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63371 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752096AbeB1KNg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 05:13:36 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9FA9448AE763
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 18:13:31 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: fsck-tests: Introduce test case with keyed data backref with the extent offset
Date: Wed, 28 Feb 2018 18:13:23 +0800
Message-ID: <20180228101323.25442-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the testcase for false alert of data extent backref lost with the
extent offset.

The image can be reproduced by the following commands:
------
dev=~/test.img
mnt=/mnt/btrfs

umount $mnt &> /dev/null
fallocate -l 128M $dev

mkfs.btrfs $dev
mount $dev $mnt

for i in `seq 1 10`; do
	xfs_io -f -c "pwrite 0 2K" $mnt/file$i
done

xfs_io -f -c "falloc 0 64K" $mnt/file11

for i in `seq 1 32`; do
	xfs_io -f -c "reflink $mnt/file11 0 $(($i * 64))K 64K" $mnt/file11
done

xfs_io -f -c "reflink $mnt/file11 32K $((33 * 64))K 32K" $mnt/file11

btrfs subvolume snapshot $mnt $mnt/snap1

umount $mnt
btrfs-image -c9 $dev extent_data_ref.img
------

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../fsck-tests/020-extent-ref-cases/extent_data_ref.img  | Bin 0 -> 6144 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/extent_data_ref.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/extent_data_ref.img b/tests/fsck-tests/020-extent-ref-cases/extent_data_ref.img
new file mode 100644
index 0000000000000000000000000000000000000000..3ab2396ba9c810d98f16a5efcf7fe23ee4b12ab5
GIT binary patch
literal 6144
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
a{m_i3m!>iDz<<x=x92wlzZv+iVBjBP`o6jV

literal 0
HcmV?d00001

-- 
2.16.2



