Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29866 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751488AbcHOHvQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 03:51:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id DAB49429594D
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 15:50:57 +0800 (CST)
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About minimal device number for RAID5/6
Message-ID: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
Date: Mon, 15 Aug 2016 15:50:56 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Recently I found that manpage of mkfs is saying minimal device number 
for RAID5 and RAID6 is 2 and 3.

Personally speaking, although I understand that RAID5/6 only requires 
1/2 devices for parity stripe, it is still quite strange behavior.

Under most case, user use raid5/6 for striping AND parity. For 2 devices 
RAID5, it's just a more expensive RAID1.

IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.

Any comment is welcomed.

Thanks,
Qu


