Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57666 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752506AbdIWBJf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 21:09:35 -0400
Subject: Re: [PATCH] Btrfs: use self-explaining variable
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
 <20170922233618.20034-1-bo.li.liu@oracle.com>
 <4d9fe9dd-ccde-964c-ea88-bce4eeafc81a@gmx.com>
 <20170923004837.GD8109@lim.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <02a5af04-f1b3-cdef-d77d-55c0517c12ad@gmx.com>
Date: Sat, 23 Sep 2017 09:09:24 +0800
MIME-Version: 1.0
In-Reply-To: <20170923004837.GD8109@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月23日 08:48, Liu Bo wrote:
> On Sat, Sep 23, 2017 at 08:46:55AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月23日 07:36, Liu Bo wrote:
>>> This uses a bool 'do_backup' to help understand this piece of code.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>> This is based on a patch "Btrfs: do not backup tree roots when fsync".
>>>
>>>    fs/btrfs/disk-io.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index cdb7043..9811b9d 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3691,6 +3691,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>>>    	int max_errors;
>>>    	int total_errors = 0;
>>>    	u64 flags;
>>> +	bool do_backup = (max_mirrors == 0);
>>
>> Why not replacing @max_mirrors with @do_backup as parameter?
> 
> If I read the code correctly, max_mirrors is not just for deciding
> backup.

That's strange.

write_all_supers() only uses @max_mirrors by passing it to 
write_dev_supers() and wait_dev_supers().

Both of the write/wait_dev_supers() will replace @max_mirrors to 
BTRFS_SUPER_MIRROR_MAX if it's zero.

Further more, all write_all_supers() callers just pass @max_mirrors as 
bool (either 0 or 1).

So I don't see any point not replacing the parameter as bool.

Thanks,
Qu
> 
> thanks,
> 
> -liubo
> 
>>
>> Thanks,
>> Qu
>>>    	do_barriers = !btrfs_test_opt(fs_info, NOBARRIER);
>>> @@ -3699,7 +3700,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>>>    	 * not from fsync where the tree roots in fs_info have not
>>>    	 * been consistent on disk.
>>>    	 */
>>> -	if (max_mirrors == 0)
>>> +	if (do_backup)
>>>    		backup_super_roots(fs_info);
>>>    	sb = fs_info->super_for_commit;
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
