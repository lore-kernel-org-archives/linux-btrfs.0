Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaE1PKQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 11:10:16 -0400
Message-ID: <5385FC4D.30301@redhat.com>
Date: Wed, 28 May 2014 10:10:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] Btrfs-progs: fsck: only allow partial opening under
 repair mode
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>	<5385EB18.6020402@redhat.com> <CAP9B-Q=w_ffAA3z0447Aoc4YSc1SJUEi5RDUtX1v5wyEm7TD7Q@mail.gmail.com>
In-Reply-To: <CAP9B-Q=w_ffAA3z0447Aoc4YSc1SJUEi5RDUtX1v5wyEm7TD7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/28/14, 9:10 AM, Shilong Wang wrote:
> 2014-05-28 21:56 GMT+08:00 Eric Sandeen <sandeen@redhat.com>:
>> The subject and the comment say what this change does, but
>> that's obvious from reading the code.  Nothing says *why*
>> the change has been made.  What does this fix, and how does
>> it fix it?
> 
> Yup, the reason that we allow partial opening is that sometimes,
> we may have a corrupted extent tree(for example), but for fsck repair case,
> the broken tree maybe rebuilt.
> 
> So if users only want to do check but not repaired, this patch will make fsck
> return failure as soon as possible and tell users that some critial roots have
> been corrupted...
> 
> Let's come to your comments, Eric, you are absolutely right, i was a little
> lazy sometimes...

Sometimes I am too.  ;)

> I would add necessay changelog to describe why we need this patch,
> thanks for your comments.

thanks.  Perhaps it's obvious to people more familiar with the code, but
I think it's always helpful to be a bit more descriptive; things that make
perfect sense right now can sometimes be confusing a year or so later.

Thanks,
-Eric

> Regards,
> Wang
>>
>> Can you add/update the commit log so that some reader in the future
>> (or for that matter, a reviewer in the present) will have an idea
>> about the reason for this change?  What was the failure case, what
>> was the failure mode, why does this change fix it, etc.
>>
>> Thanks,
>> -Eric
>>
>> On 5/28/14, 6:20 AM, Wang Shilong wrote:
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>>  cmds-check.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index db7df80..0e4e042 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -6810,8 +6810,7 @@ int cmd_check(int argc, char **argv)
>>>       int option_index = 0;
>>>       int init_csum_tree = 0;
>>>       int qgroup_report = 0;
>>> -     enum btrfs_open_ctree_flags ctree_flags =
>>> -             OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
>>> +     enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
>>>
>>>       while(1) {
>>>               int c;
>>> @@ -6877,6 +6876,10 @@ int cmd_check(int argc, char **argv)
>>>               goto err_out;
>>>       }
>>>
>>> +     /* only allow partial opening under repair mode */
>>> +     if (repair)
>>> +             ctree_flags |= OPEN_CTREE_PARTIAL;
>>> +
>>>       info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
>>>       if (!info) {
>>>               fprintf(stderr, "Couldn't open file system\n");
>>>
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

