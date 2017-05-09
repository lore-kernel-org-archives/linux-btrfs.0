Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54316 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755704AbdEIRBN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 13:01:13 -0400
Subject: Re: [PATCH] btrfs: remove redundant assignment and check on variable
 ret
To: bo.li.liu@oracle.com
References: <20170506220105.13206-1-colin.king@canonical.com>
 <20170509165552.GA15294@lim.localdomain>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <6474c97a-3a91-43ef-3c55-4ad1df9947fc@canonical.com>
Date: Tue, 9 May 2017 18:01:09 +0100
MIME-Version: 1.0
In-Reply-To: <20170509165552.GA15294@lim.localdomain>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/17 17:55, Liu Bo wrote:
> On Sat, May 06, 2017 at 11:01:05PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Variable ret is assigned to zero and is always zero throughout the
>> function.  Thus the check for ret being less than zero is always
>> false and so mapping_set_error always has an -EIO error passed to
>> it.  Hence we can remove the redundant assignment and check on ret.
>>
>> Detected by CoverityScan, CID#1414312 ("Logically dead code")
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/btrfs/extent_io.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index d8da3edf2ac3..7922cd34ba82 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2447,7 +2447,6 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>>  {
>>  	int uptodate = (err == 0);
>>  	struct extent_io_tree *tree;
>> -	int ret = 0;
>>  
>>  	tree = &BTRFS_I(page->mapping->host)->io_tree;
>>  
>> @@ -2458,8 +2457,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>>  	if (!uptodate) {
>>  		ClearPageUptodate(page);
>>  		SetPageError(page);
>> -		ret = ret < 0 ? ret : -EIO;
>> -		mapping_set_error(page->mapping, ret);
>> +		mapping_set_error(page->mapping, -EIO);
> 
> The passed 'err' should be used as what ret did, ie.
> ret = err < 0 ? err : -EIO;

Ah, so the err passed into the function should be used instead of ret,
which makes more sense. Got it. I'll send a fix for that.

Colin

> 
> Thanks,
> 
> -liubo
>>  	}
>>  }
>>  
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

