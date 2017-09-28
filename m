Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36144 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdI1HNg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 03:13:36 -0400
Subject: Re: [PATCH] btrfs: take the error path out if
 btrfs_attach_transaction() fails
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com
References: <20170927095052.22663-1-anand.jain@oracle.com>
 <20170927141701.GI31640@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7e4678b8-5aa4-f90a-b633-db77b4199a11@oracle.com>
Date: Thu, 28 Sep 2017 15:13:06 +0800
MIME-Version: 1.0
In-Reply-To: <20170927141701.GI31640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/27/2017 10:17 PM, David Sterba wrote:
> On Wed, Sep 27, 2017 at 05:50:52PM +0800, Anand Jain wrote:
>> btrfs_init_new_device() calls btrfs_attach_transaction() to
>> commit sys chunks, however take the error path out if it fails.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index fad3b10a1f81..b526d13a74da 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2494,7 +2494,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>   		if (IS_ERR(trans)) {
>>   			if (PTR_ERR(trans) == -ENOENT)
>>   				return 0;
>> -			return PTR_ERR(trans);
>> +			ret = PTR_ERR(trans);
>> +			goto error_sysfs;
> 
> The label is introduced by another patch, please resend the whole
> patchset, I've seen several iterations and feedback from various people
> and I'm not sure I'm looking at the latest version.

  Pls consider V4, in the ML.

> Regarding error handling in btrfs_init_new_device, the seeding device
> makes it hard to read. This patch would lead to a double unlock of
> uuid_mutex and sb::s_umount, because the label error_sysfs will continue
> to do the cleanups, that were already partially done in the containing
> 'if (seeding_dev)' block where the test fails.

  Fixed this in
    [PATCH v4 3/3] btrfs: error out if btrfs_attach_transaction() fails

> I'd suggest to first get rid of the in-place returns and add necessary
> labels or separate exit sequences and then address the new error
> handling.

   As it goes deeper there are quite a number of things which aren't
   un-done during fail error return .. adding one more to the list
   is sb->super_copy updates. With this current design on this function
   its kind of too difficult to undo and error return. As
   btrfs_init_new_device() is shared between normal device add and
   sprout device add. I am mulling on completely removing seed part
   to outside of the btrfs_init_new_device(). such as ..
         prepare sprout.
         ret = btrfs_init_new_device() which is without the seed part
         if(ret) undo_prepare_sprout
         else finish sprouting.
    Also with this I think we would find few duplicate code sections
    between btrfs_init_new_device() and replace device which will be
    a nice cleanup as a whole. This is a long term plan, for now
    I think v4 is good.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
