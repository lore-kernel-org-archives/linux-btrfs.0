Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32686 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdI0J7Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 05:59:16 -0400
Subject: Re: [PATCH v3 1/2] btrfs: undo writable when sprouting fails
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <20170926084135.3189-1-anand.jain@oracle.com>
 <20170926084135.3189-2-anand.jain@oracle.com>
 <0ea2f1ae-4145-aa76-62a6-bdbbbeea9594@gmx.com>
 <20170926174957.GW31640@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <43e8edba-408a-19ba-3bd9-474ac383de22@oracle.com>
Date: Wed, 27 Sep 2017 17:58:44 +0800
MIME-Version: 1.0
In-Reply-To: <20170926174957.GW31640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/27/2017 01:49 AM, David Sterba wrote:
> On Tue, Sep 26, 2017 at 08:57:47PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月26日 16:41, Anand Jain wrote:
>>> When new device is being added to seed FS, seed FS is marked writable,
>>> but when we fail to bring in the new device, we missed to undo the
>>> writable part. This patch fixes it.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>    fs/btrfs/volumes.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 0e8f16c305df..9d64700cc9b6 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -2501,6 +2501,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>>    	return ret;
>>>    
>>>    error_trans:
>>> +	if (seeding_dev)
>>> +		sb->s_flags |= MS_RDONLY;
>>
>> Still the same question.
>>
>> ---
>> 	if (seeding_dev) {
>> 		mutex_unlock(&uuid_mutex);
>> 		up_write(&sb->s_umount);
>>
>> 		if (ret) /* transaction commit */
>> 			return ret;
>>
>> 		ret = btrfs_relocate_sys_chunks(fs_info);
>> 		if (ret < 0)
>> 			btrfs_handle_fs_error(fs_info, ret,
>> 				    "Failed to relocate sys chunks after device initialization. This
>> can be fixed using the \"btrfs balance\" command.");
>> 		trans = btrfs_attach_transaction(root);
>> 		if (IS_ERR(trans)) {
>> 			if (PTR_ERR(trans) == -ENOENT)
>> 				return 0;
>> 			return PTR_ERR(trans);
>> 		}
>> ---
>> In the above btrfs_attch_transaction() error handler, which just
>> returned without going to error_trans tags, did we misseed the s_flag
>> revert thing?
> 
> I think so. Also I think "sb->s_flags |= MS_RDONLY;" can be moved to the
> 'if' after the error: label, where we already check the 'seeding_dev'
> condition.

Qu, David,

  Thanks. I have fixed that in a new patch as its wasn't about fixing 
the BUG_ON().

  Further, there is another bug that, in the original code we failed to 
undo the btrfs_prepare_sprout() part. I am attempting to fix that, its 
bit complicated. For now, fix for Qu found bug is sent to the ML.

-Anand
