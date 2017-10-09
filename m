Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33248 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdJIRil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 13:38:41 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e1c0Z-0002Hi-S3
        for linux-btrfs@vger.kernel.org; Mon, 09 Oct 2017 19:38:27 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Why do full balance and deduplication reduce available free
 space?
Date: Mon, 9 Oct 2017 19:38:23 +0200
Message-ID: <20171009193823.75f774cc@jupiter.sol.kaishome.de>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
        <20171002213509.50a68609@jupiter.sol.kaishome.de>
        <498fe60d8c78ad7e882726214ce5b844@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 02 Oct 2017 22:19:32 +0200
schrieb Niccolò Belli <darkbasic@linuxsystems.it>:

> Il 2017-10-02 21:35 Kai Krakow ha scritto:
> > Besides defragging removing the reflinks, duperemove will unshare
> > your snapshots when used in this way: If it sees duplicate blocks
> > within the subvolumes you give it, it will potentially unshare
> > blocks from the snapshots while rewriting extents.
> > 
> > BTW, you should be able to use duperemove with read-only snapshots
> > if used in read-only-open mode. But I'd rather suggest to use bees
> > instead: It works at whole-volume level, walking extents instead of
> > files. That way it is much faster, doesn't reprocess already
> > deduplicated extents, and it works with read-only snapshots.
> > 
> > Until my patch it didn't like mixed nodatasum/datasum workloads.
> > Currently this is fixed by just leaving nocow data alone as users
> > probably set nocow for exactly the reason to not fragment extents
> > and relocate blocks.  
> 
> Bad Btrfs Feature Interactions: btrfs read-only snapshots (never
> tested, probably wouldn't work well)
> 
> Unfortunately it seems that bees doesn't support read-only snapshots,
> so it's a no way.
> 
> P.S.
> I tried duperemove with -A, but besides taking much longer it didn't 
> improve the situation.
> Are you sure that the culprit is duperemove? AFAIK it shouldn't
> unshare extents...

Unsharing of extents depends... If an extent is shared between a
r/o and r/w snapshot, rewriting the extent for deduplication ends up in
a shared extent again but it is no longer reflinked with the original
r/o snapshot. At least if btrfs doesn't allow to change extents part of
a r/o snapshot... Which you all tell is the case...

And then, there's unsharing of metadata by the deduplication process
itself.

Both effects should be minimal, tho. But since chunks are allocated in
1GB sizes, it may jump 1GB worth of allocation just for a few extra MB
needed. A metadata rebalance may fix this.


-- 
Regards,
Kai

Replies to list-only preferred.


