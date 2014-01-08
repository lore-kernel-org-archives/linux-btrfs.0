Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28398 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469AbaAHOmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 09:42:40 -0500
Message-ID: <52CD63DA.30101@fb.com>
Date: Wed, 8 Jan 2014 09:42:34 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: rework qgroup accounting
References: <1387400849-7274-1-git-send-email-jbacik@fb.com> <1387400849-7274-3-git-send-email-jbacik@fb.com> <20140108143327.GG6498@twin.jikos.cz>
In-Reply-To: <20140108143327.GG6498@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/08/2014 09:33 AM, David Sterba wrote:
> On Wed, Dec 18, 2013 at 04:07:28PM -0500, Josef Bacik wrote:
>>   /*
>> - * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
>> - * the modification into a list that's later used by btrfs_end_transaction to
>> - * pass the recorded modifications on to btrfs_qgroup_account_ref.
>> + * Record a quota operation for processing later on.
>> + * @trans: the transaction we are adding the delayed op to.
>> + * @fs_info: the fs_info for this fs.
>> + * @ref_root: the root of the reference we are acting on,
>> + * @num_bytes: the number of bytes in the reference.
>> + * @parent: if we are removing a shared ref then this will be set.
>> + * @type: the type of operation this is.
>> + *
>> + * We just add it to our trans qgroup_ref_list and carry on and process these
>> + * operations in order at some later point.  If the reference root isn't a fs
>> + * root then we don't bother with doing anything.
>> + *
>> + * MUST BE HOLDING THE REF LOCK.
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>>    */
>>   int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
>> -			    struct btrfs_delayed_ref_node *node,
>> -			    struct btrfs_delayed_extent_op *extent_op)
>> +			    struct btrfs_fs_info *fs_info, u64 ref_root,
>> +			    u64 bytenr, u64 num_bytes, u64 parent,
>> +			    enum btrfs_qgroup_operation_type type)
>>   {
>> -	struct qgroup_update *u;
>> +	struct btrfs_qgroup_operation *oper;
>> +	int ret;
>>   
>> -	BUG_ON(!trans->delayed_ref_elem.seq);
>> -	u = kmalloc(sizeof(*u), GFP_NOFS);
>> -	if (!u)
>> +	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
>> +		return 0;
>> +
>> +	oper = kmalloc(sizeof(*oper), GFP_NOFS);
> Must use GFP_ATOMIC then, ohterwise spits some warnings:

This is because I'm still holding the tree lock, the ref_lock is just a 
range lock so you can allocate under it.  I'll fix this up, thanks,

Josef
