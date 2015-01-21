Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23834 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbbAUBFx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 20:05:53 -0500
Date: Tue, 20 Jan 2015 20:05:29 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>
Message-ID: <1421802329.27917.8@mail.thefacebook.com>
In-Reply-To: <54BEF99D.7090104@cn.fujitsu.com>
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150120171344.GH13289@twin.jikos.cz> <54BEF99D.7090104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Jan 20, 2015 at 7:58 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on 
> frozen fs to avoid deadlock.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年01月21日 01:13
>> On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
>>> --- a/fs/btrfs/super.c
>>> +++ b/fs/btrfs/super.c
>>> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, 
>>> int wait)
>>>   			 */
>>>   			if (fs_info->pending_changes == 0)
>>>   				return 0;
>>> +			/*
>>> +			 * Test if the fs is frozen, or start_trasaction
>>> +			 * will deadlock on itself.
>>> +			 */
>>> +			if (__sb_start_write(sb, SB_FREEZE_FS, false))
>>> +				__sb_end_write(sb, SB_FREEZE_FS);
>>> +			else
>>> +				return 0;

But what if someone freezes the FS after __sb_end_write() and before 
btrfs_start_transaction()?   I don't see what keeps new freezers from 
coming in.

-chris


