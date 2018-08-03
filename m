Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48380 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbeHCNTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 09:19:24 -0400
Subject: Re: [PATCH] btrfs: btrfs_shrink_device should call commit transaction
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b14154e5-9327-b106-97a9-f05af363387d@oracle.com>
Date: Fri, 3 Aug 2018 19:27:01 +0800
MIME-Version: 1.0
In-Reply-To: <3769497d-8aa7-c7d6-eaeb-3f8cd3c88bb6@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180725132727.642-1-anand.jain@oracle.com>
 <3769497d-8aa7-c7d6-eaeb-3f8cd3c88bb6@suse.com>



On 07/30/2018 10:18 PM, Nikolay Borisov wrote:
> 
> 
> On 25.07.2018 16:27, Anand Jain wrote:
>> test case btrfs/164 reported UAF..
>>
>> [ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
>> ::
>> [ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
>> [ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
>> [ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
>> [ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
>> ::
>>
>> reason for this is that btrfs_shrink_device() adds the device resized to
>> the fs_devices::resized_devices after it has called the last commit
>> transaction.
>> So the list fs_devices::resized_devices is not empty when
>> btrfs_shrink_device() returns.
>> Now the parent function btrfs_rm_device() calls
>>          btrfs_close_bdev(device);
>>          call_rcu(&device->rcu, free_device_rcu);
>> and then does the commit transaction.
>> The commit transaction goes through the fs_devices::resized_devices
>> in btrfs_update_commit_device_size() and leads to UAF.
>>
>> Fix this by making sure btrfs_shrink_device() calls the last needed
>> btrfs_commit_transaction() before the return.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> I am bit skeptical about the condition when btrfs_commit_transaction()
>> fails, can you pls be wary about it when reviewing. Thanks.
>>
>> Lu/David,
>> As this issues isn't reproducible at my end, can you pls test this
>> patch on top of the patch
>>    btrfs: fix missing superblock update in the device delete commit transaction
>> Thanks.
>>
>>   fs/btrfs/volumes.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 418843b8f8e8..344083cc811c 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4464,7 +4464,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>>   
>>   	/* Now btrfs_update_device() will change the on-disk size. */
>>   	ret = btrfs_update_device(trans, device);
>> -	btrfs_end_transaction(trans);
>> +	if (ret)
>> +		btrfs_end_transaction(trans);
> 
> Why don't you call btrfs_abort_transaction on error from
> btrfs_update_device?

I still can't figure out, any idea why btrfs_abort_transaction?
Per other codes, we are mixing the use of btrfs_abort_transaction and
btrfs_end_transaction for the user initiated threads where
if the thread fails (after btrfs_start_transaction), IMO
we should let the user to try again. But btrfs_abort_transaction
doesn't provide such a choice consistently as it would endup
in RO.

----
static noinline int btrfs_ioctl_resize(struct file *file,
                                         void __user *arg)
{
::
                 ret = btrfs_grow_device(trans, device, new_size);
                 btrfs_commit_transaction(trans); <--Bug? ret is not 
checked.
----
static int __btrfs_balance(struct btrfs_fs_info *fs_info)
{
::
                 ret = btrfs_grow_device(trans, device, old_size);
                 if (ret) {
                         btrfs_end_transaction(trans);
-----
static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
                                               void __user *arg)
{
::
         trans = btrfs_start_transaction(root, 1);
         if (IS_ERR(trans)) {
                 ret = PTR_ERR(trans);
                 goto out_reset;
         }

         ret = btrfs_update_root(trans, fs_info->tree_root,
                                 &root->root_key, &root->root_item);
         if (ret < 0) {
                 btrfs_end_transaction(trans);
                 goto out_reset;
         }

         ret = btrfs_commit_transaction(trans);
----
static int btrfs_clone(struct inode *src, struct inode *inode,
                        const u64 off, const u64 olen, const u64 
olen_aligned,
                        const u64 destoff, int no_time_update)
{

                         trans = btrfs_start_transaction(root, 3);
::
                      if (ret) {
                          if (ret != -EOPNOTSUPP)
                             btrfs_abort_transaction(trans, ret);
                         btrfs_end_transaction(trans);
                         goto out;
                      }
------
::

Thanks, Anand

>> +	else
>> +		ret = btrfs_commit_transaction(trans);
>>   done:
>>   	btrfs_free_path(path);
>>   	if (ret) {
>>
