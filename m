Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60753 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaE1OK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 10:10:58 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so17592858qgd.23
        for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 07:10:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5385EB18.6020402@redhat.com>
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<5385EB18.6020402@redhat.com>
Date: Wed, 28 May 2014 22:10:57 +0800
Message-ID: <CAP9B-Q=w_ffAA3z0447Aoc4YSc1SJUEi5RDUtX1v5wyEm7TD7Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] Btrfs-progs: fsck: only allow partial opening under
 repair mode
From: Shilong Wang <wangshilong1991@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-05-28 21:56 GMT+08:00 Eric Sandeen <sandeen@redhat.com>:
> The subject and the comment say what this change does, but
> that's obvious from reading the code.  Nothing says *why*
> the change has been made.  What does this fix, and how does
> it fix it?

Yup, the reason that we allow partial opening is that sometimes,
we may have a corrupted extent tree(for example), but for fsck repair case,
the broken tree maybe rebuilt.

So if users only want to do check but not repaired, this patch will make fsck
return failure as soon as possible and tell users that some critial roots have
been corrupted...

Let's come to your comments, Eric, you are absolutely right, i was a little
lazy sometimes...

I would add necessay changelog to describe why we need this patch,
thanks for your comments.

Regards,
Wang
>
> Can you add/update the commit log so that some reader in the future
> (or for that matter, a reviewer in the present) will have an idea
> about the reason for this change?  What was the failure case, what
> was the failure mode, why does this change fix it, etc.
>
> Thanks,
> -Eric
>
> On 5/28/14, 6:20 AM, Wang Shilong wrote:
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>  cmds-check.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index db7df80..0e4e042 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -6810,8 +6810,7 @@ int cmd_check(int argc, char **argv)
>>       int option_index = 0;
>>       int init_csum_tree = 0;
>>       int qgroup_report = 0;
>> -     enum btrfs_open_ctree_flags ctree_flags =
>> -             OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
>> +     enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
>>
>>       while(1) {
>>               int c;
>> @@ -6877,6 +6876,10 @@ int cmd_check(int argc, char **argv)
>>               goto err_out;
>>       }
>>
>> +     /* only allow partial opening under repair mode */
>> +     if (repair)
>> +             ctree_flags |= OPEN_CTREE_PARTIAL;
>> +
>>       info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
>>       if (!info) {
>>               fprintf(stderr, "Couldn't open file system\n");
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
