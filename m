Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbbLDNOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Dec 2015 08:14:21 -0500
Date: Fri, 4 Dec 2015 14:12:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Message-ID: <20151204131229.GG31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz>
 <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com>
 <565CEEF1.80006@cn.fujitsu.com>
 <20151203174714.GD31035@suse.cz>
 <5660EAB7.1020702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5660EAB7.1020702@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 09:21:59AM +0800, Qu Wenruo wrote:
> > We do have the alignment check in kernel, but it's in the early phase
> > where we don't know if nodesize is reliable and print only a warning.
> >
> This can be enhanced by the following method:

At minimum, we can promote the 4k alignment checks in
btrfs_check_super_valid from a warning to an error. The blocks must be
4k aligned, regardless of sectorsize or nodesize.

> 1) Check sectorsize first
>     Only several sector size is valid for current btrfs:
>     4K, 8K, 16K, 32K, 64K
>     Just five numbers, quite easy to check.

The sectorsize must be PAGE_SIZE at the moment. This will change with
Chandan's patchset though.

>     Or if anyone is going to extend supported sectorsize, we can change
>     the check to if the number is power of 2 starting from 4K.
> 
> 2) Check nodesize/leafsize then
>     It should be aligned to sectorsize.

This particular check is missing but is implicit because of the
sectorsize == PAGE_SIZE restriction.

>     And nodesize must match with leafsize.
>     Currently, it's done out of check_super_valid(), we can integrate it.

Yeah it's done, then I don't see why we should add it agian.

> 3) Check all super root bytenr against *sectorsize*
>     Yeah, not nodesize.
>     As some old bad convert will cause metadata extent unaligned to
>     nodesize(just before my convert rework patch), but only aligned to
>     sectorsize.
>     So only check alignment of sectorsize.

While the real check should be against the sectorsize, at the moment I
think it's covered by the 4k checks anyway. I understand why we can't
use the nodesize.

So, if we do the warning -> error, we're fine for now. Some of the
checks you suggest would be good to merge when the subpage blocksize
patchset is merged.
