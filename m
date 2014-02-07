Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:42073 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBGJnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 04:43:08 -0500
Message-ID: <52F4AAAB.7050902@giantdisaster.de>
Date: Fri, 07 Feb 2014 10:43:07 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] Btrfs: fix use-after-free in the finishing procedure
 of the device replace
References: <1391071615-6729-1-git-send-email-miaox@cn.fujitsu.com> <1391071615-6729-2-git-send-email-miaox@cn.fujitsu.com> <52F495F2.6020606@giantdisaster.de> <52F4A4B9.20506@cn.fujitsu.com>
In-Reply-To: <52F4A4B9.20506@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 07 Feb 2014 17:17:45 +0800, Miao Xie wrote:
> On Fri, 07 Feb 2014 09:14:42 +0100, Stefan Behrens wrote:
>> On Thu, 30 Jan 2014 16:46:55 +0800, Miao Xie wrote:
>>> During device replace test, we hit a null pointer deference (It was very easy
>>> to reproduce it by running xfstests' btrfs/011 on the devices with the virtio
>>> scsi driver). There were two bugs that caused this problem:
>>> - We might allocate new chunks on the replaced device after we updated
>>>   the mapping tree. And we forgot to replace the source device in those
>>>   mapping of the new chunks.
>>> - We might get the mapping information which including the source device
>>>   before the mapping information update. And then submit the bio which was
>>>   based on that mapping information after we freed the source device.
>>>
>>> For the first bug, we can fix it by doing mapping tree update and source
>>> device remove in the same context of the chunk mutex. The chunk mutex is
>>> used to protect the allocable device list, the above method can avoid
>>> the new chunk allocation, and after we remove the source device, all
>>> the new chunks will be allocated on the new device. So it can fix
>>> the first bug.
>>>
>>> For the second bug, we need make sure all flighting bios are finished and
>>> no new bios are produced during we are removing the source device. To fix
>>> this problem, we introduced a global @bio_counter, we not only inc/dec
>>> @bio_counter outsize of map_blocks, but also inc it before submitting bio
>>> and dec @bio_counter when ending bios.
>>>
>>> Since Raid56 is a little different and device replace dosen't support raid56
>>> yet, it is not addressed in the patch and I add comments to make sure we will
>>> fix it in the future.
>>>
>>> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/ctree.h       |  9 ++++++
>>>  fs/btrfs/dev-replace.c | 74 +++++++++++++++++++++++++++++++++++++++++++++-----
>>>  fs/btrfs/disk-io.c     | 12 +++++++-
>>>  fs/btrfs/volumes.c     | 30 +++++++++++++++-----
>>>  fs/btrfs/volumes.h     |  1 +
>>>  5 files changed, 111 insertions(+), 15 deletions(-)
[...]
>>>  static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>>  				       int scrub_ret)
>>>  {
>>> @@ -458,12 +487,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>>  	src_device = dev_replace->srcdev;
>>>  	btrfs_dev_replace_unlock(dev_replace);
>>>  
>>> -	/* replace old device with new one in mapping tree */
>>> -	if (!scrub_ret)
>>> -		btrfs_dev_replace_update_device_in_mapping_tree(fs_info,
>>> -								src_device,
>>> -								tgt_device);
>>> -
>>
>> Isn't this change the reason that you need to add code to count bios?
> 
> No, the change is not the reason to introduce a bio counter.
> 
> The above two bugs are independent, the second bug can happen even the first one
> doesn't exist, for example:
> 	Task1			Task2
> 				btrfs_readpages()
> 				  btrfs_map_bio()
> 				    __btrfs_map_block()
> 				    <be blocked for a long time>

You are right!
Thanks.


> 	device replace start
> 	device replace finish
> 	  release source device
> 				    bio_size_ok()
> 				      bdev_get_queue()
> 					oops
> 
>> I mean, code is there to flush everything to disk. It's needed for sync,
>> too. When btrfs_dev_replace_finishing() is called, the copy operation is
>> finished and the replaced and the replacement drive are logically
>> identical except that data is not yet forced to be flushed to disk. The
>> only difference between both disks is the bdev block device pointer and
>> the btrfs device pointer.
>>
>> I think this is the correct and lightweight procedure:
>>
>> 1. After the copy operation finished, from now on, always use the new
>> btrfs device and the new block device.
>> 2. Flush all outstanding bios and wait for them.
>> 3. Close the block dev and free the btrfs device.
>>
>> You said that the problem was that we might allocate new chunks on the
>> replaced device after we updated the mapping tree. Well, can't we just
>> make sure the new chunks are allocated using the new device pointers
>> after step 1 and all issues are resolved? I think that the first change
>> is not a good idea and causes the other issues that you fix with a lot
>> of code.
> 
> Step1 can fix the first problem, but need more code to recover the mapping
> tree when the flush fails.
> 
> And as I said above, the second bug is not introduced by the fix of the first
> bug, we have to add a bio counter. Any good idea?
> 
> BTW, the reason why I mixed two fixes into one patch is that we could not fix
> the oops by any one of them. I can split it into two patches if need. 
> 
> Thanks
> Miao


