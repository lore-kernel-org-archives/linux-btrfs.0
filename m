Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727184AbeHCNah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 09:30:37 -0400
Subject: Re: [PATCH] btrfs: btrfs_shrink_device should call commit transaction
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bde13ba6-21d9-e2bf-9ee1-b16818dff26a@suse.com>
Date: Fri, 3 Aug 2018 14:34:39 +0300
MIME-Version: 1.0
In-Reply-To: <b14154e5-9327-b106-97a9-f05af363387d@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180725132727.642-1-anand.jain@oracle.com>
 <3769497d-8aa7-c7d6-eaeb-3f8cd3c88bb6@suse.com>
 <b14154e5-9327-b106-97a9-f05af363387d@oracle.com>



On  3.08.2018 14:27, Anand Jain wrote:
> 
> 
> On 07/30/2018 10:18 PM, Nikolay Borisov wrote:
>>
>>
>> On 25.07.2018 16:27, Anand Jain wrote:
>>> test case btrfs/164 reported UAF..
>>>
>>> [ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
>>> ::
>>> [ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
>>> [ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
>>> [ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
>>> [ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
>>> ::
>>>
>>> reason for this is that btrfs_shrink_device() adds the device resized to
>>> the fs_devices::resized_devices after it has called the last commit
>>> transaction.
>>> So the list fs_devices::resized_devices is not empty when
>>> btrfs_shrink_device() returns.
>>> Now the parent function btrfs_rm_device() calls
>>>          btrfs_close_bdev(device);
>>>          call_rcu(&device->rcu, free_device_rcu);
>>> and then does the commit transaction.
>>> The commit transaction goes through the fs_devices::resized_devices
>>> in btrfs_update_commit_device_size() and leads to UAF.
>>>
>>> Fix this by making sure btrfs_shrink_device() calls the last needed
>>> btrfs_commit_transaction() before the return.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> I am bit skeptical about the condition when btrfs_commit_transaction()
>>> fails, can you pls be wary about it when reviewing. Thanks.
>>>
>>> Lu/David,
>>> As this issues isn't reproducible at my end, can you pls test this
>>> patch on top of the patch
>>>    btrfs: fix missing superblock update in the device delete commit
>>> transaction
>>> Thanks.
>>>
>>>   fs/btrfs/volumes.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 418843b8f8e8..344083cc811c 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -4464,7 +4464,10 @@ int btrfs_shrink_device(struct btrfs_device
>>> *device, u64 new_size)
>>>         /* Now btrfs_update_device() will change the on-disk size. */
>>>       ret = btrfs_update_device(trans, device);
>>> -    btrfs_end_transaction(trans);
>>> +    if (ret)
>>> +        btrfs_end_transaction(trans);
>>
>> Why don't you call btrfs_abort_transaction on error from
>> btrfs_update_device?
> 
> I still can't figure out, any idea why btrfs_abort_transaction?
> Per other codes, we are mixing the use of btrfs_abort_transaction and
> btrfs_end_transaction for the user initiated threads where
> if the thread fails (after btrfs_start_transaction), IMO
> we should let the user to try again. But btrfs_abort_transaction
> doesn't provide such a choice consistently as it would endup
> in RO.
> 
> ----
> static noinline int btrfs_ioctl_resize(struct file *file,
>                                         void __user *arg)
> {
> ::
>                 ret = btrfs_grow_device(trans, device, new_size);
>                 btrfs_commit_transaction(trans); <--Bug? ret is not
> checked.

Yep, this is a bug, btrfs_grow_device can return
EACCESS/EINVAL/ENOMEM/ENOENT (the last two from btrfs_update_device) so
the return value must be checked and transaction aborted IMO.

> ----
> static int __btrfs_balance(struct btrfs_fs_info *fs_info)
> {
> ::
>                 ret = btrfs_grow_device(trans, device, old_size);
>                 if (ret) {
>                         btrfs_end_transaction(trans);

I think this is wrong as well, btrfs_grow_device can fail and neither it
nor it's callees call btrfs_abort_transaction.

> -----
> static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>                                               void __user *arg)
> {
> ::
>         trans = btrfs_start_transaction(root, 1);
>         if (IS_ERR(trans)) {
>                 ret = PTR_ERR(trans);
>                 goto out_reset;
>         }
> 
>         ret = btrfs_update_root(trans, fs_info->tree_root,
>                                 &root->root_key, &root->root_item);
>         if (ret < 0) {
>                 btrfs_end_transaction(trans);
>                 goto out_reset;
>         }

btrfs_update_root calls btrfs_abort_transaction in all ret < 0 branches
hence the outter caller can simply call btrfs_end_transaction. In case
search_slot returns > 0 a BUG_ON is triggered.

Clearly there is a discrepancy in the code base as to who is reponsible
for aborting the transaction - the callee or the caller. In this case
it's the callee.
> 
>         ret = btrfs_commit_transaction(trans);
> ----
> static int btrfs_clone(struct inode *src, struct inode *inode,
>                        const u64 off, const u64 olen, const u64
> olen_aligned,
>                        const u64 destoff, int no_time_update)
> {
> 
>                         trans = btrfs_start_transaction(root, 3);
> ::
>                      if (ret) {
>                          if (ret != -EOPNOTSUPP)
>                             btrfs_abort_transaction(trans, ret);
>                         btrfs_end_transaction(trans);
>                         goto out;
>                      }
> ------
> ::
> 
> Thanks, Anand
> 
>>> +    else
>>> +        ret = btrfs_commit_transaction(trans);
>>>   done:
>>>       btrfs_free_path(path);
>>>       if (ret) {
>>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
