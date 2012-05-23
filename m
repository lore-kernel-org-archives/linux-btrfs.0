Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:20191 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2EWOsx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 10:48:53 -0400
Message-ID: <4FBCF8D6.10500@giantdisaster.de>
Date: Wed, 23 May 2012 16:48:54 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/3] Btrfs: read device stats on mount, write modified
 ones during commit
References: <cover.1337682115.git.sbehrens@giantdisaster.de> <1b233fadc62813d5f9498d87e59a95559add4bf7.1337682115.git.sbehrens@giantdisaster.de> <4FBC3D68.4020400@cn.fujitsu.com>
In-Reply-To: <4FBC3D68.4020400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 May 2012 09:29:12 +0800, Liu Bo wrote:
> On 05/22/2012 06:53 PM, Stefan Behrens wrote:
> 
>> The device statistics are written into the device tree with each
>> transaction commit. Only modified statistics are written.
>> When a filesystem is mounted, the device statistics for each involved
>> device are read from the device tree and used to initialize the
>> counters.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  fs/btrfs/ctree.h       |   51 ++++++++++++
>>  fs/btrfs/disk-io.c     |    7 ++
>>  fs/btrfs/print-tree.c  |    3 +
>>  fs/btrfs/transaction.c |    4 +
>>  fs/btrfs/volumes.c     |  205 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/volumes.h     |    9 +++
>>  6 files changed, 279 insertions(+)
>>
> [...]
>> +static int update_device_stat_item(struct btrfs_trans_handle *trans,
>> +				   struct btrfs_root *dev_root,
>> +				   struct btrfs_device *device)
>> +{
>> +	struct btrfs_path *path;
>> +	struct btrfs_key key;
>> +	struct extent_buffer *eb;
>> +	struct btrfs_device_stats_item *ptr;
>> +	int ret;
>> +
>> +	key.objectid = 0;
>> +	key.type = BTRFS_DEVICE_STATS_KEY;
>> +	key.offset = device->devid;
>> +
>> +	path = btrfs_alloc_path();
>> +	BUG_ON(!path);
>> +	ret = btrfs_search_slot(trans, dev_root, &key, path, 0, 1);
> 
> 
> Since we may delete this item, I prefer cow: -1,
> 
> btrfs_search_slot(trans, dev_root, &key, path, 0, -1);
> 
> thanks,
> liubo

I am sure you mean to set ins_len (the 5th parameter) to -1 and you are
right. Thanks for this finding! I will send a v5.


>> +	if (ret < 0) {
>> +		printk(KERN_WARNING "btrfs: error %d while searching for device_stats item for device %s!\n",
>> +		       ret, device->name);
>> +		goto out;
>> +	}
>> +
>> +	if (ret == 0 &&
>> +	    btrfs_item_size_nr(path->nodes[0], path->slots[0]) < sizeof(*ptr)) {
>> +		/* need to delete old one and insert a new one */
>> +		ret = btrfs_del_item(trans, dev_root, path);
>> +		if (ret != 0) {
>> +			printk(KERN_WARNING "btrfs: delete too small device_stats item for device %s failed %d!\n",
>> +			       device->name, ret);
>> +			goto out;
>> +		}
>> +		ret = 1;
>> +	}
>> +
>> +	if (ret == 1) {
>> +		/* need to insert a new item */
>> +		btrfs_release_path(path);
>> +		ret = btrfs_insert_empty_item(trans, dev_root, path,
>> +					      &key, sizeof(*ptr));
>> +		if (ret < 0) {
>> +			printk(KERN_WARNING "btrfs: insert device_stats item for device %s failed %d!\n",
>> +			       device->name, ret);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	eb = path->nodes[0];
>> +	ptr = btrfs_item_ptr(eb, path->slots[0],
>> +			     struct btrfs_device_stats_item);
>> +	btrfs_set_device_stats_cnt_write_io_errs(eb, ptr,
>> +		btrfs_device_stat_read(&device->cnt_write_io_errs));
>> +	btrfs_set_device_stats_cnt_read_io_errs(eb, ptr,
>> +		btrfs_device_stat_read(&device->cnt_read_io_errs));
>> +	btrfs_set_device_stats_cnt_flush_io_errs(eb, ptr,
>> +		btrfs_device_stat_read(&device->cnt_flush_io_errs));
>> +	btrfs_set_device_stats_cnt_corruption_errs(eb, ptr,
>> +		btrfs_device_stat_read(&device->cnt_corruption_errs));
>> +	btrfs_set_device_stats_cnt_generation_errs(eb, ptr,
>> +		btrfs_device_stat_read(&device->cnt_generation_errs));
>> +	btrfs_mark_buffer_dirty(eb);
>> +
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +}
[...]
