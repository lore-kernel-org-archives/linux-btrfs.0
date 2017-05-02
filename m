Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50110 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEBFMB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 01:12:01 -0400
Date: Mon, 1 May 2017 22:11:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Message-ID: <20170502051155.igmbqcqgzi4ukefg@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
 <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 01, 2017 at 10:56:06PM -0600, Chris Murphy wrote:
> > Right, of course, I was being way over optimistic here. I kind of forgot
> > that metadata wasn't COW, my bad.
> 
> Well it is COW. But there's more to the file system than fs trees, and
> just because an fs tree gets snapshot doesn't mean all data is
> snapshot. So whether snapshot or not, there's metadata that becomes
> obsolete as the file system is updated and those areas get freed up
> and eventually overwritten.

Got it, thanks for explaining.

> > Also, how is --mode=lowmem being useful?
> 
> Testing. lowmem is a different implementation, so it might find
> different things from the regular check.
 
I see.
I've fired off some scrub -r and then check to run overnight, I'll see
if it finishes overnight assuming the kernel doesn't crash again (yeah,
just to make things simpler, I'm hitting another issue when I/O piles up
on btrfs on top of dmcrypt on top of bcache
http://lkml.iu.edu/hypermail/linux/kernel/1705.0/00626.html
https://pastebin.com/YqE4riw0
but that's not a bcache bug, just something else getting in the way.

> > And for re-parenting a sub-subvolume, is that possible?
> > (I want to delete /sub1/ but I can't because I have /sub1/sub2 that's also a subvolume
> > and I'm not sure how to re-parent sub2 to somewhere else so that I can subvolume delete
> > sub1)
> 
> Well you can move sub2 out of sub1 just like a directory and then
> delete sub1. If it's read-only it can't be moved, but you can use
> btrfs property get/set ro true/false to temporarily make it not
> read-only, move it, then make it read-only again, and it's still fine
> to use with btrfs send receive.

Ah, I didn't think mv would work from inside a subvolume to outside of a
subvolume without copying data (it doesn't for files) but I guess it
would for for subvolumes, good point.
I'll try that, thanks.

> Not understanding the problem, it's by definition naive for me to
> suggest it should go read-only sooner before hosing itself. But I'd
> like to think it's possible for Btrfs to look backward every once in a
> while for sanity checking, to limit damage should it be occurring even
> if the hardware isn't reporting any problems.

Fair point. To be honest, maybe btrfs could indeed have detected
problems earlier, but ultimately it's not really its fault if bad things
happen when I'm having repeated storage errors underneath. For all I
know, some data got written after getting corrupted and btrfs would not
notice that right away.
Now, I kind of naively thought I could simply unroll all writes done
after a certain point. You pointed right (rightfully so) that it's not
nearly as simple as I was hoping.

So at this point, I think it's just a matter of me providing
check/repair logs if they are useful, and someone looking into this
balance causing a kernel crash, which is IMO the only real thing that
btrfs should reasonably fix.

I'll update the thread when I have more logs and have moved further on
the recovery.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
