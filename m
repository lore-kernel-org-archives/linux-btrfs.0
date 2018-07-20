Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51657 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbeGTHQR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 03:16:17 -0400
Subject: Re: [PATCH] btrfs: fix bug of chunk type check
To: Nikolay Borisov <nborisov@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
 <08fc876b-f9d7-dc11-5126-e35976402caf@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c571a602-9294-93ba-4390-f8cd0823d943@gmx.com>
Date: Fri, 20 Jul 2018 14:29:20 +0800
MIME-Version: 1.0
In-Reply-To: <08fc876b-f9d7-dc11-5126-e35976402caf@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月20日 14:14, Nikolay Borisov wrote:
> 
> 
> On 20.07.2018 08:17, Gu Jinxiang wrote:
>> chunk type BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA
>> should not be set in a non-mixed chunk at the same time.
>>
>> Since BTRFS_BLOCK_GROUP_METADATA is 0x4 and BTRFS_BLOCK_GROUP_DATA is 0x1,
>> BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA will be 0x0,
>> so we should judge type is one of them separately.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

However an extra nitpick.

> 
>> ---
>>  fs/btrfs/volumes.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 3f2f01ad9356..c7d009e45472 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6384,8 +6384,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
>>  		mixed = 1;
>>  
>>  	if (!mixed) {
>> -		if (type &
>> -		    (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
>> +		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
>> +			(type & BTRFS_BLOCK_GROUP_DATA)) {

IIRC previous (and failed) fix was checking type & (METADATA | DATA),
which valid METADATA or DATA will also trigger it.

When handling two bits we indeed need extra attention, either type &
(METADATA | DATA) == (METADATA | DATA) or your method.

Thanks,
Qu

>>  			btrfs_err(fs_info,
>>  			"mixed chunk type in non-mixed mode: %llu", type);

For bit flags, 0x%llx would be better in my opinion, just as the block
group item tree-checker did.

Thanks,
Qu

>>  			return -EIO;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
