Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36148 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaL3RJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 12:09:16 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so20934438wgg.7
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 09:09:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALBWd85UsSih24RhwpmDeMjuMWCKj9dGeuZes5POj6qEFkiz2w@mail.gmail.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
	<CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
	<7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
	<CALBWd85UsSih24RhwpmDeMjuMWCKj9dGeuZes5POj6qEFkiz2w@mail.gmail.com>
Date: Tue, 30 Dec 2014 17:09:14 +0000
Message-ID: <CALBWd86JJd8KyuCg5dRweta1ydH3s9Yn1Q=rJ4-uzWkk+P7CpA@mail.gmail.com>
Subject: Fwd: I need to P. are we almost there yet?
From: Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think you are missing crucial info on the layout on disk that BTRFS
implements. While a traditional RAID1 has a rigid layout that has
fixed and easily predictable locations for all data (exactly on two
specific disks), BTRFS allocs chunks as needed on ANY two disks.
Please research into this to understand the problem fully, this is the
key to your question.

I mean with RAID1 you know your data is on disk 1 and 2, and if one of
those fails you have a surviving mirror. Two disk failures with RAID10
when they pertain to different mirror disk pairs is no problem.

With BTRFS you cannot guarantee that simultaneous two disk failures
won't affect chunks that have the two mirrors precisely in that two
disks... even when there is greater chance that the chunks are
mirrored in other drives... probability of surviving is greater with
greater number of disks but we are talking about worst case scenarios
and guarantees. There will be, eventually, chunks that are using those
two disks for mirrors...

Take into account that traditional RAID10 has higher probability of
surviving but in worst case scenario is exactly the same: on
simultaneous failure of any one two disk mirror pair.

Please think about this as well: "simultaneous" should be read as
"within a rebuild window". In a hardware RAID, the HBA is expected to
kick in rebuild as soon as you replace failing disk (zero delay if you
have a hotspare). In BTRFS you are expected to first notice the
problem and second replace and scrub or rebalance. Any second failure
before full rebuild will be fatal to some extent.

I would also discard raid5 as you would have a complete failure with
two simultaneous disk failures, be it traditional or btrfs
implementation.

You should aim at RAID6 at minimum on hardware implementations, or
equivalent on btrfs. so to withstand a two disk failure. Some guys are
pushing for triple "mirror" but it's expensive in "wasted" disk space
(altough implementations like Ceph are good IMHO). Better are
generalized forms of parity that extend to more than two parity
"disks" if you want maximum storage capacity (but probably slow
writing).

Jose Manuel Perez Bethencourt

>
> > On Mon, Dec 29, 2014 at 12:00 PM, sys.syphus <syssyphus@gmail.com> wrote:
> >> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
> >> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
> >> speak raid10 means you can lose 2 drives assuming they aren't the
> >> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
> >> one no matter what?
> >
> > It's only for sure one in any case even with conventional raid10. It
> > just depends on which 2 you lose that depends whether your data has
> > dodged a bullet. Obviously you can't lose a drive and its mirror,
> > ever, or the array collapses.
>
> Just some background data on traditional RAID, and the chances of survival
> with a 2-drive failure.
>
> In traditional RAID-10, the chances of surviving a 2-drive failure is 66%
> on a 4-drive array, and approaches 100% as the number of drives in the
> array increase.
>
> In traditional RAID-0+1 (used to be common in low-end fake-RAID cards),
> the chances of surviving a 2-drive failure is 33% on a 4-drive array, and
> approaches 50% as the number of drives in the array increase.
>
> In traditional RAID-1E, the chances of surviving a 2-drive failure is 66%
> on a 4-drive array, and approaches 100% as the number of drives in the
> array increase.  This is the same as for RAID-10.  RAID-1E allows an odd
> number of disks to be actively used in the array.
> https://en.wikipedia.org/wiki/File:RAID_1E.png
>
> I'm wondering which of the above the BTRFS implementation most closely
> resembles.
>
> > So if you want the same amount of raid6 testing by time it would be
> > however many years that's been from the time 3.19 is released.
>
> I don't believe that's correct.  Over those several years, quite a few
> tests for corner cases have been developed.  I expect that those tests are
> used for regression testing of each release to ensure that old bugs aren't
> inadvertently reintroduced.  Furthermore, I expect that a large number of
> those corner case tests can be easily modified to test RAID-5 and RAID-6.
> In reality, I expect the stability (i.e. similar to RAID-10 currently) of
> RAID-5/6 code in BTRFS will be achieved rather quickly (only a year or
> two).
>
> I expect that the difficult part will be to optimize the performance of
> BTRFS.  Hopefully those tests (and others, yet to be developed) will be
> able to keep it stable while the code is optimized for performance.
>
> Peter Ashford
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
