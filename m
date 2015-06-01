Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38395 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbbFAHtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 03:49:04 -0400
Received: by igbjd9 with SMTP id jd9so55042228igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 00:49:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <556BB4A0.5050305@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1425025599-30048-7-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H7yZyUXAsK41e1ZAwVsV3WB8_XNJR_sQ4p8UZLfEM5hDA@mail.gmail.com>
	<556BB4A0.5050305@cn.fujitsu.com>
Date: Mon, 1 Jun 2015 08:49:04 +0100
Message-ID: <CAL3q7H54r2-0tQ8QtZDxqXt_0Hq2H_S7J2j7Oaqd4LRPe59jHg@mail.gmail.com>
Subject: Re: [PATCH 6/7] btrfs-progs: Print warning message if qgroup data is inconsistent.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 1, 2015 at 2:25 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> -------- Original Message  --------
> Subject: Re: [PATCH 6/7] btrfs-progs: Print warning message if qgroup data
> is inconsistent.
> From: Filipe David Manana <fdmanana@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年05月30日 19:39
>
>> On Fri, Feb 27, 2015 at 8:26 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> Before this patch, qgroup show won't check btrfs qgroup status, so even
>>> the INCONSISTENT flags is set, user is not aware of it.
>>>
>>> This patch will include BTRFS_QGROUP_STATUS_ITEM in the search range and
>>> check the flag, if there is any flag meaning the inconsistence of qgroup
>>> data, info user.
>>>
>>> NOTE: There is several kernel bugs from INCONSISTENT flags is always set
>>> to RUNNING flags is not cleared until umount.
>>> So this warning will always be here if using a newer kernel fixing these
>>> bugs.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>   qgroup.c | 26 ++++++++++++++++++++++++--
>>>   1 file changed, 24 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/qgroup.c b/qgroup.c
>>> index 7288365..4173846 100644
>>> --- a/qgroup.c
>>> +++ b/qgroup.c
>>> @@ -1016,6 +1016,20 @@ static void __filter_and_sort_qgroups(struct
>>> qgroup_lookup *all_qgroups,
>>>                  n = rb_prev(n);
>>>          }
>>>   }
>>> +
>>> +static inline void print_status_flag_warning(u64 flags)
>>> +{
>>> +       if (!(flags & BTRFS_QGROUP_STATUS_FLAG_ON))
>>> +               fprintf(stderr,
>>> +               "WARNING: Quota disabled, qgroup data may be out of
>>> date\n");
>>> +       else if (flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
>>> +               fprintf(stderr,
>>> +               "WARNING: Rescan is running, qgroup data may be
>>> incorrect\n");
>>
>>
>> Hi Qu, did you ran xfstests? Did btrfs/022 passed for you?
>>
>> btrfs/022 47s ... - output mismatch (see
>> /home/fdmanana/git/hub/xfstests/results//btrfs/022.out.bad)
>>      --- tests/btrfs/022.out 2014-11-17 20:59:51.178203000 +0000
>>      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/022.out.bad
>> 2015-05-30 12:35:55.917146846 +0100
>>      @@ -1,2 +1,3 @@
>>       QA output created by 022
>>      +WARNING: Rescan is running, qgroup data may be incorrect
>>       Silence is golden
>>      ...
>>      (Run 'diff -u tests/btrfs/022.out
>> /home/fdmanana/git/hub/xfstests/results//btrfs/022.out.bad'  to see
>> the entire diff)
>>
>> thanks
>
> Unfortunately, it's quite hard to trigger in my environment.
> I tried about 15 times, and can only trigger it once.
>
> Any hint about mount options or other things to improve the reproducibility?

No mount options at all (nor mkfs -O features). Happens all the time here.

Thanks for looking into it.

>
> Thanks,
> Qu
>
>>
>>
>>> +       else if (flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)
>>> +               fprintf(stderr,
>>> +               "WARNING: Qgroup data inconsistent, rescan
>>> recommended\n");
>>> +}
>>> +
>>>   static int __qgroups_search(int fd, struct qgroup_lookup
>>> *qgroup_lookup)
>>>   {
>>>          int ret;
>>> @@ -1039,7 +1053,7 @@ static int __qgroups_search(int fd, struct
>>> qgroup_lookup *qgroup_lookup)
>>>
>>>          sk->tree_id = BTRFS_QUOTA_TREE_OBJECTID;
>>>          sk->max_type = BTRFS_QGROUP_RELATION_KEY;
>>> -       sk->min_type = BTRFS_QGROUP_INFO_KEY;
>>> +       sk->min_type = BTRFS_QGROUP_STATUS_KEY;
>>>          sk->max_objectid = (u64)-1;
>>>          sk->max_offset = (u64)-1;
>>>          sk->max_transid = (u64)-1;
>>> @@ -1070,7 +1084,15 @@ static int __qgroups_search(int fd, struct
>>> qgroup_lookup *qgroup_lookup)
>>>                                                                    off);
>>>                          off += sizeof(*sh);
>>>
>>> -                       if (sh->type == BTRFS_QGROUP_INFO_KEY) {
>>> +                       if (sh->type == BTRFS_QGROUP_STATUS_KEY) {
>>> +                               struct btrfs_qgroup_status_item *si;
>>> +                               u64 flags;
>>> +
>>> +                               si = (struct btrfs_qgroup_status_item *)
>>> +                                    (args.buf + off);
>>> +                               flags =
>>> btrfs_stack_qgroup_status_flags(si);
>>> +                               print_status_flag_warning(flags);
>>> +                       } else if (sh->type == BTRFS_QGROUP_INFO_KEY) {
>>>                                  info = (struct btrfs_qgroup_info_item *)
>>>                                         (args.buf + off);
>>>                                  a1 =
>>> btrfs_stack_qgroup_info_generation(info);
>>> --
>>> 2.3.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
