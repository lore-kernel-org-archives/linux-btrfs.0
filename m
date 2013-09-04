Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761764Ab3IDBnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 21:43:04 -0400
Message-ID: <52268FAA.30304@cn.fujitsu.com>
Date: Wed, 04 Sep 2013 09:40:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <esandeen@redhat.com>
CC: Eric Sandeen <sandeen@redhat.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: tidy up cmd_subvol_create() whitespace &
 returns
References: <1378213291-1034-1-git-send-email-wangshilong1991@gmail.com> <0A5B4F8C-8B08-4976-A660-6396407E932D@gmail.com> <52260537.6090103@redhat.com> <52268AE3.4020107@cn.fujitsu.com> <84DB8BCE-E584-4D16-8A0D-7FBD235874CD@redhat.com>
In-Reply-To: <84DB8BCE-E584-4D16-8A0D-7FBD235874CD@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/04/2013 09:24 AM, Eric Sandeen wrote:
> MOn Sep 3, 2013, at 8:22 PM, Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
>
>> On 09/03/2013 11:50 PM, Eric Sandeen wrote:
>>> On 9/3/13 8:13 AM, Wang Shilong wrote:
>>>> Hello Eric,
>>>>
>>>> Recently, i notice btrfs-progs's magic return value. For example, EACCESS return 12.
>>>> Magic return value is confusing for code reviewers. However,at least we should guarantee
>>>> all these conditions return the same value(for example 12 for this case)
>>>>
>>>> Or we can change all the magic number to 1. Miao reminded me that
>>>> there may be some applications that have catched and checked these
>>>> magic return values…
>>>>
>>>> Any ideas about this?
>>> I think that if we want to do anything different from the standard, expected
>>> "return 1 and set errno" then it needs to be a careful design decision, documented,
>>> used consistently, and tested.
>> I'd prefer to use standard approach.There are still many magic return
>> values unfixed.If
>> there are no objections, i would do like to correct the magic return
>> value following the rule:
>>
>> 0 No errors
>> 1 Usage or syntax error
>>
>> Exceptions come from btrfs scrub/fsck,getting such operations' status
>> etc.It is meaningful to
>> differ these return values.
>>
> Fsck in particular has some semi-standard, documented return values I think
See it, thanks for reminding^_^

Thanks,
Wang
>
> Eric
>
>> Thanks,
>> Wang
>>> As far as I can tell, what is in btrfs-progs today is undocumented,
>>> untested, and only occasionally/randomly used.  Therefore I don't
>>> think it's useful as it stands today, and why I had started removing
>>> them.
>>>
>>> -Eric
>>>
>>>> Thanks,
>>>> Wang
>>>>> From:
>>>>> Just whitespace fixes, and magical return value removal.
>>>>>
>>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>>> ---
>>>>> cmds-subvolume.c | 18 +++++++++---------
>>>>> 1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>>>>> index 01b982c..a9999ac 100644
>>>>> --- a/cmds-subvolume.c
>>>>> +++ b/cmds-subvolume.c
>>>>> @@ -104,9 +104,9 @@ static int cmd_subvol_create(int argc, char **argv)
>>>>>     dst = argv[optind];
>>>>>
>>>>>     res = test_isdir(dst);
>>>>> -    if(res >= 0 ){
>>>>> +    if (res >= 0) {
>>>>>         fprintf(stderr, "ERROR: '%s' exists\n", dst);
>>>>> -        return 12;
>>>>> +        return 1;
>>>>>     }
>>>>>
>>>>>     newname = strdup(dst);
>>>>> @@ -114,24 +114,24 @@ static int cmd_subvol_create(int argc, char **argv)
>>>>>     dstdir = strdup(dst);
>>>>>     dstdir = dirname(dstdir);
>>>>>
>>>>> -    if( !strcmp(newname,".") || !strcmp(newname,"..") ||
>>>>> +    if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
>>>>>          strchr(newname, '/') ){
>>>>>         fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
>>>>>             newname);
>>>>> -        return 14;
>>>>> +        return 1;
>>>>>     }
>>>>>
>>>>>     len = strlen(newname);
>>>>>     if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
>>>>>         fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
>>>>>             newname);
>>>>> -        return 14;
>>>>> +        return 1;
>>>>>     }
>>>>>
>>>>>     fddst = open_file_or_dir(dstdir);
>>>>>     if (fddst < 0) {
>>>>>         fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
>>>>> -        return 12;
>>>>> +        return 1;
>>>>>     }
>>>>>
>>>>>     printf("Create subvolume '%s/%s'\n", dstdir, newname);
>>>>> @@ -159,10 +159,10 @@ static int cmd_subvol_create(int argc, char **argv)
>>>>>     close(fddst);
>>>>>     free(inherit);
>>>>>
>>>>> -    if(res < 0 ){
>>>>> -        fprintf( stderr, "ERROR: cannot create subvolume - %s\n",
>>>>> +    if (res < 0) {
>>>>> +        fprintf(stderr, "ERROR: cannot create subvolume - %s\n",
>>>>>             strerror(e));
>>>>> -        return 11;
>>>>> +        return 1;
>>>>>     }
>>>>>
>>>>>     return 0;
>>>>> -- 
>>>>> 1.7.11.7
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

