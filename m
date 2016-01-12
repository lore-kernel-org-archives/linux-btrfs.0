Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759560AbcALDKS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 22:10:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id CA2594189100
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 11:09:24 +0800 (CST)
To: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About per-file dedup flag
Message-ID: <56946E63.1040502@cn.fujitsu.com>
Date: Tue, 12 Jan 2016 11:09:23 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

As some already know, we are implement btrfs in-band de-duplication.
And we already have a working and stable version internal.
But that's filesystem wide de-duplication.


Now we hope to add support to enable/disable dedup per-file.
Much like current NODATACOW/NOCOMPRESS for inode.


But we are not sure where to add such flag.
Here is our current ideas:

1) XATTR
Make a btrfs internal xattr, just like some btrfs prop.

2) inode flag, like FS_NOCOMP_FL
Although only btrfs is going to support in-band dedup, who knows
what will happen in future?

Any advice is welcomed.

Thanks,
Qu


