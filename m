Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34838 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3BVQjY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 11:39:24 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so946041ieb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 08:39:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51277409.6040007@gmx.net>
References: <1361534990-2627-1-git-send-email-wangshilong1991@gmail.com>
	<51277409.6040007@gmx.net>
Date: Sat, 23 Feb 2013 00:39:24 +0800
Message-ID: <CAP9B-Q=UW7=P7RuvwGFMmU7AaE0nQ0R5CKq+MW379+Wvx7oS_A@mail.gmail.com>
Subject: Re: [RESEND RFC PATCH 2/2] Btrfs: disable the qgroup level 0 for
 userspace use
From: Shilong Wang <wangshilong1991@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

2013/2/22 Arne Jansen <sensille@gmx.net>:
> On 02/22/13 13:09, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>
>> This patch tries to stop users to create/destroy qgroup level 0,
>> users can only create/destroy qgroup level more than 0.
>>
>> See the fact:
>>       a subvolume/snapshot qgroup was created automatically
>> when creating subvolume/snapshot, so creating a qgroup level 0 can't
>> be a subvolume/snapshot qgroup, the only way to use it is that assigning
>> subvolume/snapshot qgroup to it, the point is that we don't want to have a
>> parent qgroup whose level is 0.
>>
>>       So we want to force users to use qgroup with clear relations
>> which means a parent qgroup's level > child qgroup's level.For example:
>>
>>                           2/0
>>                          /    \
>>                         /      \
>>                        /        \
>>                       1/0       1/1
>>                     /     \        \
>>                    /       \        \
>>                   /         \        \
>>               0/256     0/257    0/258
>>
>> This pattern of quota is nature and easy for users to understand, otherwise it will
>> make the quota configuration confusing and difficult to maintain.
>
> I agree that a strict hierarchy of the levels should be enforced.
> Currently the kernel has no idea of 'level', it's just an artificial
> concept that lives in userspace. This patch would be the first place
> to add that magic shift '48' to the kernel.
> In my opinion it would be sufficient to do the enforcement in user
> space, as it is of no technical nature.
>

...i have made some patches about these work in btrfs-prog, but it has
been not merged...
I will pick up thoses patches and do the other necessary work..

Thanks,
Wang

> -Arne
>
>>
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Acked-by: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Arne Jansen <sensille@gmx.net>
>> ---
>>  fs/btrfs/ioctl.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index a31cd93..3590c21 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3755,7 +3755,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>>               goto drop_write;
>>       }
>>
>> -     if (!sa->qgroupid) {
>> +     if (!(sa->qgroupid >> 48)) {
>>               ret = -EINVAL;
>>               goto out;
>>       }
>>
>
