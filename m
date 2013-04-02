Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:53775 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab3DBM0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 08:26:55 -0400
Received: by mail-da0-f46.google.com with SMTP id y19so172114dan.19
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 05:26:55 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V2 1/6] Btrfs: introduce a mutex lock for btrfs quota operations
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <515ACCE4.5030800@jan-o-sch.net>
Date: Tue, 2 Apr 2013 20:26:48 +0800
Cc: linux-btrfs@vger.kernel.org, sensille@gmx.net, miaox@cn.fujitsu.com,
        wangsl-fnst@cn.fujitsu.com
Message-Id: <643EF4D0-4269-4F1B-A642-8FECE7D3F37E@gmail.com>
References: <1364468024-1636-1-git-send-email-wangshilong1991@gmail.com> <515ACCE4.5030800@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Jan,

> Hi Wang,
> 
> On Thu, March 28, 2013 at 11:53 (+0100), Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> 
>> This patch introduces mutex lock 'quota_lock', and makes
>> all the user change for quota protected by quota_lock.
> 
> Can you please add a few lines why this lock is needed? I.e., which ioctls fail
> without that kind of synchronization?

I have explained it clearly in [PATCH V2 0/6].
http://marc.info/?l=linux-btrfs&m=136446806332680&w=2

> 
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> fs/btrfs/ctree.h   |    3 +++
>> fs/btrfs/disk-io.c |    1 +
>> fs/btrfs/ioctl.c   |   16 ++++++++++++----
>> 3 files changed, 16 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 6e81860..a11a8ed 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1584,6 +1584,9 @@ struct btrfs_fs_info {
>> 	struct rb_root qgroup_tree;
>> 	spinlock_t qgroup_lock;
>> 
>> +	/* protect user change operations for quota */
>> +	struct mutex quota_lock;
> 
> Having fs_info->qgroup_lock and fs_info->quota_lock going to be a major source
> of confusion. I'd call the new one qgroup_ioctl_lock or ioctl_qgroup_lock instead.

It is reasonable, but i will move the mutex lock to group.c to avoid serialize 
operations.


> 
> Furthermore, the term "quota" was intentionally left unused to leave room for
> other quota implementations later (user quota).
> 
> And, please, use --thread with git send-email for related patches to get correct
> headers.

Thanks for correcting me~.

Thanks,
Wang
> 
> Thanks,
> -Jan
> 
>> [snip]

