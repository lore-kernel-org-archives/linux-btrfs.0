Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34401 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756577AbcH2IZP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:25:15 -0400
Subject: Re: does btrfs-receive use/compare the checksums from the btrfs-send
 side?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1472355960.16760.9.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <640da4f0-4854-5135-aacc-350bfa99c6ed@cn.fujitsu.com>
Date: Mon, 29 Aug 2016 16:25:10 +0800
MIME-Version: 1.0
In-Reply-To: <1472355960.16760.9.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/28/2016 11:46 AM, Christoph Anton Mitterer wrote:
> Hey.
>
> I've often wondered:
> When I do a send/receive, does the receiving side use the checksums
> from the sending side (either by directly storing them or by comparing
> them with calculated checksums and failing if they don't match after
> the transfer)?

Send will generate checksum for each command.

https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive#Overal_strucutre

(Finally the new page is useful now)

Although the checksum is not the same way for btrfs.
For btrfs, data checksum is CRC32 per sectorsize(4K for x86_64), and 
CRC32 for the whole tree block.

For send stream, it's CRC32 for the whole command.

Thanks,
Qu

>
> Cause that would effectively secure any transport in between against
> transmission errors ... and also against badblocks/etc. on the
> receiving fs.
>
> If btrfs is already that smart, then I think this feature should be
> mentioned in the send/receive manpages.
>
> Cheers,
> Chris.
>


