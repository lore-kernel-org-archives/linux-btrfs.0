Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbeHPFAo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 01:00:44 -0400
Subject: Re: [PATCH 1/2] btrfs: assert for num_devices below 0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180810055321.19730-1-anand.jain@oracle.com>
 <20180810055321.19730-3-anand.jain@oracle.com>
 <20180815121142.GK24025@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f85c779c-a6be-a0ea-c2f8-4f1d942eafb3@oracle.com>
Date: Thu, 16 Aug 2018 10:09:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180815121142.GK24025@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/15/2018 08:11 PM, David Sterba wrote:
> On Fri, Aug 10, 2018 at 01:53:20PM +0800, Anand Jain wrote:
>> In preparation to add helper function to deduce the num_devices with
>> replace running, use assert instead of bug_on and warn_on.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index b6d9b6a6fba7..0062615a79be 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1877,7 +1877,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>>   	num_devices = fs_devices->num_devices;
>>   	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>   	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> -		WARN_ON(num_devices < 1);
>> +		ASSERT(num_devices > 0);
>>   		num_devices--;
> 
> I was about to merge the patch but this gave me another opportunity to
> look at the code: the assertion should check for > 1. The value 1 of
> num_devices is sligthly wrong here and would lead to 0 returned from the
> function.

  Agree its slightly wrong but I kept it as it is to match with the
  original code. I mentioned about it in the cover letter.

Thanks, Anand
