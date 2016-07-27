Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34215 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbcG0GMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 02:12:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id q128so4848488wma.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 23:12:46 -0700 (PDT)
Date: Wed, 27 Jul 2016 02:12:33 -0400
From: Sanidhya Solanki <lkml.page@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
Message-ID: <20160727021233.7e10ee48@ad>
In-Reply-To: <CAJCQCtTFGMku4FJZN7oH4=UV+F+Tz_FLD7RbUE5JWgaQKFtH4A@mail.gmail.com>
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
	<f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
	<CAJCQCtTFGMku4FJZN7oH4=UV+F+Tz_FLD7RbUE5JWgaQKFtH4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Jul 2016 11:14:37 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> On Fri, Jul 22, 2016 at 8:58 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2016-07-22 09:42, Sanidhya Solanki wrote:  
> 
> >> +*stripesize=<number>*;;
> >> +Specifies the new stripe size  
> 
> It'd be nice to stop conflating stripe size and stripe element size as
> if they're the same thing. I realize that LVM gets this wrong also,
> and uses stripes to mean "data strips", and stripesize for stripe
> element size. From a user perspective I find the inconsistency
> annoying, users are always confused about these terms.
> 
> So I think we need to pay the piper now, and use either strip size or
> stripe element size for this. Stripe size is the data portion of a
> full stripe read or write across all devices in the array. So right
> now with a 64KiB stripe element size on Btrfs, the stripe size for a 4
> disk raid0 is 256KiB, and the stripe size for a 4 disk raid 5 is
> 192KiB.
 
I absolutely agree with the statement regarding the difference between
those two separate settings. THis difference was more clearly visible
pre-Dec 2015, when it was removed for code appearance reasons by commit 
ee22184b53c823f6956314c2815d4068e3820737 (at the end of the commit).I
will update the documentation in the next patch to make it clear that
the balance option affects stripe size directly and the stripe element
size indirectly.


> It's 64KiB right now. Why go so much smaller?
> 
> mdadm goes from 4KiB to GiB's, with a 512KiB default.
> 
> lvm goes from 4KiB to the physical extent size, which can be GiB's.
> 
> I'm OK with an upper limit that's sane, maybe 16MiB? Hundreds of MiB's
> or even GiB's seems a bit far fetched but other RAID tools on Linux
> permit that.

The reason for this limit is the fact that, as I noted above the real 
stripe size is currently 4KiB, with an element size of 64KiB. 
Ostensibly, we can change the stripe size to any 512B multiple that is
less than 64KiB. Increasing it beyond 64KiB is risky because a lot of
calculations (only the basis of which I modified for this patch, and not
the dependencies of those algorithms and calculations) rely on the stripe
element size being 64KiB. I do not want to increase this limit as it may
lead to un-discovered bugs in the already buggy RAID 5/6 code. 

If this patch is accepted, I intend in the next few patches to do the
following:
-increase maximum stripe size to 64KiB, by reducing the number of blocks
 to 1 per stripe extent.
-Update the documentation to notify user of this change and the need for
 caution, as well as trial and error, to find an appropriate size upto
 64KiB, with a warning to only change it if users understand the
 consequences and reasons for the change, as suggested by ASH.
-Clean up the RAID 5/6 recovery code and stripe code over the coming
 months.
-Clean up the code that relies on calculations that depend on stripe size
 and their dependencies.
-Remove this stripe size and stripe element size limitation completely, as
 suggested by both ASH and CMu.

Just waiting on reviews and acceptance for this patch as the basis of the
above work. I started on the RAID recovery code yesterday.

It also appears that according to the commit that I stated above that the
stripe size used to be 1KiB, with 64 elements per stripe element, but was
changed in Dec 2015, so maybe as long as you do not change the stripe size
to be more than 64KiB, you do not need to balance after using this balance 
option (atleast the first time). I do not remember seeing any bug reports
on the mailing list since then that called out stripe size as the problem.

Interesting.
