Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44868 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751161AbcLFDEn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 22:04:43 -0500
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
 <20161102152151.GH12522@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <58468eae-e59e-61ff-6d50-233b27995bc1@cn.fujitsu.com>
Date: Tue, 6 Dec 2016 11:04:24 +0800
MIME-Version: 1.0
In-Reply-To: <20161102152151.GH12522@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/02/2016 11:21 PM, David Sterba wrote:
> On Wed, Sep 21, 2016 at 11:15:52AM +0800, Qu Wenruo wrote:
>> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>
>> Introduce a new function find_dir_item() to find DIR_ITEM for the given
>> key, and check it with the specified INODE_REF/INODE_EXTREF match.
>>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  cmds-check.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 140 insertions(+)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 998ba63..4e25804 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -3848,6 +3848,146 @@ out:
>>  	return err;
>>  }
>>
>> +#define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
>> +#define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
>> +#define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
>
> What's the reason for another definition of the error codes? They're
> mostly copied from te I_ERR_* counterparts. I'd rather have one set of
> error codes.

I tried to merge them into a 32bit error bits.

But things turns out that, I_ERR and REF_ERR have already taken 28 bits.
For a int type, we only have extra 4bits.

All fs tree level error code are OK to merge.
But extent tree level errors, including extent ref/backref error bits, 
and tree block level errors, like bad key type in current content or bad 
item size, have no corresponding bits.

These bits are already over 4 bits.


Yes, we can expand the error bit to u64, but that will be a huge 
modification for both the original mode and lowmem mode.


What about letting me separate the lowmem code from cmds-check.c into 
check/lowmem.c and using the current error when you're going to create 
check/ directory?

It should be OK to merge all lowmem error bits into one int type, but 
not possible to do it with original mode error bits without expanding 
the int type.
Since we have different error bit standard, this leads to completely 
different usage on these bits.
A lot of lowmem bit won't be used by original mode and vice-verse.

Thanks,
Qu


