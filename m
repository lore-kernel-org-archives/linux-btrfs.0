Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756210AbaDICRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 22:17:00 -0400
Message-ID: <5344ADD8.5070301@cn.fujitsu.com>
Date: Wed, 9 Apr 2014 10:18:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix the return value of btrfs_scan_kernel()
References: <1396948562-16653-1-git-send-email-quwenruo@cn.fujitsu.com> <5344ABEB.20906@oracle.com>
In-Reply-To: <5344ABEB.20906@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nope, the fix can also deal with no search parameter.

If any btrfs filesystem can be found and printed, found will be set to 1 
which considered as found,
then 0 will be returned.

Thanks,
Qu
于 2014年04月09日 10:09, Anand Jain 写道:
>
>  I expect btrfs_scan_kernel()  would go away in the long run,
>  however below fix has a problem - when there is no search item
>  you would return fail (1) always. Since btrfs_scan_kernel() has
>  limited usage as you mention as well. So I will leave it to David
>  to decide.
>
> Thanks, Anand
>
> On 08/04/2014 17:16, Qu Wenruo wrote:
>> btrfs_scan_kernel() is only used in 'btrfs fi show' but returns wrong
>> return value.
>> When search parameter is passed, it will never return 0 even the search
>> can be matched.
>>
>> This patch will change the whatever strange logic to a more easy to
>> understand one using 'found' var.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Cc: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-filesystem.c | 9 +++------
>>   1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index b81768b..49d3aa7 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -430,6 +430,7 @@ static int btrfs_scan_kernel_v2(void *search)
>>   static int btrfs_scan_kernel(void *search)
>>   {
>>       int ret = 0, fd;
>> +    int found = 0;
>>       FILE *f;
>>       struct mntent *mnt;
>>       struct btrfs_ioctl_fs_info_args fs_info_arg;
>> @@ -452,7 +453,6 @@ static int btrfs_scan_kernel(void *search)
>>
>>           if (get_label_mounted(mnt->mnt_dir, label)) {
>>               kfree(dev_info_arg);
>> -            ret = 1;
>>               goto out;
>>           }
>>           if (search && !match_search_item_kernel(fs_info_arg.fsid,
>> @@ -467,19 +467,16 @@ static int btrfs_scan_kernel(void *search)
>>                       space_info_arg, label, mnt->mnt_dir);
>>               kfree(space_info_arg);
>>               memset(label, 0, sizeof(label));
>> +            found = 1;
>>           }
>>           if (fd != -1)
>>               close(fd);
>>           kfree(dev_info_arg);
>> -        if (search)
>> -            ret = 0;
>>       }
>> -    if (search)
>> -        ret = 1;
>>
>>   out:
>>       endmntent(f);
>> -    return ret;
>> +    return !found;
>>   }
>>
>>   static int dev_to_fsid(char *dev, __u8 *fsid)
>>

