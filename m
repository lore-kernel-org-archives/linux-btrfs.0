Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55545 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895Ab3BGKF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 05:05:59 -0500
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Mfl1O-1UHbKk1Nrg-00N9oy for
 <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2013 11:05:58 +0100
Message-ID: <51137CCA.203@gmx.net>
Date: Thu, 07 Feb 2013 11:07:06 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 2/2] Btrfs: fix memory leak of pending_snapshot->inherit
References: <51134384.6040601@cn.fujitsu.com> <51136943.9080201@gmx.net> <511373B8.1090207@cn.fujitsu.com>
In-Reply-To: <511373B8.1090207@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/13 10:28, Miao Xie wrote:
> On Thu, 07 Feb 2013 09:43:47 +0100, Arne Jansen wrote:
>> On 02/07/13 07:02, Miao Xie wrote:
>>> The argument "inherit" of btrfs_ioctl_snap_create_transid() was assigned
>>> to NULL during we created the snapshots, so we didn't free it though we
>>> called kfree() in the caller.
>>>
>>> But since we are sure the snapshot creation is done after the function -
>>> btrfs_ioctl_snap_create_transid() - completes, it is safe that we don't
>>> assign the pointer "inherit" to NULL, and just free it in the caller of
>>> btrfs_ioctl_snap_create_transid(). In this way, the code can become more
>>> readable.
>>
>> NAK. The snapshot creation is triggered from btrfs_commit_transaction,
>> I don't want to implicitly rely on commit_transaction being called for
>> each snapshot created. I'm not even sure the async path really commits
>> the transaction.
>> The responsibility for the creation is passed to the pending_snapshot
>> data structure, and so should the responsibility for the inherit struct.
> 
> I don't agree with you.
> 
> We are sure the async path really commits the transaction because we pass 1
> as the value of the third argument into btrfs_commit_transaction_async(). It
> means we must wait for the completion of the current transaction. So Freeing
> the inherit struct in the caller is safe.

I see your point. But speaking of readability, I have to trace quite a
lot of functions to see that even the async path waits for the snapshot
to be created. Which makes the name 'async' sort of pointless.
So from what I've read so far I _think_ your patch does the right thing.
Thanks for clearing that up.

-Arne

>  
> Besides that, the pending_snapshot data structure is also allocated and freed
> by the same function in fact, why not use this style for the inherit struct.
> I think it is more readable. Assigning a pointer to be NULL and freeing it
> in the caller is very strange for the people who reads the code. (It is also
> the reason why I made the mistake at the beginning.)
> 
> So I think my patch is reasonable.
> 
> Thanks
> Miao
> 
>> -Arne
>>
>>>
>>> Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
>>> Cc: Arne Jansen <sensille@gmx.net>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/ioctl.c | 18 +++++++-----------
>>>  1 file changed, 7 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 02d3035..40f2fbf 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -367,7 +367,7 @@ static noinline int create_subvol(struct btrfs_root *root,
>>>  				  struct dentry *dentry,
>>>  				  char *name, int namelen,
>>>  				  u64 *async_transid,
>>> -				  struct btrfs_qgroup_inherit **inherit)
>>> +				  struct btrfs_qgroup_inherit *inherit)
>>>  {
>>>  	struct btrfs_trans_handle *trans;
>>>  	struct btrfs_key key;
>>> @@ -401,8 +401,7 @@ static noinline int create_subvol(struct btrfs_root *root,
>>>  	if (IS_ERR(trans))
>>>  		return PTR_ERR(trans);
>>>  
>>> -	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid,
>>> -				   inherit ? *inherit : NULL);
>>> +	ret = btrfs_qgroup_inherit(trans, root->fs_info, 0, objectid, inherit);
>>>  	if (ret)
>>>  		goto fail;
>>>  
>>> @@ -530,7 +529,7 @@ fail:
>>>  
>>>  static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
>>>  			   char *name, int namelen, u64 *async_transid,
>>> -			   bool readonly, struct btrfs_qgroup_inherit **inherit)
>>> +			   bool readonly, struct btrfs_qgroup_inherit *inherit)
>>>  {
>>>  	struct inode *inode;
>>>  	struct btrfs_pending_snapshot *pending_snapshot;
>>> @@ -549,10 +548,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
>>>  	pending_snapshot->dentry = dentry;
>>>  	pending_snapshot->root = root;
>>>  	pending_snapshot->readonly = readonly;
>>> -	if (inherit) {
>>> -		pending_snapshot->inherit = *inherit;
>>> -		*inherit = NULL;	/* take responsibility to free it */
>>> -	}
>>> +	pending_snapshot->inherit = inherit;
>>>  
>>>  	trans = btrfs_start_transaction(root->fs_info->extent_root, 6);
>>>  	if (IS_ERR(trans)) {
>>> @@ -692,7 +688,7 @@ static noinline int btrfs_mksubvol(struct path *parent,
>>>  				   char *name, int namelen,
>>>  				   struct btrfs_root *snap_src,
>>>  				   u64 *async_transid, bool readonly,
>>> -				   struct btrfs_qgroup_inherit **inherit)
>>> +				   struct btrfs_qgroup_inherit *inherit)
>>>  {
>>>  	struct inode *dir  = parent->dentry->d_inode;
>>>  	struct dentry *dentry;
>>> @@ -1454,7 +1450,7 @@ out:
>>>  static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
>>>  				char *name, unsigned long fd, int subvol,
>>>  				u64 *transid, bool readonly,
>>> -				struct btrfs_qgroup_inherit **inherit)
>>> +				struct btrfs_qgroup_inherit *inherit)
>>>  {
>>>  	int namelen;
>>>  	int ret = 0;
>>> @@ -1563,7 +1559,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
>>>  
>>>  	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
>>>  					      vol_args->fd, subvol, ptr,
>>> -					      readonly, &inherit);
>>> +					      readonly, inherit);
>>>  
>>>  	if (ret == 0 && ptr &&
>>>  	    copy_to_user(arg +
>>>
>>
>>
> 

