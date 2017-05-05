Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42947 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751441AbdEEAzT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 20:55:19 -0400
Subject: Re: btrfsck lowmem mode shows corruptions
To: Kai Krakow <hurikhan77@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <20170504192936.5820aa76@jupiter.sol.kaishome.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <37157561-b48c-bde2-cf8f-c15e8fbf38d3@cn.fujitsu.com>
Date: Fri, 5 May 2017 08:55:10 +0800
MIME-Version: 1.0
In-Reply-To: <20170504192936.5820aa76@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/05/2017 01:29 AM, Kai Krakow wrote:
> Hello!
> 
> Since I saw a few kernel freezes lately (due to experimenting with
> ck-sources) including some filesystem-related backtraces, I booted my
> rescue system to check my btrfs filesystem.
> 
> Luckily, it showed no problems. It said, everything's fine. But I also
> thought: Okay, let's try lowmem mode. And that showed a frightening
> long list of extent corruptions und unreferenced chunks. Should I worry?

Thanks for trying lowmem mode.

Would you please provide the version of btrfs-progs?

IIRC "ERROR: data extent[96316809216 2097152] backref lost" bug has been 
fixed in recent release.

And for reference, would you please provide the tree dump of your chunk 
and device tree?

This can be done by running:
# btrfs-debug-tree -t device <device>
# btrfs-debug-tree -t chunk <device>

And this 2 dump only contains the btrfs chunk mapping info, so nothing 
sensitive is contained.

Thanks,
Qu
> 
> PS: The freezes seem to be related to bfq, switching to deadline solved
> these.
> 
> Full log attached, here's an excerpt:
> 
> ---8<---
> 
> checking extents
> ERROR: chunk[256 4324327424) stripe 0 did not find the related dev extent
> ERROR: chunk[256 4324327424) stripe 1 did not find the related dev extent
> ERROR: chunk[256 4324327424) stripe 2 did not find the related dev extent
> ERROR: chunk[256 7545552896) stripe 0 did not find the related dev extent
> ERROR: chunk[256 7545552896) stripe 1 did not find the related dev extent
> ERROR: chunk[256 7545552896) stripe 2 did not find the related dev extent
> [...]
> ERROR: device extent[1, 1094713344, 1073741824] did not find the related chunk
> ERROR: device extent[1, 2168455168, 1073741824] did not find the related chunk
> ERROR: device extent[1, 3242196992, 1073741824] did not find the related chunk
> [...]
> ERROR: device extent[2, 608854605824, 1073741824] did not find the related chunk
> ERROR: device extent[2, 609928347648, 1073741824] did not find the related chunk
> ERROR: device extent[2, 611002089472, 1073741824] did not find the related chunk
> [...]
> ERROR: device extent[3, 64433946624, 1073741824] did not find the related chunk
> ERROR: device extent[3, 65507688448, 1073741824] did not find the related chunk
> ERROR: device extent[3, 66581430272, 1073741824] did not find the related chunk
> [...]
> ERROR: data extent[96316809216 2097152] backref lost
> ERROR: data extent[96316809216 2097152] backref lost
> ERROR: data extent[96316809216 2097152] backref lost
> ERROR: data extent[686074396672 13737984] backref lost
> ERROR: data extent[686074396672 13737984] backref lost
> ERROR: data extent[686074396672 13737984] backref lost
> [...]
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> ERROR: errors found in fs roots
> Checking filesystem on /dev/disk/by-label/system
> UUID: bc201ce5-8f2b-4263-995a-6641e89d4c88
> found 1960075935744 bytes used, error(s) found
> total csum bytes: 1673537040
> total tree bytes: 4899094528
> total fs tree bytes: 2793914368
> total extent tree bytes: 190398464
> btree space waste bytes: 871743708
> file data blocks allocated: 6907169177600
>   referenced 1979268648960
> 


