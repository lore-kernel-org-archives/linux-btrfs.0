Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43680 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967723AbeCALtu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 06:49:50 -0500
Subject: Re: [PATCH v3] btrfs: verify max_inline mount parameter
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180215164338.GC10193@twin.jikos.cz>
 <20180226024704.15567-1-anand.jain@oracle.com>
 <20180227154538.GB27791@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f744e050-f05d-623d-eaa5-4d5079af19a5@oracle.com>
Date: Thu, 1 Mar 2018 19:51:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180227154538.GB27791@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/27/2018 11:45 PM, David Sterba wrote:
> On Mon, Feb 26, 2018 at 10:47:04AM +0800, Anand Jain wrote:
>> We aren't verifying the parameter passed to the max_inline mount option.
>> So we won't fail the mount if a junk value is specified, for example,
>> -o max_inline=abc. This patch checks if input is valid.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2->v3: Handle parameter with unit, such as 4K. Use memparse() 2nd arg.
>> v1->v2: use match_int ret value if error
>>          use %u instead of %d for parser
>>
>>   fs/btrfs/super.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 77e0537e1db5..76b58da8d56d 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -605,7 +605,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>>   		case Opt_max_inline:
>>   			num = match_strdup(&args[0]);
>>   			if (num) {
>> -				info->max_inline = memparse(num, NULL);
>> +				char *retptr;
>> +
>> +				info->max_inline = memparse(num, &retptr);
> 
> I missed it in the patch that changed max_inline to u32, memparse
> returns unsigned long long, so this is not entrely correct and requires
> a temporary variable.
> 
> We should also report if the user-specified value is larger than
> BTRFS_MAX_METADATA_BLOCKSIZE .

(Got diverted into something else. Sorry for the delay.)

Currently -o max_line can be only upto sectorsize.

We have MAX_INLINE_EXTENT_BUFFER_SIZE which is 64K and is equal to 
BTRFS_MAX_METADATA_BLOCKSIZE (also 64K)

I didn't get the point that max_inline is limited by sector size in the 
current design. Any idea?

Thanks, Anand

-------
#define BTRFS_MAX_METADATA_BLOCKSIZE 65536
#define INLINE_EXTENT_BUFFER_PAGES 16
#define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES * 
PAGE_SIZE)
---------
static struct extent_buffer *
__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
                       unsigned long len)
{
::
    /*
    * Sanity checks, currently the maximum is 64k covered by 16x 4k pages
    */
         BUILD_BUG_ON(BTRFS_MAX_METADATA_BLOCKSIZE
                 > MAX_INLINE_EXTENT_BUFFER_SIZE);
         BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
-----
int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
                         unsigned long new_flags)
{
::
                                 if (info->max_inline) {
                                         info->max_inline = min_t(u64,
                                                 info->max_inline,
                                                 info->sectorsize);
                                 }
-----



> This is not a trivial fix the existing patches so I'll remove "btrfs:
> declare max_inline as u32".
> 
> To sum it up:
> 
> 1. add check and return EINVAL with a message if max_inline is larger
>     than the metadata block size
> 2. switch max_inline to u32 and add a temporary value to read from
>     memparse
> 3. add change from this patch that catches the junk
> 
>> +				if (*retptr != '\0') {
>> +					ret = -EINVAL;
>> +					kfree(num);
> 
> The kfree can be moved before the check, we don't need 'num'.
> 
>> +					goto out;
>> +				}
>>   				kfree(num);
>>   
>>   				if (info->max_inline) {
>> -- 
>> 2.15.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
