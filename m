From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v1 6/6] scrub: add fixup code for errors on nodatasum
 files
Date: Sat, 18 Jun 2011 13:26:44 +0200
Message-ID: <4DFC8B74.40206@jan-o-sch.net>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net> <15e5902b4d0e0dbe6fdaa0994ea97ba874daf019.1307991539.git.list.btrfs@jan-o-sch.net> <20110616212717.GD12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110616212717.GD12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Lots of quotation removed. All removed comments accepted.

On 16.06.2011 23:27, David Sterba wrote:
> On Mon, Jun 13, 2011 at 09:10:39PM +0200, Jan Schmidt wrote:
>> +struct scrub_fixup_nodatasum {
>> +	struct scrub_dev	*sdev;
>> +	u64			logical;
>> +	struct btrfs_root	*root;
>> +	struct btrfs_work	work;
>> +	u64			mirror_num;
> 
> int should be enough and is used elsewhere but scrub_page, uses u64 as well;
> that's a bit too much IMO

You are right. scrub.c should be changed to use int mirror_num all over.
I'll integrate a cleanup patch in my next patch series as patch 6/7 and
this one can become a clean 7/7 then.

>> +};
>> +
>>  struct scrub_warning {
>>  	struct btrfs_path	*path;
>>  	u64			extent_item_size;
>> @@ -195,12 +205,13 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
>>  
>>  		if (i != SCRUB_BIOS_PER_DEV-1)
>>  			sdev->bios[i]->next_free = i + 1;
>> -		 else
>> +		else
>>  			sdev->bios[i]->next_free = -1;
>>  	}
>>  	sdev->first_free = 0;
>>  	sdev->curr = -1;
>>  	atomic_set(&sdev->in_flight, 0);
>> +	atomic_set(&sdev->fixup, 0);
>>  	atomic_set(&sdev->cancel_req, 0);
>>  	sdev->csum_size = btrfs_super_csum_size(&fs_info->super_copy);
>>  	INIT_LIST_HEAD(&sdev->csum_list);
>> @@ -330,6 +341,141 @@ out:
>>  	kfree(swarn.msg_buf);
>>  }
>>  
>> +static int scrub_fixup_readpage(u64 inum, loff_t offset, void *ctx)
>> +{
>> +	struct page *page;
>> +	unsigned long index;
>> +	struct scrub_fixup_nodatasum *fixup = ctx;
>> +	int ret;
>> +	int corrected;
>> +	struct btrfs_key key;
>> +	struct inode *inode;
>> +	int end = offset + PAGE_SIZE - 1;
> 
> loff_t to int?
> 
>> +
>> +	key.type = BTRFS_INODE_ITEM_KEY;
>> +	key.objectid = inum;
>> +	key.offset = 0;
>> +	inode = btrfs_iget(fixup->root->fs_info->sb, &key,
>> +				fixup->root->fs_info->fs_root, NULL);
>> +	if (IS_ERR(inode))
>> +		return -1;
> 
> needs better error code
> 
>> +
>> +	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, offset, end,
>> +				EXTENT_DAMAGED, 0, NULL, NULL, GFP_NOFS);
>> +	if (ret)
>> +		return ret < 0 ? ret : -1;
> 
> needs better error code

Hum. That one is tricky. set_extent_bit can in theory return anything,
as there is at least one hook that can be called. If it returns
non-zero, that will become the return value of set_extent_bit. As far as
I see, that hook will always return 0 at the moment. In case that hook
decides to return something >0, I still want iterate_extent_inodes() to
terminate iteration. I think adding a WARN_ON for that and returning
-EFAULT is an option.

>>  		/*
>> -		 * nodatasum, don't try to fix anything
>> -		 * FIXME: we can do better, open the inode and trigger a
>> -		 * writeback
>> +		 * increment scrubs_running to prevent cancel requests from
>> +		 * completing as long as a fixup worker is running. we must also
>> +		 * increment scrubs_paused to prevent deadlocking on pause
>> +		 * requests used for transactions commits (as the worker uses a
>> +		 * transaction context). it is safe to regard the fixup worker
>> +		 * as paused for all matters practical. effectively, we only
>> +		 * avoid cancellation requests from completing.
> 
> from a rather brief look, this works as advertised
> 
>>  		 */

Bonus points for thinking about that :-)

Thanks!
Jan
