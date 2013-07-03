Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab3GCAnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 20:43:05 -0400
Message-ID: <51D373BF.2090100@cn.fujitsu.com>
Date: Wed, 03 Jul 2013 08:43:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Cleanup for using BTRFS_SETGET_STACK instead
 of raw convert
References: <1372224428-5597-1-git-send-email-quwenruo@cn.fujitsu.com> <20130702173612.GN18204@twin.jikos.cz>
In-Reply-To: <20130702173612.GN18204@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

于 2013年07月03日 01:36, David Sterba 写道:
> On Wed, Jun 26, 2013 at 01:27:08PM +0800, Qu Wenruo wrote:
>> --- a/btrfs-convert.c
>> +++ b/btrfs-convert.c
>> @@ -1802,7 +1802,7 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
>>   	btrfs_set_stack_chunk_num_stripes(chunk, 1);
>>   	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
>>   	chunk->stripe.devid = super->dev_item.devid;
> This should use the btrfs_set_* accessors too, right?
I'm afraid not. :(

chunk->stripe.devid is __le64 and so the same is dev_item.devid.
btrfs_set_* is calling cpu_to_le64, but neither of them is u64.

If using btrfs_set_*, we need to first convert le64 to cpu and then 
convert back.
So here I didn't use the btrfs_set_* functions.

>
>> -	chunk->stripe.offset = cpu_to_le64(0);
>> +	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
>>   	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
>>   	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
>>   	return 0;
>> --- a/btrfs-image.c
>> +++ b/btrfs-image.c
>> @@ -1332,7 +1332,7 @@ static void update_super_old(u8 *buffer)
>>   	btrfs_set_stack_chunk_num_stripes(chunk, 1);
>>   	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
>>   	chunk->stripe.devid = super->dev_item.devid;
> same here, and there's one more in update_super().
Same reason above.

>
>> -	chunk->stripe.offset = cpu_to_le64(0);
>> +	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
>>   	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
>>   	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
>>   	csum_block(buffer, 4096);


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

