From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 3/3] Btrfs: improve truncation of btrfs
Date: Fri, 06 Jan 2012 11:51:16 +0800
Message-ID: <4F066FB4.1030705@cn.fujitsu.com>
References: <4F05602E.3030907@cn.fujitsu.com> <20120105151502.GC1843@localhost.localdomain>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105151502.GC1843@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 5 Jan 2012 10:15:50 -0500, Josef Bacik wrote:
>> +	trans = btrfs_start_transaction(root, 2);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>>  
>>  	/*
>>  	 * setattr is responsible for setting the ordered_data_close flag,
>> @@ -6621,26 +6585,12 @@ static int btrfs_truncate(struct inode *inode)
>>  	 * using truncate to replace the contents of the file will
>>  	 * end up with a zero length file after a crash.
>>  	 */
>> -	if (inode->i_size == 0 && BTRFS_I(inode)->ordered_data_close)
>> +	if (newsize == 0 && BTRFS_I(inode)->ordered_data_close)
>>  		btrfs_add_ordered_operation(trans, root, inode);

Since we have write out all the dirty page, we can drop the following code which is
in front of the while loop, and move the first btrfs_start_transaction() into the loop,
the logic of btrfs_truncate() will become simpler.

>>  	while (1) {
>> -		ret = btrfs_block_rsv_refill(root, rsv, min_size);
>> -		if (ret) {
>> -			/*
>> -			 * This can only happen with the original transaction we
>> -			 * started above, every other time we shouldn't have a
>> -			 * transaction started yet.
>> -			 */
>> -			if (ret == -EAGAIN)
>> -				goto end_trans;
>> -			err = ret;
>> -			break;
>> -		}
>> -
> 
> Taking this part out is wrong, we need to have this slack space to account for
> any COW that truncate does.  Other than that this looks pretty good.  Thanks,
> 

I think we can take this part out, because we start a new transaction every time we
do a truncation, and reserve enough space at that time. See below:

Thanks
Miao
