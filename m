Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24091 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdI1G4s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:56:48 -0400
Subject: Re: [PATCH v3 0/2] fix bug in btrfs_init_new_device()
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20170926084738.3558-1-anand.jain@oracle.com>
 <612a7520-a83d-9032-bbbb-7b13ab76f43f@suse.com>
 <20170927142224.GJ31640@twin.jikos.cz>
 <f81f53d2-a314-426a-b21b-457e116a7405@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ba658ee7-31f6-dab0-7131-a86eb4f7ee01@oracle.com>
Date: Thu, 28 Sep 2017 14:55:49 +0800
MIME-Version: 1.0
In-Reply-To: <f81f53d2-a314-426a-b21b-457e116a7405@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/27/2017 10:26 PM, Nikolay Borisov wrote:
> 
> 
> On 27.09.2017 17:22, David Sterba wrote:
>> On Tue, Sep 26, 2017 at 03:14:27PM +0300, Nikolay Borisov wrote:
>>>
>>>
>>> On 26.09.2017 11:47, Anand Jain wrote:
>>>> 1/2 fixes a bug which failed to reset writable when sprouting failed
>>>> 2/2 fixes BUG_ON in btrfs_init_new_device()
>>>>
>>>> Anand Jain (2):
>>>>    btrfs: undo writable when sprouting fails
>>>>    btrfs: fix BUG_ON in btrfs_init_new_device()
>>>
>>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>
>> Please note that this would lead to unexpected unlocks of uuid_mutex and
>> sb::s_umount:
>>
>> 2465         ret = btrfs_commit_transaction(trans);
>> 2466
>> 2467         if (seeding_dev) {
>> 2468                 mutex_unlock(&uuid_mutex);
>> 2469                 up_write(&sb->s_umount);
>>
>> first unlocks
>>
>> 2470
>> 2471                 if (ret) /* transaction commit */
>> 2472                         return ret;
>> 2473
>> 2474                 ret = btrfs_relocate_sys_chunks(fs_info);
>> 2475                 if (ret < 0)
>> 2476                         btrfs_handle_fs_error(fs_info, ret,
>> 2477                                     "Failed to relocate sys chunks after device initialization. This can be fixed using the \"btrfs balance\"
>> 2478                 trans = btrfs_attach_transaction(root);
>> 2479                 if (IS_ERR(trans)) {
>> 2480                         if (PTR_ERR(trans) == -ENOENT)
>> 2481                                 return 0;
>> 2482                         return PTR_ERR(trans);
>> ^^^^
>>
>> this becomes goto 2494
>>
>> 2483                 }
>> 2484                 ret = btrfs_commit_transaction(trans);
>> 2485         }
>> 2486
>> 2487         /* Update ctime/mtime for libblkid */
>> 2488         update_dev_time(device_path);
>> 2489         return ret;
>> 2490
>> 2491 error_trans:
>> 2492         btrfs_end_transaction(trans);
>> 2493         rcu_string_free(device->name);
>> 2494         btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
>>
>> here
>>
>> 2495         kfree(device);
>> 2496 error:
>> 2497         blkdev_put(bdev, FMODE_EXCL);
>> 2498         if (seeding_dev) {
>> 2499                 mutex_unlock(&uuid_mutex);
>> 2500                 up_write(&sb->s_umount);
>>
>> and unlocking again
>>
>> 2501         }
>> 2502         return ret;
>>
>> So the in-place returns had a meaning but are quite confusing.

  Oops. I forgot about it though I noticed, will fix it.

> I concur and had missed that ;(. 

  No you didn't, the changes which David is talking about isn't in this 
set. It was independent patch: But, my fault, to confuse about the patch 
set.
    [PATCH] btrfs: take the error path out if btrfs_attach_transaction() 
fails

V4 is sent to clear this.

Thanks, Anand


> I saw that you suggested Anand to
> overhaul the overall error handling in this function and I believe this
> would be the best course of action.
