Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4524 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbaGJBSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 21:18:22 -0400
Message-ID: <53BDE9D8.4070208@cn.fujitsu.com>
Date: Thu, 10 Jul 2014 09:18:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi df'
 command.
References: <1404798203-17122-1-git-send-email-quwenruo@cn.fujitsu.com> <53BDE153.4060002@jp.fujitsu.com> <53BDE57F.60707@cn.fujitsu.com>
In-Reply-To: <53BDE57F.60707@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi 
df' command.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, 
linux-btrfs@vger.kernel.org
Date: 2014年07月10日 08:59
>
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi 
> df' command.
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014年07月10日 08:41
>> Hi Qu,
>>
>> (2014/07/08 14:43), Qu Wenruo wrote:
>>> Add mount point output for 'btrfs fi df'.
>>> Also since the patch uses find_mount_root() to find mount point,
>>> now 'btrfs fi df' can output more meaningful error message when given a
>>> non-btrfs path.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> This patch needs to be merged after the following path:
>>> btrfs-progs: Check fstype in find_mount_root()
>>> ---
>>>    cmds-filesystem.c | 10 ++++++++++
>>>    1 file changed, 10 insertions(+)
>>>
>>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>>> index 4b2d27e..d571765 100644
>>> --- a/cmds-filesystem.c
>>> +++ b/cmds-filesystem.c
>>> @@ -187,12 +187,22 @@ static int cmd_filesystem_df(int argc, char 
>>> **argv)
>>>           int ret;
>>>           int fd;
>>>           char *path;
>>> +       char *mount_point = NULL;
>>>           DIR *dirstream = NULL;
>>>              if (check_argc_exact(argc, 2))
>>>                   usage(cmd_filesystem_df_usage);
>>>              path = argv[1];
>>> +       ret = find_mount_root(path, &mount_point);
>>> +       if (ret < 0) {
>>> +           if (ret != -ENOENT)
>> Is "if (ret != -ENOENT)" to avoid the error message duplication
>> with the following code?
> Yes.
>>
>> utils.c:
>> =============================================================================== 
>>
>> ...
>> int find_mount_root(...)
>> {
>>     ...
>>          if (!longest_match) {
>>                  fprintf(stderr,
>>                          "ERROR: Failed to find mount root for path 
>> %s.\n",
>>                          path);
>>                  return -ENOENT;
>>          }
>> ...
>> =============================================================================== 
>>
>>
>> I consider making the following two patches is the better way.
>>
>>   - Patch 1. Removing this error message from find_mount_root().
>>              This cause no problem since all the current 
>> find_mount_root()
>>              caller show their own error message.
>>                - Patch 2. Your patch with removing that if sentence.
> Thanks for the suggestion, it really makes sense.
> I'll send the new version with other small modification like integrate 
> realpath() into find_mount_root()
> since every caller of find_mount_root() does the realpath resolve.
>
> Thanks,
> Qu
P.S. I prefer to integrate all fprintf() into find_mount_root(), since 
that will make the error message more specific
and more easy to understandable.
So I'll remove the caller fprintf.
Would this be OK for you?

Thanks,
Qu
>>
>> Thanks,
>> Satoru
>>
>>> +               fprintf(stderr, "ERROR: Failed to find mount root 
>>> for path %s: %s\n",
>>> +                   path, strerror(-ret));
>>> +        return 1;
>>> +       }
>>> +       printf("Mounted on: %s\n", mount_point);
>>> +       free(mount_point);
>>>              fd = open_file_or_dir(path, &dirstream);
>>>           if (fd < 0) {
>>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

