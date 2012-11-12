Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:39096 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2KLQul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 11:50:41 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (jored mo24) (RZmta 31.2 AUTH)
	with ESMTPA id v0748doACGIZUm for <linux-btrfs@vger.kernel.org>;
	Mon, 12 Nov 2012 17:50:38 +0100 (CET)
Message-ID: <50A128DF.9010800@giantdisaster.de>
Date: Mon, 12 Nov 2012 17:50:39 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/26] Btrfs: add two more find_device() methods
References: <cover.1352217243.git.sbehrens@giantdisaster.de> <700c11c33955b15829597d5de5d890814be97ee9.1352217243.git.sbehrens@giantdisaster.de> <20121108142450.GA3034@gmail.com>
In-Reply-To: <20121108142450.GA3034@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Nov 2012 22:24:51 +0800, Liu Bo wrote:
> On Tue, Nov 06, 2012 at 05:38:25PM +0100, Stefan Behrens wrote:
>> The new function btrfs_find_device_missing_or_by_path() will be
>> used for the device replace procedure. This function itself calls
>> the second new function btrfs_find_device_by_path().
>> Unfortunately, it is not possible to currently make the rest of the
>> code use these functions as well, since all functions that look
>> similar at first view are all a little bit different in what they
>> are doing. But in the future, new code could benefit from these
>> two new functions, and currently, device replace uses them.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  fs/btrfs/volumes.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/volumes.h |  5 ++++
>>  2 files changed, 79 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index eeed97d..bcd3097 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1512,6 +1512,80 @@ error_undo:
>>  	goto error_brelse;
>>  }
>>  
>> +int btrfs_find_device_by_path(struct btrfs_root *root, char *device_path,
>> +			      struct btrfs_device **device)
>> +{
>> +	int ret = 0;
>> +	struct btrfs_super_block *disk_super;
>> +	u64 devid;
>> +	u8 *dev_uuid;
>> +	struct block_device *bdev;
>> +	struct buffer_head *bh = NULL;
>> +
>> +	*device = NULL;
>> +	mutex_lock(&uuid_mutex);
> 
> Since the caller have held volume_mutex, we can get rid of the
> mutex_lock here, can't we?
> 

Yes, you are right.


>> +	bdev = blkdev_get_by_path(device_path, FMODE_READ,
>> +				  root->fs_info->bdev_holder);
>> +	if (IS_ERR(bdev)) {
>> +		ret = PTR_ERR(bdev);
>> +		bdev = NULL;
>> +		goto out;
>> +	}
>> +
>> +	set_blocksize(bdev, 4096);
>> +	invalidate_bdev(bdev);
>> +	bh = btrfs_read_dev_super(bdev);
>> +	if (!bh) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
> 
> I made a scan for this 'get bdev & bh' in the code, I think
> maybe we can make a function,
> func_get(device_path, flags, mode, &bdev, &bh, flush)
> 
> where we need to take care of setting bdev = NULL, bh = NULL, and
> 'flush' is for filemap_bdev().  Besides, we also need to make
> some proper error handling.

Good idea for a cleanup! I have now added such a function. It improves
the readability. And it is only one place to make changes in the future
(e.g. when it is time to replace the "short term measure" commit
3c4bb26b213 which added the flushing code as a temporary workaround).

Thanks for your comments!

