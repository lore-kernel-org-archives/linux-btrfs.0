Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754781AbbLDBWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 20:22:21 -0500
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
To: <dsterba@suse.cz>, Vegard Nossum <vegard.nossum@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz> <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com> <565CEEF1.80006@cn.fujitsu.com>
 <20151203174714.GD31035@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5660EAB7.1020702@cn.fujitsu.com>
Date: Fri, 4 Dec 2015 09:21:59 +0800
MIME-Version: 1.0
In-Reply-To: <20151203174714.GD31035@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/12/03 18:47 +0100:
> On Tue, Dec 01, 2015 at 08:50:57AM +0800, Qu Wenruo wrote:
>> Btrfsck already gives quite good clue on the problem:
>>
>> ERROR: chunk_root block unaligned: 4294967168
>> ERROR: chunk_root block unaligned: 4294967168
>>
>> Chunk root in superblock is not aligned, and the superblock is not valid.
>>
>> It would be better to copy all these btrfs-progs enhancement to kernel.
>
> We do have the alignment check in kernel, but it's in the early phase
> where we don't know if nodesize is reliable and print only a warning.
>
>
This can be enhanced by the following method:

1) Check sectorsize first
    Only several sector size is valid for current btrfs:
    4K, 8K, 16K, 32K, 64K
    Just five numbers, quite easy to check.
    Or if anyone is going to extend supported sectorsize, we can change
    the check to if the number is power of 2 starting from 4K.

2) Check nodesize/leafsize then
    It should be aligned to sectorsize.
    And nodesize must match with leafsize.
    Currently, it's done out of check_super_valid(), we can integrate it.

3) Check all super root bytenr against *sectorsize*
    Yeah, not nodesize.
    As some old bad convert will cause metadata extent unaligned to
    nodesize(just before my convert rework patch), but only aligned to
    sectorsize.
    So only check alignment of sectorsize.

If you are OK with this idea, I can make the patch soon.

Thanks,
Qu




