Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41163 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3GNIdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 04:33:31 -0400
Message-ID: <51E26245.1040003@oracle.com>
Date: Sun, 14 Jul 2013 16:33:09 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz
CC: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix memory leak in open_file_or_dir()
References: <1373410908-2274-1-git-send-email-wangshilong1991@gmail.com> <51DCD854.8050401@oracle.com>
In-Reply-To: <51DCD854.8050401@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  I am sorry that this has missed my eyes.
  There is a regression in this patch and most
  the commands are failing.

---
# btrfs fi df /btrfs
ERROR: couldn't get space info on '/btrfs' - Bad file descriptor
---

 >> +    if (fd < 0)
 >> +        fd = -3;
 >> +    if (dirstream)
 >> +        closedir(dirstream);

   We have to closedir only when fd < 0.


Thanks, Anand


On 10/07/2013 11:43, Anand Jain wrote:
>
>   Thanks.
>
>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
>
>
> On 07/10/2013 07:01 AM, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> After calling opendir() successfully, closedir() should be
>> also called to free memory. Otherwise, memory leak happens.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   utils.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/utils.c b/utils.c
>> index 7b4cd74..0afff55 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1480,7 +1480,7 @@ int open_file_or_dir(const char *fname)
>>   {
>>       int ret;
>>       struct stat st;
>> -    DIR *dirstream;
>> +    DIR *dirstream = NULL;
>>       int fd;
>>
>>       ret = stat(fname, &st);
>> @@ -1496,9 +1496,10 @@ int open_file_or_dir(const char *fname)
>>       } else {
>>           fd = open(fname, O_RDWR);
>>       }
>> -    if (fd < 0) {
>> -        return -3;
>> -    }
>> +    if (fd < 0)
>> +        fd = -3;
>> +    if (dirstream)
>> +        closedir(dirstream);
>>       return fd;
>>   }
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
