Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19338 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbbAUA60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 19:58:26 -0500
Message-ID: <54BEF99D.7090104@cn.fujitsu.com>
Date: Wed, 21 Jan 2015 08:58:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>,
        <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com> <20150120171344.GH13289@twin.jikos.cz>
In-Reply-To: <20150120171344.GH13289@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on 
frozen fs to avoid deadlock.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月21日 01:13
> On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>>   			 */
>>   			if (fs_info->pending_changes == 0)
>>   				return 0;
>> +			/*
>> +			 * Test if the fs is frozen, or start_trasaction
>> +			 * will deadlock on itself.
>> +			 */
>> +			if (__sb_start_write(sb, SB_FREEZE_FS, false))
>> +				__sb_end_write(sb, SB_FREEZE_FS);
>> +			else
>> +				return 0;
> The more I look into that the more I think that the first fix is the
> right one.
>
> Has been pointed out in this thread, it is ok to skip processing the
> pending changes if the filesystem is frozen.
That's good, for me, either this patch or the patch 2~5 in the patchset 
will solve the sync_fs() problem
on frozen fs. Just different timing to start the new transaction.

But the patchset one has the problem, which needs to deal with the sysfs 
interface changes, or sync_fs()
will still cause deadlock.
So I tried to revert the sysfs related patches, but it seems overkilled, 
needing extra btrfs_start_transaction*
things.

As you already picked this one, I'm completely OK with this.
>
> The pending changes have to flushed from sync (by design), we cannot use
> mnt_want_write or the sb_start* protections that.
>
> The btrfs_freeze callback can safely do the last commit, that's under
> s_umount held by vfs::freeze_super. Then any other new transaction would
> block. Any other call to btrfs_sync_fs will not find any active
> transaction and with this patch will not start one. Sounds safe to me.
>
> I think the right level to check is SB_FREEZE_WRITE though, to stop any
> potential writes as soon as possible and when the s_umount lock is still
> held in vfs::freeze_super.
SB_FREEZE_WRITE seems good for me.
But I didn't catch the difference between 
SB_FREEZE_FS(WRITE/PAGEFAULT/COMPLETE),
since freeze() conflicts with sync_fs(), when we comes to btrfs_sync_fs(),
the fs is either totally frozen or unfrozen and frozen level won't 
change during the protection of s_umount.

Although SB_FREEZE_WRITE seems better in its meaning and makes it more 
readable.
>
> I'll collect the relevant patches and will send it for review.
Thanks for collecting them and sending them out.

Thanks,
Qu
>
>
>>   			trans = btrfs_start_transaction(root, 0);
>>   		} else {
>>   			return PTR_ERR(trans);

