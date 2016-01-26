Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:40663 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933948AbcAZJDp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 04:03:45 -0500
Subject: Re: [PATCH] btrfs: simplify expression in
 btrfs_csum_bytes_to_leaves()
To: Byongho Lee <bhlee.kernel@gmail.com>
References: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com>
 <56A729F8.4010603@giantdisaster.de> <87r3h4lodz.fsf@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Stefan Behrens <sbehrens@giantdisaster.de>
Message-ID: <56A7366D.3080908@giantdisaster.de>
Date: Tue, 26 Jan 2016 10:03:41 +0100
MIME-Version: 1.0
In-Reply-To: <87r3h4lodz.fsf@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Correction: The result of the calculation is equal, which looks right.
Sorry for overlooking the closing bracket.

Reviewed-By: Stefan Behrens <sbehrens@giantdisaster.de>


On Tue, 26 Jan 2016 17:46:00 +0900, Byongho Lee wrote:
> Stefan Behrens writes:
> 
>> The result of the calculation is different, which doesn't look right.
>>
> The expression comes out this way.
>   (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) * 2 * num_items
> ->(root->nodesize * (1 + BTRFS_MAX_LEVEL - 1)) * 2 * num_items
> ->(root->nodesize * (BTRFS_MAX_LEVEL)) * 2 * num_items
> =>root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items
> 
> Am I missing?
> 
>>
>> On Tue, 26 Jan 2016 16:13:17 +0900, Byongho Lee wrote:
>>> Simplify expression in btrfs_csum_bytes_to_leaves().
>>>
>>> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
>>> ---
>>>  fs/btrfs/ctree.h | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index a9496644f47d..3ab8026280a2 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -3448,8 +3448,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
>>>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
>>>  						 unsigned num_items)
>>>  {
>>> -	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
>>> -		2 * num_items;
>>> +	return root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>>>  }
>>>  
>>>  /*
