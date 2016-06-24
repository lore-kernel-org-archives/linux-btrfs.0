Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43096 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbcFXD0K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 23:26:10 -0400
Subject: Re: btrfs-progs 4.6 won't build on CentOS6
To: Eric Sandeen <sandeen@redhat.com>, Steven Haigh <netwiz@crc.id.au>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
 <d08ce5a1-d74f-40be-54ae-4cadb56fd391@redhat.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fbd1fa3e-6ac6-2c25-a4b0-5d87ac544c9b@cn.fujitsu.com>
Date: Fri, 24 Jun 2016 11:26:03 +0800
MIME-Version: 1.0
In-Reply-To: <d08ce5a1-d74f-40be-54ae-4cadb56fd391@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/24/2016 11:22 AM, Eric Sandeen wrote:
> On 6/23/16 8:49 PM, Steven Haigh wrote:
>> I've tried to build the new tools for CentOS 6 / Scientific Linux 6 / RHEL 6 etc.
>>
>> During the build process, I see:
>> cmds-fi-du.c: In function 'du_calc_file_space':
>> cmds-fi-du.c:330: error: 'FIEMAP_EXTENT_SHARED' undeclared (first use in this function)
>> cmds-fi-du.c:330: error: (Each undeclared identifier is reported only once
>> cmds-fi-du.c:330: error: for each function it appears in.)
>> make: *** [cmds-fi-du.o] Error 1
>>
>> I'm guessing this is probably due to a different GCC version used? I'm guessing this is a simple fix for someone with knowhow... :)
>
> Fair warning, the btrfs.ko in centos6 is positively ancient, and it
> won't be updated.
>
> Just in case that matters to you ... not sure if you just want to
> build there, or use actually btrfs under a centos6 kernel....
>
> -Eric

This is the new function introduced to calculate shared extents size for 
files/dirs.

Which uses EXTENT_SHARED flag for ioctl, which is not included in old 
kernels.

I have already informed the author several weeks ago, and the fix is 
quite easy.

But it seems that author didn't send out the fix though.

Thanks,
Qu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


