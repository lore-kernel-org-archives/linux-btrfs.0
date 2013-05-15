Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:50458 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3EOPjd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 11:39:33 -0400
Message-ID: <5193AC37.6080609@giantdisaster.de>
Date: Wed, 15 May 2013 17:39:35 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/8] Btrfs: maintain subvolume items in the UUID tree
References: <cover.1368523154.git.sbehrens@giantdisaster.de> <c68d2db7aa4ed6455645cf788e305b1a9ebb88bc.1368523154.git.sbehrens@giantdisaster.de> <20130514104410.GB15127@liubo.jp.oracle.com>
In-Reply-To: <20130514104410.GB15127@liubo.jp.oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 May 2013 18:44:11 +0800, Liu Bo wrote:
> On Tue, May 14, 2013 at 11:36:56AM +0200, Stefan Behrens wrote:
>> @@ -396,7 +403,7 @@ static noinline int create_subvol(struct inode *dir,
>>  	 * of create_snapshot().
>>  	 */
>>  	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv,
>> -					       7, &qgroup_reserved);
>> +					       8, &qgroup_reserved);
>>  	if (ret)
>>  		return ret;
> 
> This uuid_root will not use trans->block_rsv but empty_rsv since it does not set
> ref_cow, so you don't need to add one more to block_rsv, and same for
> the below cases.

Hi Liu Bo,

Thanks for your review comments!

You are right, this won't work because the empty_block_rsv is used for
the UUID tree as it is now.

I need to avoid ENOSPC in the middle of the transaction. Can you please
acknowledge or comment the following addition to get_block_rsv()? And
the "plus 1" that I have added to the transaction reservations for
subvolume/snapshot creation/destruction will work correctly afterwards.

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4259,6 +4259,9 @@ static struct btrfs_block_rsv *get_block_rsv(
        if (root == root->fs_info->csum_root && trans->adding_csums)
                block_rsv = trans->block_rsv;

+       if (root == root->fs_info->uuid_root)
+               block_rsv = trans->block_rsv;
+
        if (!block_rsv)
                block_rsv = root->block_rsv;



>> @@ -567,9 +578,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>  	 * 1 - root item
>>  	 * 2 - root ref/backref
>>  	 * 1 - root of snapshot
>> +	 * 1 - UUID item
>>  	 */
>>  	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
>> -					&pending_snapshot->block_rsv, 7,
>> +					&pending_snapshot->block_rsv, 8,
>>  					&pending_snapshot->qgroup_reserved);
>>  	if (ret)
>>  		goto out;

