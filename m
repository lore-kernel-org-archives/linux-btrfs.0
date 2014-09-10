Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50540 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751432AbaIJCmU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 22:42:20 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8A2fSCS025368
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 10:41:28 +0800
Message-ID: <540FBA16.1010907@cn.fujitsu.com>
Date: Wed, 10 Sep 2014 10:40:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Impossible case in btrfs self test?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all

Btrfs self test seems to contain impossible case in it:
[0 - 5][5 -  6][6 - 10][10 - 4096]
[hole ][inline][ hole ][ regular ]

I really don't understand how such case can happen in real world.

If we create an inline extent, and punch hole inside inline extent, it 
will only zero out the
inline extents, but not to create a new small hole extent.

It is also strange that if we do write beyong the inline range and reach 4K,
then it will be converted to a normal extent, no more inline extent any 
more.

In fact, these test cases forces extent maps to handle unaligned extent.
However in fact, this will not happen except inlined file extent,
and regular/preallocated/hole file extents are all page size aligned.

Commit like the following could align to pagesize without problem if 
there is no
such self test.
Actually the commit will cause some bug if not aligned to page size. My 
fault again. :(
51f395ad4058883e4273b02fdebe98072dbdc0d2 btrfs: Use right extent length 
when inserting overlap extent map.

Should we change the inode-test self test?

Thanks,
Qu
