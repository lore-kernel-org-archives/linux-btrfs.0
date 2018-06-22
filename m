Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:59030 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933593AbeFVP0F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 11:26:05 -0400
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
To: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
 <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <06086fd3-f28b-5cc7-f3c6-3fca659b2fa0@mendix.com>
Date: Fri, 22 Jun 2018 17:26:02 +0200
MIME-Version: 1.0
In-Reply-To: <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2018 01:48 PM, Nikolay Borisov wrote:
> 
> 
> On 22.06.2018 04:52, Su Yue wrote:
>> For easier debug, print eb->start if level is invalid.
>> Also make print clear if bytenr found is not expected.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/disk-io.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index c3504b4d281b..a90dab84f41b 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>  
>>  	found_start = btrfs_header_bytenr(eb);
>>  	if (found_start != eb->start) {
>> -		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
>> -			     found_start, eb->start);
>> +		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
> 
> nit: I'd rather have the want/have in brackets (want %llu have% llu)

>From a user support point of view, this text should really be improved.
There are a few places where 'want' and 'have' are reported in error
strings, and it's totally unclear what they mean.

Intuitively I'd say when checking a csum, the "want" would be what's on
disk now, since you want that to be correct, and the "have" would be
what you have calculated, but it's actually the other way round, or
wasn't it? Or was it?

Every time someone pastes such a message when we help on IRC for
example, there's confusion, and I have to look up the source again,
because I always forget.

What about (%llu stored on disk, %llu calculated now) or something similar?

> 
>> +			     eb->start, found_start);
>>  		ret = -EIO;
>>  		goto err;
>>  	}
>> @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>  	}
>>  	found_level = btrfs_header_level(eb);
>>  	if (found_level >= BTRFS_MAX_LEVEL) {
>> -		btrfs_err(fs_info, "bad tree block level %d",
>> -			  (int)btrfs_header_level(eb));
>> +		btrfs_err(fs_info, "bad tree block level %d on %llu",
>> +			  (int)btrfs_header_level(eb), eb->start);
>>  		ret = -EIO;
>>  		goto err;
>>  	}
>>

-- 
Hans van Kranenburg
