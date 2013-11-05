Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54520 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3KEDHa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 22:07:30 -0500
Message-ID: <52786103.8000000@cn.fujitsu.com>
Date: Tue, 05 Nov 2013 11:07:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] Btrfs: rename btrfs_start_all_delalloc_inodes
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com> <1383578006-22691-8-git-send-email-miaox@cn.fujitsu.com> <20131104170918.GJ16855@localhost.localdomain>
In-Reply-To: <20131104170918.GJ16855@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 4 Nov 2013 12:09:18 -0500, Josef Bacik wrote:
> On Mon, Nov 04, 2013 at 11:13:26PM +0800, Miao Xie wrote:
>> rename the function -- btrfs_start_all_delalloc_inodes(), and make its
>> name be compatible to btrfs_wait_ordered_roots(), since they are always
>> used at the same place.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ctree.h       | 3 +--
>>  fs/btrfs/dev-replace.c | 2 +-
>>  fs/btrfs/extent-tree.c | 2 +-
>>  fs/btrfs/inode.c       | 3 +--
>>  fs/btrfs/relocation.c  | 2 +-
>>  fs/btrfs/transaction.c | 2 +-
>>  6 files changed, 6 insertions(+), 8 deletions(-)
>>
> 
> Theres another use in ioctl.c in my tree, I've just rebased that change in,
> please check my tree when I push it to make sure I did it right.  Thanks,

I have checked it, everything is OK.

Thanks
Miao

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

