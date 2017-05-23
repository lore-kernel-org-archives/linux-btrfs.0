Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38374 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdEWScR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 14:32:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dDEbJ-0006C1-JA
        for linux-btrfs@vger.kernel.org; Tue, 23 May 2017 20:32:09 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Date: Tue, 23 May 2017 20:32:07 +0200
Message-ID: <20170523203207.6fb276c4@jupiter.sol.kaishome.de>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
        <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
        <20170522013553.hspdrwpmxe5kyoas@merlins.org>
        <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
        <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
        <20170522235754.GJ29894@merlins.org>
        <CAJCQCtR52d2EPgEGPNYDMf3zy7vV-5Yud_k3kVFDrb0JD80PKg@mail.gmail.com>
        <fe10e4c5-fa1b-3725-4680-e4daf939dc8c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 23 May 2017 07:21:33 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2017-05-22 22:07, Chris Murphy wrote:
> > On Mon, May 22, 2017 at 5:57 PM, Marc MERLIN <marc@merlins.org>
> > wrote:  
> >> On Mon, May 22, 2017 at 05:26:25PM -0600, Chris Murphy wrote:  
>  [...]  
>  [...]  
>  [...]  
> >>
> >> Oh, swap will work, you're sure?
> >> I already have an SSD, if that's good enough, I can give it a
> >> shot.  
> >
> > Yeah although I have no idea how much swap is needed for it to
> > succeed. I'm not sure what the relationship is to fs metadata chunk
> > size to btrfs check RAM requirement is; but if it wants all of the
> > metadata in RAM, then whatever btrfs fi us shows you for metadata
> > may be a guide (?) for how much memory it's going to want.  
> I think the in-memory storage is a bit more space efficient than the 
> on-disk storage, but I'm not certain, and I'm pretty sure it takes up 
> more space when it's actually repairing things.  If I'm doing the
> math correctly, you _may_ need up to 50% _more_ than the total
> metadata size for the FS in virtual memory space.
> >
> > Another possibility is zswap, which still requires a backing device,
> > but it might be able to limit how much swap to disk is needed if the
> > data to swap out is highly compressible. *shrug*
> >  
> zswap won't help in that respect, but it might make swapping stuff
> back in faster.  It just keeps a compressed copy in memory in
> parallel to writing the full copy out to disk, then uses that
> compressed copy to swap in instead of going to disk if the copy is
> still in memory (but it will discard the compressed copies if memory
> gets really low).  In essence, it reduces the impact of swapping when
> memory pressure is moderate (the situation for most desktops for
> example), but becomes almost useless when you have very high memory
> pressure (which is what describes this usage).

Is this really how zswap works?

I always thought it acts as a compressed write-back cache in front of
the swap devices. Pages first go to zswap compressed, and later
write-back kicks in and migrates those compressed pages to real swap,
but still compressed. This is done by zswap putting two (or up to three
in modern kernels) compressed pages into one page. It has the downside
of uncompressing all "buddy pages" when only one is needed back in. But
it stays compressed. This also tells me zswap will either achieve
around 1:2 or 1:3 effective compression ratio or none. So it cannot be
compared to how streaming compression works.

OTOH, if the page is reloaded from cache before write-back kicks in, it
will never be written to swap but just uncompressed and discarded from
the cache.

Under high memory pressure it doesn't really work that well due to high
CPU overhead if pages constantly swap out, compress, write, read,
uncompress, swap in... This usually results in very low CPU usage for
processes but high IO and disk wait and high kernel CPU usage. But it
defers memory pressure conditions to a little later in exchange for
more a little more IO usage and more CPU usage. If you have a lot of
inactive memory around, it can make a difference. But it is counter
productive if almost all your memory is active and pressure is high.

So, in this scenario, it probably still doesn't help.


-- 
Regards,
Kai

Replies to list-only preferred.

