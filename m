Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50770 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753798AbdBGVUp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 16:20:45 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbDAF-0005Zw-QQ
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 22:19:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 22:14:35 +0100
Message-ID: <20170207221435.38377988@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
        <CAGqmi759eH6QT3Qx_S47_hWKajhwnc0UxyaLhayMEZ4D+bnvGQ@mail.gmail.com>
        <62994104-e9b2-6544-1f3b-bf37df4275f9@gmail.com>
        <CAGqmi772WF8KqMWUowtG2_8uS7KTu3u4vJkNbhTHams_x13jWg@mail.gmail.com>
        <716741d9-deef-ebc1-b418-da9f8d23d791@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 10:43:11 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > I mean that:
> > You have a 128MB extent, you rewrite random 4k sectors, btrfs will
> > not split 128MB extent, and not free up data, (i don't know
> > internal algo, so i can't predict when this will hapen), and after
> > some time, btrfs will rebuild extents, and split 128 MB exten to
> > several more smaller. But when you use compression, allocator
> > rebuilding extents much early (i think, it's because btrfs also
> > operates with that like 128kb extent, even if it's a continuos
> > 128MB chunk of data). 
> The allocator has absolutely nothing to do with this, it's a function
> of the COW operation.  Unless you're using nodatacow, that 128MB
> extent will get split the moment the data hits the storage device
> (either on the next commit cycle (at most 30 seconds with the default
> commit cycle), or when fdatasync is called, whichever is sooner).  In
> the case of compression, it's still one extent (although on disk it
> will be less than 128MB) and will be split at _exactly_ the same time
> under _exactly_ the same circumstances as an uncompressed extent.
> IOW, it has absolutely nothing to do with the extent handling either.

I don't think that btrfs splits extents which are part of the snapshot.
The extent in a snapshot will stay intact when writing to this extent
in another snapshot. Of course, in the just written snapshot, the
extent will be represented as a split extent mapping to the original
extents data blocks plus the new data in the middle (thus resulting in
three extents). This is also why small random writes without autodefrag
result in a vast amount of small extents bringing the fs performance to
a crawl.

Do that multiple times on multiple snapshots, delete some of the
original snapshots, and you're left with slack space, data blocks being
inaccessible and won't be reclaimed into free space (because they
are still part of the original extent), and which can only be
reclaimed by a defrag operation - which would of course unshares data.

Thus, if any of the above mentioned small extents is still shared with
an extent originally much bigger, then it will still occupy its
original space on the filesystem - even when its associated
snapshot/subvolume no longer exists. Only when the last remaining
tiny block of such an extent gets rewritten and the reference counter
decreases to zero, the extent is given up and freed.

To work around this, you can currently only unshare and recombine by
doing defrag and dedupe on all snapshots. This will reclaim space
sitting in parts of the original extents no longer referenced by a
snapshot visible from the VFS layer.

This is for performance reasons because btrfs is extent based.

As far as I know, ZFS on the other side, works different. It uses block
based storage for the snapshot feature and can easily throw away unused
blocks. Only a second layer on top maps this back into extents. The
underlying infrastructure, however, is block based storage, which also
enables the volume pool to create block devices on the fly out of ZFS
storage space.

PS: All above given the fact I understood it right. ;-)

-- 
Regards,
Kai

Replies to list-only preferred.

