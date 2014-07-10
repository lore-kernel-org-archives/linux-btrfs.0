Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43193 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGJBWx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 21:22:53 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 1D5873EE0B6
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:22:52 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 24EC5AC0226
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:22:51 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 379A81DB8043
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 10:22:50 +0900 (JST)
Message-ID: <53BDEADD.6020707@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 10:22:37 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi df'
 command.
References: <1404798203-17122-1-git-send-email-quwenruo@cn.fujitsu.com> <53BDE153.4060002@jp.fujitsu.com> <53BDE57F.60707@cn.fujitsu.com> <53BDE9D8.4070208@cn.fujitsu.com>
In-Reply-To: <53BDE9D8.4070208@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/10 10:18), Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi df' command.
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014年07月10日 08:59
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi df' command.
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
>> Date: 2014年07月10日 08:41
>>> Hi Qu,
>>>
>>> (2014/07/08 14:43), Qu Wenruo wrote:
>>>> Add mount point output for 'btrfs fi df'.
>>>> Also since the patch uses find_mount_root() to find mount point,
>>>> now 'btrfs fi df' can output more meaningful error message when given a
>>>> non-btrfs path.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>> This patch needs to be merged after the following path:
>>>> btrfs-progs: Check fstype in find_mount_root()
>>>> ---
>>>>    cmds-filesystem.c | 10 ++++++++++
>>>>    1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>>>> index 4b2d27e..d571765 100644
>>>> --- a/cmds-filesystem.c
>>>> +++ b/cmds-filesystem.c
>>>> @@ -187,12 +187,22 @@ static int cmd_filesystem_df(int argc, char **argv)
>>>>           int ret;
>>>>           int fd;
>>>>           char *path;
>>>> +       char *mount_point = NULL;
>>>>           DIR *dirstream = NULL;
>>>>              if (check_argc_exact(argc, 2))
>>>>                   usage(cmd_filesystem_df_usage);
>>>>              path = argv[1];
>>>> +       ret = find_mount_root(path, &mount_point);
>>>> +       if (ret < 0) {
>>>> +           if (ret != -ENOENT)
>>> Is "if (ret != -ENOENT)" to avoid the error message duplication
>>> with the following code?
>> Yes.
>>>
>>> utils.c:
>>> ===============================================================================
>>> ...
>>> int find_mount_root(...)
>>> {
>>>     ...
>>>          if (!longest_match) {
>>>                  fprintf(stderr,
>>>                          "ERROR: Failed to find mount root for path %s.\n",
>>>                          path);
>>>                  return -ENOENT;
>>>          }
>>> ...
>>> ===============================================================================
>>>
>>> I consider making the following two patches is the better way.
>>>
>>>   - Patch 1. Removing this error message from find_mount_root().
>>>              This cause no problem since all the current find_mount_root()
>>>              caller show their own error message.
>>>                - Patch 2. Your patch with removing that if sentence.
>> Thanks for the suggestion, it really makes sense.
>> I'll send the new version with other small modification like integrate realpath() into find_mount_root()
>> since every caller of find_mount_root() does the realpath resolve.
>>
>> Thanks,
>> Qu
> P.S. I prefer to integrate all fprintf() into find_mount_root(), since that will make the error message more specific
> and more easy to understandable.
> So I'll remove the caller fprintf.
> Would this be OK for you?

It's OK for me.

Satoru

>
> Thanks,
> Qu
>>>
>>> Thanks,
>>> Satoru
>>>
>>>> +               fprintf(stderr, "ERROR: Failed to find mount root for path %s: %s\n",
>>>> +                   path, strerror(-ret));
>>>> +        return 1;
>>>> +       }
>>>> +       printf("Mounted on: %s\n", mount_point);
>>>> +       free(mount_point);
>>>>              fd = open_file_or_dir(path, &dirstream);
>>>>           if (fd < 0) {
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

