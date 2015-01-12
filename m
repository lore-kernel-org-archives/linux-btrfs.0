Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19297 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbbALE4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 23:56:16 -0500
Message-ID: <54B353EE.6090605@cn.fujitsu.com>
Date: Mon, 12 Jan 2015 12:56:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: What about storing more crc32 in the unused csum size for metadata?
References: <54B3323E.3090100@cn.fujitsu.com> <pan$8d162$d4e83036$79c5caa1$f18c808@cox.net>
In-Reply-To: <pan$8d162$d4e83036$79c5caa1$f18c808@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: What about storing more crc32 in the unused csum size for 
metadata?
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月12日 12:52
> Qu Wenruo posted on Mon, 12 Jan 2015 10:32:30 +0800 as excerpted:
>
>> [New layout]
>> Take leafsize as 4K for example.
>>
>> Sectors:
>> |---0---|---1---|---2---|---3---|---4---|---5---|---6---|---7---|
>> Sector 0: Csum of the leaf/node (32~4K)(not changed)
>> Sector 1: Csum of the first eighths of the leaf/node (32~512)
>> Sector 2: Csum of the second eighths of the leaf/node (512~1024)
>> ....
>> Sector 7: Csum of the last eighths of the leaf/node (3584 ~ 4096)
> OK, I've been up too long and should be sleeping, and it may be that's
> affecting my logic, but AFAICT either you're missing something obvious,
> or I am.
>
> There are eight eights, and eight "sectors", but the first one is already
> used, thus leaving seven available.  You have the first eighth (ending at
> byte 512*1) in sector one (zero-based so the second sector), the second
> (ending at byte 512*2=1024) in sector two... the last (eighth) eighth
> (ending at byte 512*8=4096) in sector seven.
>
> Of eighths 3-7 in that ..., which eighth do you skip csumming, or is one
> of them a full quarter instead of an eighth?
Oh, my fault, sector 1 should contains csum for the second eighth of the 
leaf/node...
Since the first eighth csum can be calculated  vice verse.

Thanks,
Qu
>
> Of course if we could make them sevenths...  But making it four quarters
> instead of 7/8 is perhaps more reasonable, with the remaining three
> sectors remaining unused, and if only one fails csum we still save 75% of
> the leaf/node, instead of none of it, currently.
>
> But maybe it makes complete sense as-is and I should be sleeping instead
> of trying to make sense of what is clearly not making sense to me at this
> point...
>

