Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34799 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbcAZIqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 03:46:06 -0500
Received: by mail-pa0-f51.google.com with SMTP id uo6so96749899pac.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 00:46:05 -0800 (PST)
References: <1453792397-4363-1-git-send-email-bhlee.kernel@gmail.com> <56A729F8.4010603@giantdisaster.de>
From: Byongho Lee <bhlee.kernel@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: simplify expression in btrfs_csum_bytes_to_leaves()
In-reply-to: <56A729F8.4010603@giantdisaster.de>
Date: Tue, 26 Jan 2016 17:46:00 +0900
Message-ID: <87r3h4lodz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Stefan,

Stefan Behrens writes:

> The result of the calculation is different, which doesn't look right.
>
The expression comes out this way.
  (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) * 2 * num_items
->(root->nodesize * (1 + BTRFS_MAX_LEVEL - 1)) * 2 * num_items
->(root->nodesize * (BTRFS_MAX_LEVEL)) * 2 * num_items
=>root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items

Am I missing?

>
> On Tue, 26 Jan 2016 16:13:17 +0900, Byongho Lee wrote:
>> Simplify expression in btrfs_csum_bytes_to_leaves().
>> 
>> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
>> ---
>>  fs/btrfs/ctree.h | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index a9496644f47d..3ab8026280a2 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3448,8 +3448,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
>>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
>>  						 unsigned num_items)
>>  {
>> -	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
>> -		2 * num_items;
>> +	return root->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
>>  }
>>  
>>  /*
>>  

