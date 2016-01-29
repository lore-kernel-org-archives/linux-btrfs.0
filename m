Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26390 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545AbcA2DSU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 22:18:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 9476241887CD
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 11:17:14 +0800 (CST)
Subject: Re: [PATCH V7 0/3][PULL REQUEST] Unify 'norecovery' bahavior with
 other filesystems
To: <linux-btrfs@vger.kernel.org>
References: <1453170184-22869-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56AAD9DC.90805@cn.fujitsu.com>
Date: Fri, 29 Jan 2016 11:17:48 +0800
MIME-Version: 1.0
In-Reply-To: <1453170184-22869-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping.

Any comment?
Or will it be merged into current 4.5?

Thanks,
Qu

Qu Wenruo wrote on 2016/01/19 10:23 +0800:
> 'Norecovery' mount option is almost a standard for all other
> filesystems, including f2fs, ext4, gfs2, nilfs2, and xfs.
> And since current 'recovery' mount option for btrfs is too generic, it's
> better to change btrfs 'recovery' to 'usebackuproot' and then we can
> safely add 'norecovery' and 'nologreplay' mount option for btrfs.
>
> The patch itself is not huge and already tested by others since v2.
> Only mount option name and patch slipting is changing during all
> these version changes.
>
> Qu Wenruo (3):
>    btrfs: Introduce new mount option usebackuproot to replace recovery
>    btrfs: Introduce new mount option to disable tree log replay
>    btrfs: Introduce new mount option alias for nologreplay
>
>   Documentation/filesystems/btrfs.txt | 17 +++++++++++---
>   fs/btrfs/ctree.h                    |  6 +++--
>   fs/btrfs/disk-io.c                  | 15 ++++++++----
>   fs/btrfs/super.c                    | 47 ++++++++++++++++++++++++++++++-------
>   4 files changed, 67 insertions(+), 18 deletions(-)
>


