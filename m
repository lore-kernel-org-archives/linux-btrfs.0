Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753160AbdI0O2f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 10:28:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FD01AC12
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:28:34 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: Abort transaction if btrfs_update_root fails
 in btrfs_ioctl_subvol_setflags
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
References: <1506436062-23825-1-git-send-email-nborisov@suse.com>
 <20170926173939.GV31640@twin.jikos.cz>
 <6c7f1d0c-d61e-8cab-7f90-01c76e10cd01@suse.com>
 <20170927140007.GH31640@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a8736c15-600e-ac23-24e7-21b3b8203848@suse.com>
Date: Wed, 27 Sep 2017 17:28:33 +0300
MIME-Version: 1.0
In-Reply-To: <20170927140007.GH31640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.09.2017 17:00, David Sterba wrote:
> On Wed, Sep 27, 2017 at 11:48:59AM +0300, Nikolay Borisov wrote:
>> On 26.09.2017 20:39, David Sterba wrote:
>>> On Tue, Sep 26, 2017 at 05:27:41PM +0300, Nikolay Borisov wrote:
>>>> btrfs_update_root can fail for any number of reasons, however the only error
>>>> handling we do is to revert the modified flags, yet we do not abort the
>>>> transaction but proceed to commit it.
>>>
>>> AFAICS btrfs_update_root aborts the transaction itself, so it's not
>>> needed in the caller.
>>>
>>>> Fix this by explicitly checking if the
>>>> update root routine has failed and abort the transaction.
>>>>
>>>> Fixes: 0caa102da827 ("Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctls")
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> ---
>>>>  fs/btrfs/ioctl.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>> index d6715c2bcdc4..09fcd51f0e8c 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -1842,8 +1842,11 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>>>>  
>>>>  	ret = btrfs_update_root(trans, fs_info->tree_root,
>>>>  				&root->root_key, &root->root_item);
>>>> +	if (ret < 0)
>>>> +		btrfs_abort_transaction(trans, ret);
>>>>  
>>>>  	btrfs_commit_transaction(trans);
>>>
>>> I think the error from commit_transaction should be returned as well if
>>> we get here.
>>>
>>> So:
>>>
>>> ret = btrfs_update_root();
>>>
>>> if (ret < 0) {
>>> 	end_transaction();
>>> 	goto out_reset;
>>> }
>>>
>>> ret = btrfs_commit_transaction();
>>>
>>> out_reset:
>>> /* and then as it is */
>>> if (ret)
>>> 	btrfs_set_root_flags(...);
>>>
>>> etc.
>>
>> I think even this is not needed, since btrfs_commit_transaction actually
>> handles aborted transaction by calling btrfs_end_transaction and
>> returning the error with which the trans was aborted. So I will just
>> drop this patch
> 
> From API point of view, I'd like to see some pattern, where we don't
> call commit after transaction abort IF we have enough information from
> the context. Ie. the abort and commit would be in the same function.
> Commit has to deal with an aborted transaction, that's right, but kind
> of an implementation detail and last resort resolution.

Fair point, I will respin the patch as well as some of my other
transaction error handling patches.


> 
