Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52360 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab3DOFoh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 01:44:37 -0400
Message-ID: <516B93C3.4080306@jan-o-sch.net>
Date: Mon, 15 Apr 2013 07:44:35 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net> <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net> <20130410164741.GS18193@twin.jikos.cz>
In-Reply-To: <20130410164741.GS18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, April 10, 2013 at 18:47 (+0200), David Sterba wrote:
> On Fri, Apr 05, 2013 at 01:38:16PM +0200, Jan Schmidt wrote:
>> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> 
> I was wondering if merging qgroup_flags with fs_state would make sense
> to you. There are currently 3 bits for qgroups, and it's a whole
> filesystem state anyway.

Well, yes, it can be done. I don't think it saves enough to justify the effort,
but feel free if you like. It's definitely not the purpose of this patch set :-)

> 
>> +	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
>> +		 fs_info->qgroup_rescan_progress.objectid,
>> +		 fs_info->qgroup_rescan_progress.type,
>> +		 fs_info->qgroup_rescan_progress.offset, ret);
> 
> Please use (unsigned long long) for u64 types (objectid, offset).
> 
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -376,12 +376,17 @@ struct btrfs_ioctl_get_dev_stats {
>>  
>>  #define BTRFS_QUOTA_CTL_ENABLE	1
>>  #define BTRFS_QUOTA_CTL_DISABLE	2
>> -#define BTRFS_QUOTA_CTL_RESCAN	3
>> +/* 3 has formerly been reserved for BTRFS_QUOTA_CTL_RESCAN */
> 
> It's not clear if 3 can be reused or not. If yes, there's no need for
> the comment, if not, a #define should be left in place to capture the
> value.

It shouldn't. I just wanted to

1) make sure there are no users left and

2) point out to the next rescan code editor that this is not the flag he should
be looking for.

My new approach to satisfy both goals now is to leave the #define in there and
add __UNUSED to the end of the name.

>>  struct btrfs_ioctl_quota_ctl_args {
>>  	__u64 cmd;
>>  	__u64 status;
>>  };
>>  
>> +struct btrfs_ioctl_quota_rescan_args {
>> +	__u64	flags;
>> +	__u64   progress;
> 
> Like I'm always worried about future etensions, adding a few reserved[]
> does not hurt.

Thanks, v2 to come.
-Jan
