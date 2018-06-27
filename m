Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753079AbeF0QF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 12:05:29 -0400
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com [209.85.217.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE56225C28
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 16:05:28 +0000 (UTC)
Received: by mail-ua0-f169.google.com with SMTP id r10-v6so1613608uao.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 09:05:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9206aad9-1b4b-5dbe-18e9-e7b9d0f22a80@suse.com>
References: <20180626234315.15643-1-fdmanana@kernel.org> <7aed7d16-ec6b-ec08-e5da-63e6bb2dede8@suse.com>
 <CAL3q7H7jJJv1f1h0UEhFh_suSKVDqcXOaiJgY=p9BqEy8gvmHQ@mail.gmail.com> <9206aad9-1b4b-5dbe-18e9-e7b9d0f22a80@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 27 Jun 2018 17:05:27 +0100
Message-ID: <CAL3q7H6u+FeGuUK=9kaNL2Ssha114NXSJ-3wWQ1mc0MKGqaMuQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix mount failure when qgroup rescan is in progress
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 4:55 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 27.06.2018 18:45, Filipe Manana wrote:
>> On Wed, Jun 27, 2018 at 4:44 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>
>>>
>>> On 27.06.2018 02:43, fdmanana@kernel.org wrote:
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>
>>>> If a power failure happens while the qgroup rescan kthread is running,
>>>> the next mount operation will always fail. This is because of a recent
>>>> regression that makes qgroup_rescan_init() incorrectly return -EINVAL
>>>> when we are mounting the filesystem (through btrfs_read_qgroup_config()).
>>>> This causes the -EINVAL error to be returned regardless of any qgroup
>>>> flags being set instead of returning the error only when neither of
>>>> the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
>>>> are set.
>>>>
>>>> A test case for fstests follows up soon.
>>>>
>>>> Fixes: 9593bf49675e ("btrfs: qgroup: show more meaningful qgroup_rescan_init error message")
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>> ---
>>>>  fs/btrfs/qgroup.c | 13 ++++++++++---
>>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index 1874a6d2e6f5..d4171de93087 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -2784,13 +2784,20 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>>>>
>>>>       if (!init_flags) {
>>>>               /* we're resuming qgroup rescan at mount time */
>>>> -             if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
>>>> +             if (!(fs_info->qgroup_flags &
>>>> +                   BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
>>>>                       btrfs_warn(fs_info,
>>>>                       "qgroup rescan init failed, qgroup is not enabled");
>>>> -             else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
>>>> +                     ret = -EINVAL;
>>>> +             } else if (!(fs_info->qgroup_flags &
>>>> +                          BTRFS_QGROUP_STATUS_FLAG_ON)) {
>>>>                       btrfs_warn(fs_info,
>>>>                       "qgroup rescan init failed, qgroup rescan is not queued");
>>>> -             return -EINVAL;
>>>> +                     ret = -EINVAL;
>>>> +             }
>>>> +
>>>> +             if (ret)
>>>> +                     return ret;
>>>
>>>
>>> How is this patch functionally different than the old code. In both
>>> cases if either of those 2 is not set a warn is printed and -EINVAL is
>>> returned?
>>
>> It is explained in the changelog:
>
> No need to be snide

No one's being snide. Simply, I can't see how the changelog doesn't
explain (what is already quite easy to notice from the code).

>
>>
>> "This is because of a recent
>> regression that makes qgroup_rescan_init() incorrectly return -EINVAL
>> when we are mounting the filesystem (through btrfs_read_qgroup_config()).
>> This causes the -EINVAL error to be returned regardless of any qgroup
>> flags being set instead of returning the error only when neither of
>> the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
>> are set."
>>
>> If you can't understand it, try the test case...
>
> Ok I see it now, however your description contradicts the code.
> Currently -EINVAL will be returned when either of the 2 flags is unset i.e
>
> !BTRFS_QGROUP_STATUS_FLAG_RESCAN && BTRFS_QGROUP_STATUS_FLAG_ON
> !BTRFS_QGROUP_STATUS_FLAG_ON && BTRFS_QGROUP_STATUS_FLAG_RESCAN
>
> and in your description you refer to neither that is the 2 flags being
> unset. Perhaps those combinations are invalid due to some other reasons
> which are not visible in the code but in this case the changelog should
> be expanded to cover why those 2 combinations are impossible (because if
> they are -EINVAL is still likely ) ?

I don't think the changelog is contradictory.
It says that -EINVAL is always returned, independently of which qgroup
flags are set/missing.
Further it says that the error should be returned only when one of
those 2 qgroup flags is not set (or both are not set).

>
>>
>>
>>>
>>>>       }
>>>>
>>>>       mutex_lock(&fs_info->qgroup_rescan_lock);
>>>>
>>
