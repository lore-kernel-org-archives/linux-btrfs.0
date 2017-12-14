Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44821 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbdLNFrM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 00:47:12 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ePMMG-00013v-AW
        for linux-btrfs@vger.kernel.org; Thu, 14 Dec 2017 06:47:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG?] Defrag on compressed FS do massive data rewrites
Date: Thu, 14 Dec 2017 05:46:54 +0000 (UTC)
Message-ID: <pan$bd6a9$c253bd0$c2700692$e269020a@cox.net>
References: <CAGqmi76womfiPa_EkKiJ-BgxEcU1GjK7efrh8bWVD0kD+C9NrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Thu, 14 Dec 2017 01:09:52 +0300 as excerpted:

> Hi, i see massive data rewrites of defragmented files when work with
> btrfs fi def <args>.
> Before, i just thought it's a design problem - i.e. defrag always
> rewrite data to new place.
> 
> At now, i read the code and see 2 bad cases:
> 1. With -c<compression_algo> all extents of data will be rewriten,
> always.

Based on previous threads this is indeed expected behavior -- it's the 
recommendation for those who want to recompress to a different target 
compression level, so rewriting *everything* the command line points at 
is required.

And FWIW that's exactly how I'd interpret the manpage's description of 
the -c option as well: "Compress file contents while defragging", with 
the example using defrag -c later in the manpage explaining it as "force 
file compression."

So I'd call this behavior documented.

> 2. btrfs use "bad" default target extent size, i.e. kernel by default
> try get 256KiB extent, btrfs-progres use 32MiB as a threshold.
>  Both of them make ioctl code should_defrag_range() think, that extent
> are "too" fragmented, and rewrite all compressed extents.

I've not seen this mentioned previously, and it certainly does surprise 
me.  I suspect in this case it's accidental, simply the result of btrfs 
choosing a 128 KiB compression block, while whoever did the defrag code 
wasn't thinking about the effects of a 256 KiB or 32 MiB target size on 
compressed extents, which always show up as 128 KiB due to that being the 
compression block size, even if they're adjacent and thus not /really/ 
fragmented.

What /really/ surprises me, tho, is that yes, it's known that filefrag 
reports the wrong thing for compressed files, but btrfs is the one doing 
it that way in the first place, and /it/ can't figure out that they're 
not actually fragmented, even for calculations like this where getting 
the actual fragmentation is the entire point?  That's crazy!

> Does that behavior expected?
> 
> i.e. only way that i can safely use on my data are:
> btrfs fi def -vr -t 128KiB <path>
> That will defrag all fragmented compressed extents.

Given the above that appears to be accurate.  If you don't want the 
compressed extents rewritten, don't supply the -c/compress option and 
rely on the compress mount option to do the default compression it would 
do on any other write.  And set -t 128K (according to the manpage, it's 
just K, not KiB, don't know if it actually takes KiB as I'm an admin 
reading manpage, not a coder reading code) so it considers full 
compression blocks defragged.

Tho that assumes you're correct and the code doesn't make allowances for 
compression-block size elsewhere, but I have no reason to assume 
otherwise unless a dev points it out.

> "Hacky" solution that i see for now, is a create copy of
> inode_need_compress()
> for defrag ioctl, and if file must be compressed, force use of 128KiB as
> target extent.
> or at least document that not obvious behaviour.

#2 really does need documented or changed, yes.  It's certainly 
surprising, here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

