Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab2IGDKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 23:10:42 -0400
Message-ID: <504965A3.3050402@cn.fujitsu.com>
Date: Fri, 07 Sep 2012 11:10:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 07/12] Btrfs: fix corrupted metadata in the snapshot
References: <504874D8.60001@cn.fujitsu.com> <20120906130914.GA18438@localhost.localdomain>
In-Reply-To: <20120906130914.GA18438@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 Sep 2012 09:09:14 -0400, Josef Bacik wrote:
> On Thu, Sep 06, 2012 at 04:03:04AM -0600, Miao Xie wrote:
>> When we delete a inode, we will remove all the delayed items including delayed
>> inode update, and then truncate all the relative metadata. If there is lots of
>> metadata, we will end the current transaction, and start a new transaction to
>> truncate the left metadata. In this way, we will leave a inode item that its
>> link counter is > 0, and also may leave some directory index items in fs/file tree
>> after the current transaction ends. In other words, the metadata in this fs/file tree
>> is inconsistent. If we create a snapshot for this tree now, we will find a inode with
>> corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
>> because its link counter is not 0.
>>
>> We fix this problem by updating the inode item before the current transaction ends.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> Changelog v1 -> v4:
>> - Update the comment of the truncation in the btrfs_evict_inode()
>> - Fix enospc problem of the inode update
> 
> This isn't the right way to do the enospc fix, we need to do
> 
> btrfs_start_transaction(root, 1); and then change the trans->block_rsv to our
> reserve for the truncate and then set it back to the trans rsv for the update
> that way we don't run out of space because we used our reservation for the
> truncate.  Just update this patch and send it along and I'll include it.
> Thanks,

btrfs_start_transaction() will cause the deadlock problem just as I said in comment,
the reason is:

	start transaction
		|
		v
	reserve meta-data space
		|
		v
	flush delay allocation -> iput inode -> evict inode
		^ 					|
		|					v
	wait for delay allocation flush <- reserve meta-data space

So we may introduce a special starting-transaction function which can reserve the space
without flush. I'll make a patch with this way.

Thanks
Miao
