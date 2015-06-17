Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37154 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbbFQNY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:24:26 -0400
Received: by igbsb11 with SMTP id sb11so36658609igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 06:24:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H7ZLQWSMsSSDg_+p3o3ODxDM8xO+95zJ8cFp-nMzAShOQ@mail.gmail.com>
Date: Wed, 17 Jun 2015 14:24:25 +0100
Message-ID: <CAL3q7H6+QrLFX3H-5jsccv1hvPFhsF4h-vYzdEJcWoefAEymAg@mail.gmail.com>
Subject: Re: [PATCH 5/7] btrfs: explictly delete unused block groups in
 close_ctree and ro-remount
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-5-git-send-email-jeffm@suse.com>
 <CAL3q7H7ZLQWSMsSSDg_+p3o3ODxDM8xO+95zJ8cFp-nMzAShOQ@mail.gmail.com>

On Wed, Jun 17, 2015 at 11:04 AM, Filipe David Manana
<fdmanana@gmail.com> wrote:
> On Mon, Jun 15, 2015 at 2:41 PM,  <jeffm@suse.com> wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> The cleaner thread may already be sleeping by the time we enter
>> close_ctree.  If that's the case, we'll skip removing any unused
>> block groups queued for removal, even during a normal umount.
>> They'll be cleaned up automatically at next mount, but users
>> expect a umount to be a clean synchronization point, especially
>> when used on thin-provisioned storage with -odiscard.  We also
>> explicitly remove unused block groups in the ro-remount path
>> for the same reason.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Tested-by: Filipe Manana <fdmanana@suse.com>
>
>> ---
>>  fs/btrfs/disk-io.c |  9 +++++++++
>>  fs/btrfs/super.c   | 11 +++++++++++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 2ef9a4b..2e47fef 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3710,6 +3710,15 @@ void close_ctree(struct btrfs_root *root)
>>         cancel_work_sync(&fs_info->async_reclaim_work);
>>
>>         if (!(fs_info->sb->s_flags & MS_RDONLY)) {
>> +               /*
>> +                * If the cleaner thread is stopped and there are
>> +                * block groups queued for removal, the deletion will be
>> +                * skipped when we quit the cleaner thread.
>> +                */
>> +               mutex_lock(&root->fs_info->cleaner_mutex);
>> +               btrfs_delete_unused_bgs(root->fs_info);
>> +               mutex_unlock(&root->fs_info->cleaner_mutex);
>> +
>>                 ret = btrfs_commit_super(root);
>>                 if (ret)
>>                         btrfs_err(fs_info, "commit super ret %d", ret);
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 9e66f5e..2ccd8d4 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1539,6 +1539,17 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>>
>>                 sb->s_flags |= MS_RDONLY;
>>
>> +               /*
>> +                * Setting MS_RDONLY will put the cleaner thread to
>> +                * sleep at the next loop if it's already active.
>> +                * If it's already asleep, we'll leave unused block
>> +                * groups on disk until we're mounted read-write again
>> +                * unless we clean them up here.
>> +                */
>> +               mutex_lock(&root->fs_info->cleaner_mutex);
>> +               btrfs_delete_unused_bgs(fs_info);
>> +               mutex_unlock(&root->fs_info->cleaner_mutex);

So actually, this allows for a deadlock after the patch I sent out last week:

https://patchwork.kernel.org/patch/6586811/

In that patch delete_unused_bgs is no longer called under the
cleaner_mutex, and making it so, will cause a deadlock with
relocation.

Even without that patch, I don't think you need using this mutex
anyway - no 2 tasks running this function can get the same bg from the
fs_info->unused_bgs list.

thanks


>> +
>>                 btrfs_dev_replace_suspend_for_unmount(fs_info);
>>                 btrfs_scrub_cancel(fs_info);
>>                 btrfs_pause_balance(fs_info);
>> --
>> 2.4.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
