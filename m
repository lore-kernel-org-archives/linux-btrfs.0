Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46675 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab3ENGbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 02:31:39 -0400
Message-ID: <5191DA8D.9060209@cn.fujitsu.com>
Date: Tue, 14 May 2013 14:32:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz> <20130507004106.5844.39433@localhost.localdomain> <20130507115449.GE16456@twin.jikos.cz>
In-Reply-To: <20130507115449.GE16456@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	tue, 7 May 2013 13:54:49 +0200, David Sterba wrote:
> On Mon, May 06, 2013 at 08:41:06PM -0400, Chris Mason wrote:
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 988b860..4de2351 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -1690,15 +1690,19 @@ static int cleaner_kthread(void *arg)
>>>         struct btrfs_root *root = arg;
>>>  
>>>         do {
>>> +               int again = 0;
>>> +
>>>                 if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
>>> +                   down_read_trylock(&root->fs_info->sb->s_umount) &&
>>>                     mutex_trylock(&root->fs_info->cleaner_mutex)) {
>>>                         btrfs_run_delayed_iputs(root);
>>> -                       btrfs_clean_old_snapshots(root);
>>> +                       again = btrfs_clean_one_deleted_snapshot(root);
>>>                         mutex_unlock(&root->fs_info->cleaner_mutex);
>>>                         btrfs_run_defrag_inodes(root->fs_info);
>>> +                       up_read(&root->fs_info->sb->s_umount);
>>
>> Can we use just the cleaner mutex for this?  We're deadlocking during
>> 068 with autodefrag on because the cleaner is holding s_umount while
>> autodefrag is trying to bump the writer count.
> 
> I have now reproduced the deadlock and see where it's stuck.  It did not
> happen with running 068 in a loop, but after interrupting the test.
> 
>> If unmount takes the cleaner mutex once it should wait long enough for
>> the cleaner to stop.
> 
> You mean removing s_umount from here completely? I'm not sure about
> other mis-interaction, eg with remount + autodefrag. Miao sent a patch
> for that case http://www.spinics.net/lists/linux-btrfs/msg16634.html
> (but it would not fix this deadlock).

I have given up this patch and fix this problem by the other way.
http://marc.info/?l=linux-btrfs&m=136142833013628&w=2

I think we need use s_umount here, all things we need do is to check R/O
in cleaner_mutex. Or we may continue to delete the dead tree after the fs
is remounted to be R/O.

Thanks
Miao

> 
> I'm for keeping the clean-by-one patch for 3.10, we can fix other
> regressions during rc cycle.
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

