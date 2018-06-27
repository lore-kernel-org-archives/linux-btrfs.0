Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934391AbeF0Ppc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 11:45:32 -0400
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com [209.85.217.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB6522442
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 15:45:32 +0000 (UTC)
Received: by mail-ua0-f169.google.com with SMTP id j17-v6so1557899uap.7
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 08:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7aed7d16-ec6b-ec08-e5da-63e6bb2dede8@suse.com>
References: <20180626234315.15643-1-fdmanana@kernel.org> <7aed7d16-ec6b-ec08-e5da-63e6bb2dede8@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 27 Jun 2018 16:45:30 +0100
Message-ID: <CAL3q7H7jJJv1f1h0UEhFh_suSKVDqcXOaiJgY=p9BqEy8gvmHQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix mount failure when qgroup rescan is in progress
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 4:44 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 27.06.2018 02:43, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> If a power failure happens while the qgroup rescan kthread is running,
>> the next mount operation will always fail. This is because of a recent
>> regression that makes qgroup_rescan_init() incorrectly return -EINVAL
>> when we are mounting the filesystem (through btrfs_read_qgroup_config()).
>> This causes the -EINVAL error to be returned regardless of any qgroup
>> flags being set instead of returning the error only when neither of
>> the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
>> are set.
>>
>> A test case for fstests follows up soon.
>>
>> Fixes: 9593bf49675e ("btrfs: qgroup: show more meaningful qgroup_rescan_init error message")
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 1874a6d2e6f5..d4171de93087 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2784,13 +2784,20 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>>
>>       if (!init_flags) {
>>               /* we're resuming qgroup rescan at mount time */
>> -             if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
>> +             if (!(fs_info->qgroup_flags &
>> +                   BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
>>                       btrfs_warn(fs_info,
>>                       "qgroup rescan init failed, qgroup is not enabled");
>> -             else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
>> +                     ret = -EINVAL;
>> +             } else if (!(fs_info->qgroup_flags &
>> +                          BTRFS_QGROUP_STATUS_FLAG_ON)) {
>>                       btrfs_warn(fs_info,
>>                       "qgroup rescan init failed, qgroup rescan is not queued");
>> -             return -EINVAL;
>> +                     ret = -EINVAL;
>> +             }
>> +
>> +             if (ret)
>> +                     return ret;
>
>
> How is this patch functionally different than the old code. In both
> cases if either of those 2 is not set a warn is printed and -EINVAL is
> returned?

It is explained in the changelog:

"This is because of a recent
regression that makes qgroup_rescan_init() incorrectly return -EINVAL
when we are mounting the filesystem (through btrfs_read_qgroup_config()).
This causes the -EINVAL error to be returned regardless of any qgroup
flags being set instead of returning the error only when neither of
the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
are set."

If you can't understand it, try the test case...


>
>>       }
>>
>>       mutex_lock(&fs_info->qgroup_rescan_lock);
>>
