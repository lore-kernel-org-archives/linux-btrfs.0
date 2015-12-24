Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33236 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbbLXU5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 15:57:35 -0500
Received: by mail-io0-f194.google.com with SMTP id f127so19012371ioa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 12:57:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC=t97BsV1FJr+icGLY8XKyLjejG-k0frSuPWZtRu=N5znfXEw@mail.gmail.com>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
	<pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
	<CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
	<pan$82f3e$e3af006a$d15f1d6c$4b07b3ba@cox.net>
	<CAC=t97BsV1FJr+icGLY8XKyLjejG-k0frSuPWZtRu=N5znfXEw@mail.gmail.com>
Date: Thu, 24 Dec 2015 13:57:35 -0700
Message-ID: <CAJCQCtRXBPBsiAH65JKFy7+5sFM7fnrAKg-7ESaoeUTsmMqdrg@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
From: Chris Murphy <lists@colorremedies.com>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 24, 2015 at 9:19 AM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:

> Got it.  I'm not the biggest fan of mixing mdraid with btrfs raid in
> order to work around deficiencies.  Hopefully in the future btrfs will
> allow me to select my mirror groups.

As far as I know, mdadm -l raid10 works this same way, you don't have
control over this. But what you can do with mdadm is create mirrored
pairs first, and then stripe those arrays. I don't know if that's
better/easier/necessary to do with an mdadm container.



> The trouble with a mirror of stripes is you take a nasty impact to
> your fault tolerance for dropping drives.  With Raid01 dropping just 1
> drive from each cabinet will fail the entire array because there is
> only one mirror group.  So now it's a choice between fault tolerance
> of dropping drives or fault tolerance of file-level errors.

Right. Open question if btrfs raid10 is more like raid01 because of
this. Where it's more like raid10 than 01 is rebuild. With 01, when
one drive dies, the entire raid0 array its in dies and has to be
rebuilt, which is not the case for btrfs. So it has characteristics of
raid10 and raid01 depending on the mode and context.

Thing is the trend of building storage stacks, because drive
capacities are so huge but their performance hasn't scaled at the same
rate, is to build more arrays with fewer drives, and pool the arrays
with something like ceph or glusterfs.

While the controller tolerance is a legit concern, is it more or less
likely to have a controller problem than it is a power supply problem?
Or something with that particular system that just craps out rather
than the array attached to it?


> All this makes me ask why?  Why implement Raid10 in this non-standard
> fashion and create this mess of compromise?

Because it was a straightforward extension of how the file system
already behaves. To implement drive based copies rather than chunk
based copies is a totally different strategy that actually negates how
btrfs does allocation, and would require things like logically
checking for mirrored pairs being the same size +/- maybe 1% similar
to mdadm.

And keep in mind the raid10 multiple device failure is not fixed, not
just any additional failure is OK. It just depends on aviation's
equivalent of "big sky theory" for air traffic separation. Yes the
probability of mirror A's two drives dying is next to zero, but it's
not zero. If you're building arrays depending on it being zero, well
that's not a good idea. The way to look at it is more of a bonus of
uptime, rather than depending on it in design. You design for it's
scaleable performance, which it does have.



>  It's frustrating on the
> user side and makes admins look at alternatives.  All this is because
> I can't define what the mirrored pairs (or beyond in the future) are,
> just to gain elegance in supporting different sized drives?  That can
> be done at the stripe level, it doesn't need to be done at the mirror
> level, and if it were done at the stripe level this issue wouldn't
> exist.

Whether the granularity for mirroring shifts from chunks to drives or
to stripes doesn't matter. A mirrored pair will have to be the same
size, or the bullseye simply gets bigger, from one drive to two or
more.


> I get it but this really isn't compelling.  This can't be done without
> using a hybrid of mdraid + btrfs; I can already do this in a raid 1+0
> arrangement I just don't benefit from checksumming.  All
> N-way-mirroring is going to give me is the ability to do it in a 0+1
> arrangement which means my filesystem made of 3 trays of 30 drives
> total will be failed with just the failure of 1 drive in each tray and
> that's not acceptable.

OK, so in that case, you can't use Btrfs alone to get the fault
tolerance you need. There are other things I'd think an admin would
want in a Btrfs only solution that Btrfs doesn't have, like the faulty
state for devices and notifications for that state change. This isn't
the only one, it's just rather a gotcha if you come with the
expectation of raid10 being almost certainly capable of tolerating a 2
disk failure. So I do kinda wonder if it ought to be called raid01,
even though that's misleading too, but at least not in a way that
causes an overestimation of data availability.


-- 
Chris Murphy
