Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22339 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846AbbALCca (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 21:32:30 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0C2Vrp4025963
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 10:31:53 +0800
Message-ID: <54B3323E.3090100@cn.fujitsu.com>
Date: Mon, 12 Jan 2015 10:32:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: What about storing more crc32 in the unused csum size for metadata?
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Old layout]
Btrfs csum size for tree block is 32 bytes, and currently, only the
first 4 bytes(sector 0) is used, storing the crc32 for the whole
leaf/node.

Takes 4K as example for leafsize.
Sectors:
|---0---|---1---|---2---|---3---|---4---|---5---|---6---|---7---|
Sector 0: Csum of the leaf/node (32 ~ 4K)
Sector 1~7: Not used

So, what about restoring more crc32 in other sectors in the following
backward-compatible way?

[New layout]
Take leafsize as 4K for example.

Sectors:
|---0---|---1---|---2---|---3---|---4---|---5---|---6---|---7---|
Sector 0: Csum of the leaf/node (32~4K)(not changed)
Sector 1: Csum of the first eighths of the leaf/node (32~512)
Sector 2: Csum of the second eighths of the leaf/node (512~1024)
....
Sector 7: Csum of the last eighths of the leaf/node (3584 ~ 4096)

And due to the fact
crc(sector 0 ~ sector 7) = crc(crc(sector 0), crc(sector 1), ...)

We won't waste too much CPU time, and since we keep the behavior of
sector 0, so it is completely backward compatible.

[Advantage]
The advantage usage of the new layout is more accuracy in scrub and
btrfsck.
For scrub, even all duplication is broken, there is still chance for
scrub to rebuild the block if corruptions occurs in different sector.

And for btrfsck --repair, if node is corrupted, we don't need to drop
all the nodes/leaves belong to the nodes, but only drops nodes/leaves
belong to the sector.
