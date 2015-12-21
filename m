Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64889 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbbLUC0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 21:26:09 -0500
Subject: Re: Ideas to do custom operation just after mount?
To: Dave Chinner <david@fromorbit.com>
References: <56721602.5050204@cn.fujitsu.com> <20151221001654.GM19802@dastard>
CC: <fstests@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56776330.1090500@cn.fujitsu.com>
Date: Mon, 21 Dec 2015 10:25:52 +0800
MIME-Version: 1.0
In-Reply-To: <20151221001654.GM19802@dastard>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave Chinner wrote on 2015/12/21 11:16 +1100:
> On Thu, Dec 17, 2015 at 09:55:14AM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> Will xfstests provides some API to do some operation just after
>> mounting a filesystem?
>>
>> Some filesystem(OK, btrfs again) has some function(now qgroup only)
>> which needed to be enabled by ioctl instead of mount option.
>
> Irk.
>
> Seriously, I need ot find some time to split all the fs specific
> stuff in common/rc into separate files and have each different
> filesystem implement it's own version of the relevant functions
> like _scratch_mkfs, _scratch_mount, etc.
>
> That will enable btrfs to do truly hideous stuff like this that
> admins will hate you for requiring, and the rest of us won't have to
> care about it.
>
>> So is there any good idea to do some operation just after mounting
>> in xfstests?
>
> You're just going to have to wait a bit - the first piece of this
> is in the overlayfs support patches, and the rest of it is in my
> local work area in an incomplete state.

Glad to hear that, I'll just wait for the formal implement.

Thanks,
Qu

>
> Cheers,
>
> Dave.
>


