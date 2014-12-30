Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:49971 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbaL3AUT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 19:20:19 -0500
Message-ID: <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
In-Reply-To: <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
Date: Mon, 29 Dec 2014 16:20:15 -0800
Subject: Re: I need to P. are we almost there yet?
From: ashford@whisperpc.com
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "sys.syphus" <syssyphus@gmail.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Mon, Dec 29, 2014 at 12:00 PM, sys.syphus <syssyphus@gmail.com> wrote:
>> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
>> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
>> speak raid10 means you can lose 2 drives assuming they aren't the
>> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
>> one no matter what?
>
> It's only for sure one in any case even with conventional raid10. It
> just depends on which 2 you lose that depends whether your data has
> dodged a bullet. Obviously you can't lose a drive and its mirror,
> ever, or the array collapses.

Just some background data on traditional RAID, and the chances of survival
with a 2-drive failure.

In traditional RAID-10, the chances of surviving a 2-drive failure is 66%
on a 4-drive array, and approaches 100% as the number of drives in the
array increase.

In traditional RAID-0+1 (used to be common in low-end fake-RAID cards),
the chances of surviving a 2-drive failure is 33% on a 4-drive array, and
approaches 50% as the number of drives in the array increase.

In traditional RAID-1E, the chances of surviving a 2-drive failure is 66%
on a 4-drive array, and approaches 100% as the number of drives in the
array increase.  This is the same as for RAID-10.  RAID-1E allows an odd
number of disks to be actively used in the array. 
https://en.wikipedia.org/wiki/File:RAID_1E.png

I'm wondering which of the above the BTRFS implementation most closely
resembles.

> So if you want the same amount of raid6 testing by time it would be
> however many years that's been from the time 3.19 is released.

I don't believe that's correct.  Over those several years, quite a few
tests for corner cases have been developed.  I expect that those tests are
used for regression testing of each release to ensure that old bugs aren't
inadvertently reintroduced.  Furthermore, I expect that a large number of
those corner case tests can be easily modified to test RAID-5 and RAID-6. 
In reality, I expect the stability (i.e. similar to RAID-10 currently) of
RAID-5/6 code in BTRFS will be achieved rather quickly (only a year or
two).

I expect that the difficult part will be to optimize the performance of
BTRFS.  Hopefully those tests (and others, yet to be developed) will be
able to keep it stable while the code is optimized for performance.

Peter Ashford

