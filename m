Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45960 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdEBUAP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 16:00:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d5dxs-0002GS-C4
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 22:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem
 by X hours?
Date: Tue, 2 May 2017 21:59:50 +0200
Message-ID: <20170502215950.088a1a6e@jupiter.sol.kaishome.de>
References: <20170501170641.GG3516@merlins.org>
        <20170501180856.GH3516@merlins.org>
        <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
        <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
        <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 1 May 2017 22:56:06 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Mon, May 1, 2017 at 9:23 PM, Marc MERLIN <marc@merlins.org> wrote:
> > Hi Chris,
> >
> > Thanks for the reply, much appreciated.
> >
> > On Mon, May 01, 2017 at 07:50:22PM -0600, Chris Murphy wrote:  
> >> What about btfs check (no repair), without and then also with
> >> --mode=lowmem?
> >>
> >> In theory I like the idea of a 24 hour rollback; but in normal
> >> usage Btrfs will eventually free up space containing stale and no
> >> longer necessary metadata. Like the chunk tree, it's always
> >> changing, so you get to a point, even with snapshots, that the old
> >> state of that tree is just - gone. A snapshot of an fs tree does
> >> not make the chunk tree frozen in time.  
> >
> > Right, of course, I was being way over optimistic here. I kind of
> > forgot that metadata wasn't COW, my bad.  
> 
> Well it is COW. But there's more to the file system than fs trees, and
> just because an fs tree gets snapshot doesn't mean all data is
> snapshot. So whether snapshot or not, there's metadata that becomes
> obsolete as the file system is updated and those areas get freed up
> and eventually overwritten.
> 
> 
> >  
> >> In any case, it's a big problem in my mind if no existing tools can
> >> fix a file system of this size. So before making anymore changes,
> >> make sure you have a btrfs-image somewhere, even if it's huge. The
> >> offline checker needs to be able to repair it, right now it's all
> >> we have for such a case.  
> >
> > The image will be huge, and take maybe 24H to make (last time it
> > took some silly amount of time like that), and honestly I'm not
> > sure how useful it'll be.
> > Outside of the kernel crashing if I do a btrfs balance, and
> > hopefully the crash report I gave is good enough, the state I'm in
> > is not btrfs' fault.
> >
> > If I can't roll back to a reasonably working state, with data loss
> > of a known quantity that I can recover from backup, I'll have to
> > destroy and filesystem and recover from scratch, which will take
> > multiple days. Since I can't wait too long before getting back to a
> > working state, I think I'm going to try btrfs check --repair after
> > a scrub to get a list of all the pathanmes/inodes that are known to
> > be damaged, and work from there.
> > Sounds reasonable?  
> 
> Yes.
> 
> 
> >
> > Also, how is --mode=lowmem being useful?  
> 
> Testing. lowmem is a different implementation, so it might find
> different things from the regular check.
> 
> 
> >
> > And for re-parenting a sub-subvolume, is that possible?
> > (I want to delete /sub1/ but I can't because I have /sub1/sub2
> > that's also a subvolume and I'm not sure how to re-parent sub2 to
> > somewhere else so that I can subvolume delete sub1)  
> 
> Well you can move sub2 out of sub1 just like a directory and then
> delete sub1. If it's read-only it can't be moved, but you can use
> btrfs property get/set ro true/false to temporarily make it not
> read-only, move it, then make it read-only again, and it's still fine
> to use with btrfs send receive.
> 
> 
> 
> 
> 
> >
> > In the meantime, a simple check without repair looks like this. It
> > will likely take many hours to complete:
> > gargamel:/var/local/space# btrfs check /dev/mapper/dshelf2
> > Checking filesystem on /dev/mapper/dshelf2
> > UUID: 03e9a50c-1ae6-4782-ab9c-5f310a98e653
> > checking extents
> > checksum verify failed on 3096461459456 found 0E6B7980 wanted
> > FBE5477A checksum verify failed on 3096461459456 found 0E6B7980
> > wanted FBE5477A checksum verify failed on 2899180224512 found
> > 7A6D427F wanted 7E899EE5 checksum verify failed on 2899180224512
> > found 7A6D427F wanted 7E899EE5 checksum verify failed on
> > 2899180224512 found ABBE39B0 wanted E0735D0E checksum verify failed
> > on 2899180224512 found 7A6D427F wanted 7E899EE5 bytenr mismatch,
> > want=2899180224512, have=3981076597540270796 checksum verify failed
> > on 1449488023552 found CECC36AF wanted 199FE6C5 checksum verify
> > failed on 1449488023552 found CECC36AF wanted 199FE6C5 checksum
> > verify failed on 1449544613888 found 895D691B wanted A0C64D2B
> > checksum verify failed on 1449544613888 found 895D691B wanted
> > A0C64D2B parent transid verify failed on 1671538819072 wanted
> > 293964 found 293902 parent transid verify failed on 1671538819072
> > wanted 293964 found 293902 checksum verify failed on 1671603781632
> > found 18BC28D6 wanted 372655A0 checksum verify failed on
> > 1671603781632 found 18BC28D6 wanted 372655A0 checksum verify failed
> > on 1759425052672 found 843B59F1 wanted F0FF7D00 checksum verify
> > failed on 1759425052672 found 843B59F1 wanted F0FF7D00 checksum
> > verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> > checksum verify failed on 2182657212416 found CD8EFC0C wanted
> > 70847071 checksum verify failed on 2898779357184 found 96395131
> > wanted 433D6E09 checksum verify failed on 2898779357184 found
> > 96395131 wanted 433D6E09 checksum verify failed on 2899180224512
> > found 7A6D427F wanted 7E899EE5 checksum verify failed on
> > 2899180224512 found 7A6D427F wanted 7E899EE5 checksum verify failed
> > on 2899180224512 found ABBE39B0 wanted E0735D0E checksum verify
> > failed on 2899180224512 found 7A6D427F wanted 7E899EE5 bytenr
> > mismatch, want=2899180224512, have=3981076597540270796 checksum
> > verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> > checksum verify failed on 2182657212416 found CD8EFC0C wanted
> > 70847071 checksum verify failed on 2182657212416 found CD8EFC0C
> > wanted 70847071 checksum verify failed on 2182657212416 found
> > CD8EFC0C wanted 70847071 checksum verify failed on 2182657212416
> > found CD8EFC0C wanted 70847071  
> 
> Not understanding the problem, it's by definition naive for me to
> suggest it should go read-only sooner before hosing itself. But I'd
> like to think it's possible for Btrfs to look backward every once in a
> while for sanity checking, to limit damage should it be occurring even
> if the hardware isn't reporting any problems.

Would it be possible to make btrfs avoid using parts of the filesystem
it detected corruptions in? Then a still-in-theory online repair tool
could check these parts, maybe repair them (or destroy them upon
request), and make those parts of the fs available again... Such a
repair tool (scanning only known corrupted parts) would probably also
need less memory and time to run.

-- 
Regards,
Kai

Replies to list-only preferred.

