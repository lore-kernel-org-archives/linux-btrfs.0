Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22278 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751633AbcAOBuT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 20:50:19 -0500
Subject: Re: [PATCH v5 0/2][PULL REQUEST] Unify 'norecovery' bahavior with
 other filesystems
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1452564313-22007-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160114160031.GB4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56985046.1030306@cn.fujitsu.com>
Date: Fri, 15 Jan 2016 09:49:58 +0800
MIME-Version: 1.0
In-Reply-To: <20160114160031.GB4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/01/14 17:00 +0100:
> On Tue, Jan 12, 2016 at 10:05:11AM +0800, Qu Wenruo wrote:
>> 'Norecovery' mount option is almost a standard for all other
>> filesystems, including f2fs, ext4, gfs2, nilfs2, and xfs.
>> And since current 'recovery' mount option for btrfs is too generic, it's
>> better to change btrfs 'recovery' to 'usebackuproot' and then we can
>> safely add 'norecovery' and 'nologreplay' mount option for btrfs.
>>
>> The patch itself is not huge and already tested by others since v2.
>> Only mount option name is changing during all these version changes.
>
> So we have some kind of consensus about the options, but I think you
> need to split the patches further.

It's never a bad idea to split patches :)

>
> * the new option 'nologreplay'
> * keep 'usebackuproot' as a new alias for 'recovery' (with the
>    deprecation warning)
> * new 'norecovery' that switches on 'nologreplay' and 'nousebackuproot'
>    (ie. the desired "no writes")
>
> There is a case in remount, when we start with 'ro,nologreplay' then
> remount with just 'ro', the log should be replayed. The other
> combinations should be easy. I haven't looked at the patch if it's
> implemented that way though.
>
>
For that case, even remount with -o remount,ro the nologreplay mount 
option won't be erased.
That's why we added a lot of "noXXXX" mount option, or we can't disable 
some feature by remount.

And since I didn't add such "logreplay" mount option intentionally, so 
there is no way to replay log unless umount the fs and mount it without 
"nologreplay" again.

I'll update the patchset soon and hopes it can catch the rc1 merge window.

Thanks,
Qu


