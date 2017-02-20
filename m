Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30682 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751833AbdBTDMQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Feb 2017 22:12:16 -0500
Subject: Re: [PATCH 0/7] cleanup __btrfs_map_block
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b96f654b-89bf-b6a2-90a3-93522dfe6440@cn.fujitsu.com>
Date: Mon, 20 Feb 2017 11:12:10 +0800
MIME-Version: 1.0
In-Reply-To: <1487381301-865-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/18/2017 09:28 AM, Liu Bo wrote:
> This is attempting to make __btrfs_map_block less scary :)
>

Great!!
That's also what I want to do in btrfs-progs.

And it would be better if we can take a step further to have a better 
API for both pure mirrored/striped profile and parity profile.

I tried to do it in btrfs-progs with the following patchset, while it 
needs more work to do in kernel.
https://patchwork.kernel.org/patch/9488519/

> The major changes are
>
> 1) split operations for discard out of __btrfs_map_block and we don't copy
> discard operations for the target device of dev replace since they're not
> as important as writes.
>
> 2) put dev replace stuff into helpers since they're basically
> self-independant.

Quite good starting point.

Thanks,
Qu
>
>
> Liu Bo (7):
>   Btrfs: create a helper for getting chunk map
>   Btrfs: separate DISCARD from __btrfs_map_block
>   Btrfs: introduce a function to get extra mirror from replace
>   Btrfs: handle operations for device replace separately
>   Btrfs: do not add extra mirror when dev_replace target dev is not
>     available
>   Btrfs: helper for ops that requires full stripe
>   Btrfs: convert BUG_ON to WARN_ON
>
>  fs/btrfs/extent_io.c |   3 +-
>  fs/btrfs/volumes.c   | 824 +++++++++++++++++++++++++++------------------------
>  fs/btrfs/volumes.h   |   2 +-
>  3 files changed, 445 insertions(+), 384 deletions(-)
>


