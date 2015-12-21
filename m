Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13445 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbbLUCjC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 21:39:02 -0500
Subject: Re: Ideas to do custom operation just after mount?
To: Dave Chinner <david@fromorbit.com>
References: <56721602.5050204@cn.fujitsu.com> <20151221001654.GM19802@dastard>
 <56776330.1090500@cn.fujitsu.com>
CC: <fstests@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5677662F.2060806@cn.fujitsu.com>
Date: Mon, 21 Dec 2015 10:38:39 +0800
MIME-Version: 1.0
In-Reply-To: <56776330.1090500@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/12/21 10:25 +0800:
>
>
> Dave Chinner wrote on 2015/12/21 11:16 +1100:
>> On Thu, Dec 17, 2015 at 09:55:14AM +0800, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Will xfstests provides some API to do some operation just after
>>> mounting a filesystem?
>>>
>>> Some filesystem(OK, btrfs again) has some function(now qgroup only)
>>> which needed to be enabled by ioctl instead of mount option.
>>
>> Irk.
>>
>> Seriously, I need ot find some time to split all the fs specific
>> stuff in common/rc into separate files and have each different
>> filesystem implement it's own version of the relevant functions
>> like _scratch_mkfs, _scratch_mount, etc.
>>
>> That will enable btrfs to do truly hideous stuff like this that
>> admins will hate you for requiring, and the rest of us won't have to
>> care about it.

BTW, any good idea for btrfs to do such operation like 
enabling/disabling some minor features? Especially when it can be set on 
individual file/dirs.

Features like incoming write time deduplication, is designed to be 
enabled/disabled for individual file/dirs, so it's not a quite good idea 
to use mount option to do it.

Although some feature, like btrfs quota(qgroup), should be implemented 
by mount option though.
I don't understand why qgroup is enabled/disabled by ioctl. :(

Thanks,
Qu

>>
>>> So is there any good idea to do some operation just after mounting
>>> in xfstests?
>>
>> You're just going to have to wait a bit - the first piece of this
>> is in the overlayfs support patches, and the rest of it is in my
>> local work area in an incomplete state.
>
> Glad to hear that, I'll just wait for the formal implement.
>
> Thanks,
> Qu
>
>>
>> Cheers,
>>
>> Dave.
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


