Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42328 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752686AbcIEHpb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 03:45:31 -0400
Subject: Re: does btrfs-receive use/compare the checksums from the btrfs-send
 side?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1472355960.16760.9.camel@scientia.net>
 <640da4f0-4854-5135-aacc-350bfa99c6ed@cn.fujitsu.com>
 <1472963361.8683.14.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cc8972c4-6049-9102-fe4f-6dea13096b55@cn.fujitsu.com>
Date: Mon, 5 Sep 2016 15:45:19 +0800
MIME-Version: 1.0
In-Reply-To: <1472963361.8683.14.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/04/2016 12:29 PM, Christoph Anton Mitterer wrote:
> On Mon, 2016-08-29 at 16:25 +0800, Qu Wenruo wrote:
>> Send will generate checksum for each command.
> What does "command" mean here? Or better said how much data is secured
> with one CRC32?

Command is one send command stream, containing all needed info for a 
operation,
like subvolume command, containing UUID,tranid,
chown command, containing gid/uid,
chmod command, containing mode,
utimes command, containting acm times and a lot of others.

For how much data is secured by 1 CRC32, it depends on the size of the 
command.

Normal command is quite small, but the exception would be write command.
More than 48K bytes can be secured by one CRC32.

>
>
>> For send stream, it's CRC32 for the whole command.
> And this is verified then on the receiving end?

Yes.

>
>
> Wouldn't it be useful (if this technically possibly) to use the
> checksums directly from the sent blocks? That way one could also catch
> any errors on the receiving side, that occurred after the checksum from
> the receive was verified (e.g. memory errors).
>
> And couldn't one do something similar locally, when btrfs copies
> blocks?
>
> At least something like this would seem to me like the most native way:
> - One want's checksum protection
> - One copies data
> - One has already checksums for that data

You can try my dump-send command branch, to verify how send/receive works:
https://github.com/adam900710/btrfs-progs/tree/dump_send_stream

With several try, you could find at least the following reasons:

1) Not all data has checksum
    Only non-inlined data has checksum.
    Inlined data has no checksum (protected by leaf checksum then)

2) Send doesn't following sectorsize unit for non-inlined data
    Just create a 6K file, send the subvolume out, and use dump-send
    to exam it.
    You'll find that, send stream contains exactly 6K data, not 8K
    (2* 4K, which 4K is sectorsize).

    While for data checksum, that are all in sectorsize unit.

3) We need to protect the whole command, not file data only.
    Even write command contains metadata info, like the offset and length
    of the write.
    Since we need to protect the whole command, why not introduce the
    complexity to use TWO CRC32 for meta and data?

>
> => thus that should be used, as it's the most canonical version of a
>    checksum for that data... anything that is newly calculated could
>    in the best case just be good, and in the worst add new errors
>    (unnoticed),... e.g. when memory is broken and the new checksum is
>    calculated over that.

However most bugs are not caused by memory corruption, but humans.
So the command checksum design seems quite good for me though.
It's unified, simple structure and expandable.

Thanks,
Qu

>
>
> Cheers,
> Chris.
>


