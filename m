Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27255 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960AbaKYDEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 22:04:25 -0500
Message-ID: <5473F1B2.8010201@cn.fujitsu.com>
Date: Tue, 25 Nov 2014 11:04:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <clm@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141124205825.GX32735@carfax.org.uk>
In-Reply-To: <20141124205825.GX32735@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>
Date: 2014年11月25日 04:58
> On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
>> On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>> This brings a strong-but-slow checksum algorithm, sha256.
>>>
>>> Actually btrfs used sha256 at the early time, but then moved to
>>> crc32c for
>>> performance purposes.
>>>
>>> As crc32c is sort of weak due to its hash collision issue, we need
>>> a stronger
>>> algorithm as an alternative.
>>>
>>> Users can choose sha256 from mkfs.btrfs via
>>>
>>> $ mkfs.btrfs -C 256 /device
>> Agree with others about -C 256...-C sha256 is only three letters more ;)
>>
>> What's the target for this mode?  Are we trying to find evil people
>> scribbling on the drive, or are we trying to find bad hardware?
>     You're going to need a hell of a lot more infrastructure to deal
> with the first of those two cases. If someone can write arbitrary data
> to your storage without going through the filesystem, you've already
> lost the game.
>
>     I don't know what the stats are like for random error detection
> (probably just what you'd expect in the naive case -- 1/2^n chance of
> failing to detect an error for an n-bit hash). More bits likely are
> better for that, but how much CPU time do you want to burn on it?
Agree with this, sha256's extra CPU usage seems not so worthy.

About the csum algorithm, personally I prefer algorithm with better 
error detection,
not only the integration about the whole data, but the range where the 
error lies in.

If btrfs can know, for example which 4K or 2K block the error lies in, 
it can drops only the range of data,
not the whole tree block, which can do great help for later btrfsck things.

In this point of view, 4 crc32 for 16K leaf/node (1 crc32 for 4K) may be 
more productive than single sha256.

Thanks,
Qu
>
>     I could see this possibly being useful for having fewer false
> positives when using the inbuilt checksums for purposes of dedup.
>
>     Hugo.

