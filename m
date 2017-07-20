Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24824 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932774AbdGTCP2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 22:15:28 -0400
Subject: Re: [PATCH] btrfs: make use of inode_need_compress()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170718093747.19046-1-anand.jain@oracle.com>
 <20170718150125.GT2866@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e48652eb-78bb-d6b7-4bbf-3722f0af2fb7@oracle.com>
Date: Thu, 20 Jul 2017 10:22:13 +0800
MIME-Version: 1.0
In-Reply-To: <20170718150125.GT2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/18/2017 11:01 PM, David Sterba wrote:
> On Tue, Jul 18, 2017 at 05:37:47PM +0800, Anand Jain wrote:
>> Its better to have the policy enforcement going through a function,
>> so that we have better control and visibility of the decision logic.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/inode.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 06dea7c89bbd..d0cc3de120b7 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -1189,11 +1189,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>>   		async_cow->locked_page = locked_page;
>>   		async_cow->start = start;
>>   
>> -		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
>> -		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
>> -			cur_end = end;
>> -		else
>> +		if (inode_need_compress(inode))
>>   			cur_end = min(end, start + SZ_512K - 1);
>> +		else
>> +			cur_end = end;
> 
> The opencoded test should be cleaned up, however cow_file_range_async is
> called from run_delalloc_range if the inode_need_compress passes the
> 'inode_need_compress' condition. So at minimum, checking again here is
> redundant,

  David, no its not redundant. If the preceding SZ_512K block is not
  compressible, then we would have already set the BTRFS_INODE_NOCOMPRESS
  flag, which then we would straightaway go up to the end.

> but we still might need to know if the compression is
> desired.
  Uh ?

> The check does no depend on anything inside the loop, so it should be
> moved out of it. 

  No, it should not be, if you move check outside then it will act as if
  compress-force is set even if you don't set it.

> If I understand the logic correctly, we get to
> cow_file_range_async and always want to compress, so the test should be
> dropped entirely.

  sorry. its wrong. as above.


