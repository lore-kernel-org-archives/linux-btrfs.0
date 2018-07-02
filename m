Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43924 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbeGBPTK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 11:19:10 -0400
Date: Mon, 2 Jul 2018 08:19:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180702151903.j3j522urrtyznylf@merlins.org>
References: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

thanks for the detailled and honest answer.
A few comments inline.

On Mon, Jul 02, 2018 at 10:42:40PM +0800, Qu Wenruo wrote:
> For full, it depends. (but for most real world case, it's still flawed)
> We have small and crafted images as test cases, which btrfs check can
> repair without problem at all.
> But such images are *SMALL*, and only have *ONE* type of corruption,
> which can represent real world case at all.
 
right, they're just unittest images, I understand.

> 1) Too large fs (especially too many snapshots)
>    The use case (too many snapshots and shared extents, a lot of extents
>    get shared over 1000 times) is in fact a super large challenge for
>    lowmem mode check/repair.
>    It needs O(n^2) or even O(n^3) to check each backref, which hugely
>    slow the progress and make us hard to locate the real bug.
 
So, the non lowmem version would work better, but it's a problem if it
doesn't fit in RAM.
I've always considered it a grave bug that btrfs check repair can use so
much kernel memory that it will crash the entire system. This should not
be possible.
While it won't help me here, can btrfs check be improved not to suck all
the kernel memory, and ideally even allow using swap space if the RAM is
not enough?

Is btrfs check regular mode still being maintained? I think it's still
better than lowmem, correct?

> 2) Corruption in extent tree and our objective is to mount RW
>    Extent tree is almost useless if we just want to read data.
>    But when we do any write, we needs it and if it goes wrong even a
>    tiny bit, your fs could be damaged really badly.
> 
>    For other corruption, like some fs tree corruption, we could do
>    something to discard some corrupted files, but if it's extent tree,
>    we either mount RO and grab anything we have, or hopes the
>    almost-never-working --init-extent-tree can work (that's mostly
>    miracle).
 
I understand that it's the weak point of btrfs, thanks for explaining.

> 1) Don't keep too many snapshots.
>    Really, this is the core.
>    For send/receive backup, IIRC it only needs the parent subvolume
>    exists, there is no need to keep the whole history of all those
>    snapshots.

You are correct on history. The reason I keep history is because I may
want to recover a file from last week or 2 weeks ago after I finally
notice that it's gone. 
I have terabytes of space on the backup server, so it's easier to keep
history there than on the client which may not have enough space to keep
a month's worth of history.
As you know, back when we did tape backups, we also kept history of at
least several weeks (usually several months, but that's too much for
btrfs snapshots).

>    Keep the number of snapshots to minimal does greatly improve the
>    possibility (both manual patch or check repair) of a successful
>    repair.
>    Normally I would suggest 4 hourly snapshots, 7 daily snapshots, 12
>    monthly snapshots.

I actually have fewer snapshots than this per filesystem, but I backup
more than 10 filesystems.
If I used as many snapshots as you recommend, that would already be 230
snapshots for 10 filesystems :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
