Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34161 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbbJSQNx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 12:13:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZoD4F-0006wP-Cj
	for linux-btrfs@vger.kernel.org; Mon, 19 Oct 2015 18:13:47 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 18:13:47 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 18:13:47 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: btrfs autodefrag?
Date: Mon, 19 Oct 2015 19:13:36 +0300
Message-ID: <m49si56bzv3.fsf@coffee.modeemi.fi>
References: <56227910.7000208@gmail.com>
	<CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
	<20151018144015.GV25907@carfax.org.uk>
	<m49zizfbcsb.fsf@coffee.modeemi.fi> <5624DA83.40200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn <ahferroin7@gmail.com> writes:

> And that is exactly the case with how things are now, when something
> is marked NOCOW, it has essentially zero guarantee of data consistency
> after a crash.

Yes. In addition to the zero guarantee of the data validity for the data
being written into, btrfs also doesn't give any guarantees for the rest
of the data, even if it was perfectly quiescent, but was just marked COW
at the time it was written :).

>  As things are now though, there is a guarantee that
> you can still read the file, but using checksums like you suggest
> would result in it being unreadable most of the time, because it's
> statistically unlikely that we wrote the _whole_ block (IOW, we can't
> guarantee without COW that the data was completely written) because:

Well, the amount of data being written at any given time is very small
compared to the whole device. So it's not all the data that is at risk
of having the wrong checksum. Given how small blocks are (4k) I really
doubt that the likelihood of large amounts of data remaining unreadable
would be great.

However, here's a compromise: when detecting an error on a COW file,
instead of refusing to read it, produce a warning to the kernel log. In
addition, when scrubbing it, the last resort after trying other copies
the checksum could simply be repaired, paired with an appropriate log
message. Such a log message would not indicate that the data is wrong,
but that the system administrator might be interested in checking it,
for example against backups, or by perhaps running a scrub within the
virtual machine.

If the scrub would say everything is OK, then certainly everything would
be OK.

> a. While some disks do atomically write single sectors, most don't,
> and if the power dies during the disk writing a single sector, there
> is no certainty exactly what that sector will read back as.

So it seems that the majority vote is to not to provide a feature to the
minority.. :)

> b. Assuming that item a is not an issue, one block in BTRFS is usually
> multiple sectors on disk, and a majority of disks have volatile write
> caches, thus it is not unlikely that the power will die during the
> process of writing the block.

I'm not at all familiar with the on-disk structure of Btrfs, but it
seems that indeed the block size is 16 kilobytes by default, so the risk
of one of the four device-blocks (on modern 4kB-sector HDDs) being
corrupted or only a set of them having being written is real. But,
there's only so much data in-flight at any given time.

I did read that there are two checksums (on Wikipedia,
Btrfs#Checksum_tree..): one per block, and one per a contiguous run of
allocated blocks. The latter checksum seems more likely to be broken,
but I don't see why in that case the per-block checksums (or one of the
two checksums I proposed) couldn't be referred to. This is of course
because I don't understand much of the Btrfs on-disk format, technical
feasibility be damned :).

I understand that the metadata is always COW, so that level of
corruption cannot occur.

> c. In the event that both items a and b are not an issue (for example,
> you have a storage controller with a non-volatile write cache, have
> write caching turned off on the disks, and it's a smart enough storage
> controller that it only removes writes from the cache after they
> return), then there is still the small but distinct possibility that
> the crash will cause either corruption in the write cache, or some
> other hardware related issue.

However, should this not be the case, for example when my computer is
never brought down abruptly, it could still be valuable information to
see that the data has not changed behind my back.

I understand it is the prime motivation behind btrfs scrubbing in any
case; otherwise there could be a faster 'queue a verify after a write'
that would never scrub the same data twice.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

