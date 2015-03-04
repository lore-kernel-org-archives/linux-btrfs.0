Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43867 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932486AbbCDPtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Mar 2015 10:49:09 -0500
Message-ID: <54F7296C.4020307@fb.com>
Date: Wed, 4 Mar 2015 10:49:00 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
References: <1425318415-322-1-git-send-email-jbacik@fb.com> <20150303110257.GA18292@localhost.localdomain> <20150303163533.GE11093@twin.jikos.cz> <20150304031231.GA16583@localhost.localdomain>
In-Reply-To: <20150304031231.GA16583@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/03/2015 10:12 PM, Liu Bo wrote:
> On Tue, Mar 03, 2015 at 05:35:33PM +0100, David Sterba wrote:
>> On Tue, Mar 03, 2015 at 07:02:58PM +0800, Liu Bo wrote:
>>> On Mon, Mar 02, 2015 at 12:46:55PM -0500, Josef Bacik wrote:
>>>> Dave could hit this assert consistently running btrfs/078.  This is because
>>>> when we update the block groups we could truncate the free space, which would
>>>> try to delete the csums for that range and dirty the csum root.  For this to
>>>> happen we have to have already written out the csum root so it's kind of hard to
>>>> hit this case.  This patch fixes this by changing the logic to only write the
>>>> dirty block groups if the dirty_cowonly_roots list is empty.  This will get us
>>>> the same effect as before since we add the extent root last, and will cover the
>>>> case that we dirty some other root again but not the extent root.  Thanks,
>>>
>>> Free space inode is NODATASUM, so its searching csum tree in
>>> __btrfs_free_extent() is really unnecessary, by skipping that, csum tree
>>> won't be inserted into dirty_cowonly_roots list again, so it also passed btrfs/078,
>>> at least on my box.
>>
>> I can hit the bug [1] even with Josef's patch, I'm can test your fix if you
>> want.
>>
>> MKFS_OPTIONS  -- -O skinny-metadata,extref -m single -d single --mixed /dev/sdc1
>> MOUNT_OPTIONS -- -o enospc_debug,space_cache,noatime /dev/sdc1 /mnt/a2
>>
>> on top of 3.19-rc5 with Chris' for-linus.
>
> I tested this fix on top of 4.0.0-rc1 which has the same commits with
> Chris's for-linus, I looply ran btrfs/078 for 10 times(5 times with the
> default mkfs option while 5 with your mkfs option), works good so far.
>
> So here it is,
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 571f402..111380c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6033,7 +6033,7 @@ static int __btrfs_free_extent(struct
> btrfs_trans_handle *trans,
>   		}
>   		btrfs_release_path(path);
>
> -		if (is_data) {
> +		if (is_data && root_objectid != BTRFS_ROOT_TREE_OBJECTID) {
>   			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
>   			if (ret) {
>   				btrfs_abort_transaction(trans, extent_root, ret);
>
>

I have this locally but it was causing problems with xfstests (or 
there's unrelated problems that I just haven't noticed before), so I 
didn't send it out yet.  My patch _should_ have fixed the problem, so if 
it didn't I want to figure out why before we go fixing other things. 
Thanks,

Josef
