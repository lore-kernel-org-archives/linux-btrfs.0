Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36407 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbdKAKmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 06:42:21 -0400
Subject: Re: [PATCH] btrfs: Move loop termination condition in while()
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
References: <1509528738-4387-1-git-send-email-nborisov@suse.com>
 <20171101144632.7c0b9e95@natsu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5cfe8dab-eadf-069a-4abf-bbb0d696d214@suse.com>
Date: Wed, 1 Nov 2017 12:42:18 +0200
MIME-Version: 1.0
In-Reply-To: <20171101144632.7c0b9e95@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.11.2017 11:46, Roman Mamedov wrote:
> On Wed,  1 Nov 2017 11:32:18 +0200
> Nikolay Borisov <nborisov@suse.com> wrote:
> 
>> Fallocating a file in btrfs goes through several stages. The one before actually
>> inserting the fallocated extents is to create a qgroup reservation, covering
>> the desired range. To this end there is a loop in btrfs_fallocate which checks
>> to see if there are holes in the fallocated range or !PREALLOC extents past EOF
>> and if so create qgroup reservations for them. Unfortunately, the main condition
>> of the loop is burried right at the end of its body rather than in the actual
>> while statement which makes it non-obvious. Fix this by moving the condition
>> in the while statement where it belongs. No functional changes.
> 
> If it turns out that "cur_offset >= alloc_end" from the get go, previously the
> loop body would be entered and executed once. With this change, it will not
> anymore.

Good point, however this cannot happen, because for this to happen then
the following 2 expression need to be equal:

alloc_start = round_down(offset, blocksize);
alloc_end = round_up(offset + len, blocksize);

However, len is guaranteed to be > 0  due to a check in vfs_fallocate so
those can't really be equal.


> 
> I did not examine the context to see if such case is possible, likely,
> beneficial or harmful. But if you wanted 100% no functional changes no matter> what, maybe better use a "do ... while" loop?



> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/file.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index e0d15c0d1641..ecbe186cb5da 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -3168,7 +3168,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>>  
>>  	/* First, check if we exceed the qgroup limit */
>>  	INIT_LIST_HEAD(&reserve_list);
>> -	while (1) {
>> +	while (cur_offset < alloc_end) {
>>  		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
>>  				      alloc_end - cur_offset, 0);
>>  		if (IS_ERR(em)) {
>> @@ -3204,8 +3204,6 @@ static long btrfs_fallocate(struct file *file, int mode,
>>  		}
>>  		free_extent_map(em);
>>  		cur_offset = last_byte;
>> -		if (cur_offset >= alloc_end)
>> -			break;
>>  	}
>>  
>>  	/*
> 
> 
> 
