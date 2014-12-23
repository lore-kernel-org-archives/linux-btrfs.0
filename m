Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750963AbaLWF1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 00:27:53 -0500
Message-ID: <5498FD52.6050807@cn.fujitsu.com>
Date: Tue, 23 Dec 2014 13:27:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: How btrfs-find-root knows that the block is actually a root?
References: <CAOcd+r2_CkP7wiU3OETxhdVtkTpZYiz0GxSx7BDEsFU6H+0_RQ@mail.gmail.com>
In-Reply-To: <CAOcd+r2_CkP7wiU3OETxhdVtkTpZYiz0GxSx7BDEsFU6H+0_RQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: How btrfs-find-root knows that the block is actually a root?
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年12月22日 22:57
> Greetings,
>
> I am looking at the code of search_iobuf() in
> btrfs-find-root.c.(3.17.3)  I see that we probe nodesize blocks one by
> one, and for each block we check:
> - its owner is what we are looking for
> - its header->bytenr is what we are looking at currently
> - its level is not too small
> - it has valid checksum
> - it has the desired generation
>
> If all those conditions are true, we declare this block as a root and
> end the program.
>
> How do we actually know that it's a root and not a leaf or an
> intermediate node? What if we are searching for a root of the root
> tree, which has one node and two leafs (all have the same highest
> transid), and one of the leafs has "logical" lower than the actual
> root, i.e., it comes first in our scan. Then we will declare this leaf
> as a root, won't we? Or somehow the root always has the lowest
> "logical"?
You can refer to this patch:
https://patchwork.kernel.org/patch/5285521/

Your questions are mostly right.
The best method should be search through all the metadata, and only the 
highest level header for
a given generation may be the root for that generation.

But that method still has some problems.
1) Overwritten old node/leaf
As btrfs metadata cow happens, old node/leaf may be overwritten and 
become incompletely,
so above method won't always work as expected.

2) Corrupted fs
That will makes everything not work as expected.
But sadly, when someone needs to use btrfs-find-root, there is a high 
possibility the fs is already corrupted.

3) Slow speed
It needs to scan over all the sectors of metadata chunks, it may var 
from megabytese to tegabytes,
which makes the complete scan impractical.
So current find-root uses a trade-off, if find a header at the position 
superblock points to, and generation
matches, then just consider it as the desired root and exit.

>
> Also, I am confused by this line:
> level = h_level;
> This means that if we encounter a block that "seems good", we will
> skip all other blocks that have lower level. Is this intended?
This is intended, for case user already know the root's level, so it 
will skip any header whose level is below it.

Thanks,
Qu
>
> Thanks,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

