Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54247 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdFQHnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 03:43:37 -0400
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
Date: Sat, 17 Jun 2017 15:43:18 +0800
MIME-Version: 1.0
In-Reply-To: <20170616123352.GF25451@twin.jikos.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017Äê06ÔÂ16ÈÕ 20:33, David Sterba wrote:
> On Fri, Apr 07, 2017 at 10:43:15AM +0800, Qu Wenruo wrote:
>>   fs/btrfs/extent_io.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 122 insertions(+), 2 deletions(-)
> 
> I see a lot of warnings from btrfs/094
> 
> [13458.628334] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=581632 phys=13078528 len=4096 flags=0x800
> [13458.644183] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=864256 phys=13299712 len=4096 flags=0x800
> [13458.660097] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=1138688 phys=13504512 len=4096 flags=0x0
> [13458.675846] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=1462272 phys=13733888 len=4096 flags=0x800
> ...
> 
> about 1000 in total from a fstest run.

Strangely, I can't reproduce it either on my original branch (v4.12 with 
this patch), or torvalds/master (this patch is already merged with your 
renaming)

Also I'm enabling CONFIG_BTRFS_DEBUG, so when the btrfs_warn() is 
triggered, it should cause the test case to fail.

However I tried all btrfs/09*,  nothing happened.

Is some other out-of-tree patch causing the problem?
If so, which branch are you testing? I think I could help to fix it.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
