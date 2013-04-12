Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab3DLBSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 21:18:32 -0400
Message-ID: <51676135.6050803@cn.fujitsu.com>
Date: Fri, 12 Apr 2013 09:19:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, mfasheh@suse.de
Subject: Re: [PATCH] Btrfs-progs: don't set INCOMPAT_EXTENDED_IREF flag when
 making a new fs
References: <51669069.50207@cn.fujitsu.com> <5166C87B.6040305@jan-o-sch.net>
In-Reply-To: <5166C87B.6040305@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Apr 2013 16:28:11 +0200, Jan Schmidt wrote:
> On Thu, April 11, 2013 at 12:28 (+0200), Miao Xie wrote:
>> There is no extended irefs in the new fs, and we can mount it on
>> the old kernel without extended iref function safely. So we needn't
>> set INCOMPAT_EXTENDED_IREF flag when making a new fs, and just set
>> it when we actually insert a extended iref.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> Cc: Mark Fasheh <mfasheh@suse.de>
>> ---
>>  mkfs.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/mkfs.c b/mkfs.c
>> index c8cb395..aca6e46 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -1654,8 +1654,6 @@ raid_groups:
>>  
>>  	super = root->fs_info->super_copy;
>>  	flags = btrfs_super_incompat_flags(super);
>> -	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
>> -
>>  	if (mixed)
>>  		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
>>  
>>
> 
> This one should have a large
> 
> *** do not apply until kernel patches from "[PATCH 0/2] do not open the extend
> *** inode reference at the beginning" have been merged.
> 
> tag. Otherwise, extended irefs are disabled entirely for all new file systems in
> environments where they have been working so far.

Yes, thanks to point it out.

Miao
