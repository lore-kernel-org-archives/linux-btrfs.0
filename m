Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62272 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbbAUBJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 20:09:48 -0500
Message-ID: <54BEFC56.3000403@cn.fujitsu.com>
Date: Wed, 21 Jan 2015 09:09:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>	<20150120171344.GH13289@twin.jikos.cz> <54BEF99D.7090104@cn.fujitsu.com> <1421802329.27917.8@mail.thefacebook.com>
In-Reply-To: <1421802329.27917.8@mail.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on 
frozen fs to avoid deadlock.
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月21日 09:05
>
>
> On Tue, Jan 20, 2015 at 7:58 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
> wrote:
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on 
>> frozen fs to avoid deadlock.
>> From: David Sterba <dsterba@suse.cz>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2015年01月21日 01:13
>>> On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
>>>> --- a/fs/btrfs/super.c
>>>> +++ b/fs/btrfs/super.c
>>>> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, 
>>>> int wait)
>>>>                */
>>>>               if (fs_info->pending_changes == 0)
>>>>                   return 0;
>>>> +            /*
>>>> +             * Test if the fs is frozen, or start_trasaction
>>>> +             * will deadlock on itself.
>>>> +             */
>>>> +            if (__sb_start_write(sb, SB_FREEZE_FS, false))
>>>> +                __sb_end_write(sb, SB_FREEZE_FS);
>>>> +            else
>>>> +                return 0;
>
> But what if someone freezes the FS after __sb_end_write() and before 
> btrfs_start_transaction()?   I don't see what keeps new freezers from 
> coming in.
>
> -chris
Either VFS::freeze_super() and VFS::syncfs() will hold the s_umount 
mutex, so freeze will not happen
during sync.

Thanks,
Qu
>
>

