Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbeCTWbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 18:31:00 -0400
Subject: Re: [PATCH 3/3] btrfs: refactor btrfs_check_super_csum() for scan
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-4-anand.jain@oracle.com>
 <dd091687-5779-7200-d165-c8f6acf2935c@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c29c2ca3-b514-1235-70b1-e28084b3f893@oracle.com>
Date: Wed, 21 Mar 2018 06:32:47 +0800
MIME-Version: 1.0
In-Reply-To: <dd091687-5779-7200-d165-c8f6acf2935c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/20/2018 07:10 PM, Nikolay Borisov wrote:
> 
> 
> On 20.03.2018 11:53, Anand Jain wrote:
>> In preparation to use the function btrfs_check_super_csum() for
>> the device scan context, make it nonstatic and pass the
>> struct block_device instead of the struct fs_info.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/disk-io.c | 12 ++++++------
>>   fs/btrfs/disk-io.h |  1 +
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index aafd836af61d..d2ace2dca9de 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -393,8 +393,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>>    * Return 0 if the superblock checksum type matches the checksum value of that
>>    * algorithm. Pass the raw disk superblock data.
>>    */
>> -static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>> -				  char *raw_disk_sb)
>> +int btrfs_check_super_csum(struct block_device *bdev, char *raw_disk_sb)
>>   {
> 
> Since this has become a public function and you've changed the fs_info
> parameter to taking a bdev, which is not used for anything else than
> printing the error I think it's appropriate to document which block
> device should be passed to this function.
> 
> Also passing the block device only for printing purposes seems a bit odd.

  Its the device on which we have read the superblock. I find it
  odd too. Will do that pr_err on the parent function. Will add
  comments to the public function.


Thanks, Anand

