Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34777 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbLXQUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 11:20:14 -0500
Received: by mail-oi0-f53.google.com with SMTP id o124so140049676oia.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 08:20:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$82f3e$e3af006a$d15f1d6c$4b07b3ba@cox.net>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
 <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
 <CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
 <pan$9b1ad$a377a340$8346d054$a731dd54@cox.net> <CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
 <pan$82f3e$e3af006a$d15f1d6c$4b07b3ba@cox.net>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 24 Dec 2015 10:19:53 -0600
Message-ID: <CAC=t97BsV1FJr+icGLY8XKyLjejG-k0frSuPWZtRu=N5znfXEw@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 7:21 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Donald Pearson posted on Wed, 23 Dec 2015 09:53:41 -0600 as excerpted:
>
>> Additionally real Raid10 will run circles around what BTRFS is doing in
>> terms of performance.  In the 20 drive array you're striping across 10
>> drives, in BTRFS right now you're striping across 2 no matter what. So
>> not only do I lose in terms of resilience I lose in terms of
>> performance.  I assume that N-way-mirroring used with BTRFS Raid10 will
>> also increase the stripe width so that will level out the performance
>> but you're always going to be short a drive for equal resilience.
>
> No, with btrfs raid10, you're /mirroring/ across two drives no matter
> what.  With 20 devices, you're /striping/ across 10 two-way mirrors.
> It's the same as a standard raid10, in that regard.
>
> Tho it's a bit different in that the mix of devices forming the above can
> differ among different chunks.  IOW, the first chunk might be mirrored a/
> b c/d e/f g/h i/j k/l m/n o/p q/r s/t, with the stripe across each mirror-
> pair, but the chunk might be mirrored a/l g/o f/k b/n c/d e/s j/q h/t i/p
> m/r (I think I got each letter once...), and striped across those pairs.
>
> So you get the same performance as a normal raid10 (well, to the extent
> that btrfs has been optimized, which in large part it hasn't been, yet),
> but as should always be the case in a raid10, randomized loss of more
> than a single device can mean data loss.
>
> But, because each chunk pair assignment is more or less randomized,
> unlike a conventional raid10 which lets you map all of one mirror set to
> one cabinet and all of the second mirror set to another cabinet, so you
> can reliably lose an entire cabinet and be fine since it's known to
> correspond exactly to a single mirror set, you can't do that with btrfs
> raid10, because there's no way to specify individual chunk mirroring and
> what might be precisely one mirror set with one chunk, is very likely to
> be both copies of some mirrors and no copies of other mirrors, with
> another chunk.

Understood.  I was definitely confused on how it worked earlier.  What
I thought I read was really bizarre.

>
> What I was suggesting as a solution was a setup that:
> (a) has btrfs raid1 at the top level
> (b) has a pair of mdraidNs underneath, in this case a pair of 10-device
> mdraid10s.
> (c) has the pair of mdraidNs each presented to btrfs as one of its raid1
> mirrors.
>
> While this is actually raid01, not raid10, in this case it makes more
> sense than a mixed raid10, because by doing it that way, you'd:
> 1) keep btrfs' data integrity and error correction at the top level, as
> it could pull from the second copy if the first failed checksum.
> 2) be able to stick each mdraid0 in its own cabinet, so loss of the
> entire cabinet wouldn't be data loss, only redundancy loss.
>
> (Reversing that, btrfs raid0 on top of mdraid1, would lose btrfs' ability
> to correct checksum errors as at the btrfs level, it'd be non-redundant,
> and mdraid1 doesn't have checksumming, so it couldn't provide the same
> data integrity service.  Without checksumming and pull from the other
> copy in case of error, you could scrub the mdraid1 to make its mirrors
> identical again, but you'd be just as likely to copy the bad one to the
> good one as the reverse.  Thus, btrfs really needs to be the raid1 layer
> unless you simply don't care about data integrity, and because btrfs is
> the filesystem layer, it has to be the top layer, so you're left doing a
> raid01 instead of the raid10 that's ordinarily preferred due to locality
> of a rebuild, absent other factors like this data integrity factor.)
>

Got it.  I'm not the biggest fan of mixing mdraid with btrfs raid in
order to work around deficiencies.  Hopefully in the future btrfs will
allow me to select my mirror groups.

The trouble with a mirror of stripes is you take a nasty impact to
your fault tolerance for dropping drives.  With Raid01 dropping just 1
drive from each cabinet will fail the entire array because there is
only one mirror group.  So now it's a choice between fault tolerance
of dropping drives or fault tolerance of file-level errors.

So we're in this position of forced compromise where I have to decide
between a pure and simpler btrfs raidx configuration but give up
controller tolerance, or accept a more convoluted hybrid of mdraid +
btrfs which then forces me in to the compromise of Raid10 where I can
suffer more drive failure but lose on btrfs' checksumming, or Raid01
where I'm more vulnerable to drive failure but I get to benefit from
the checksumming.

All this makes me ask why?  Why implement Raid10 in this non-standard
fashion and create this mess of compromise?  It's frustrating on the
user side and makes admins look at alternatives.  All this is because
I can't define what the mirrored pairs (or beyond in the future) are,
just to gain elegance in supporting different sized drives?  That can
be done at the stripe level, it doesn't need to be done at the mirror
level, and if it were done at the stripe level this issue wouldn't
exist.

> And what btrfs N-way-mirroring will provide, in the longer term once
> btrfs gets that feature and it stabilizes to usability, is the ability to
> actually have three cabinets, and sustain the loss of two, or four
> cabinets, and sustain the loss of three, etc.
>

I get it but this really isn't compelling.  This can't be done without
using a hybrid of mdraid + btrfs; I can already do this in a raid 1+0
arrangement I just don't benefit from checksumming.  All
N-way-mirroring is going to give me is the ability to do it in a 0+1
arrangement which means my filesystem made of 3 trays of 30 drives
total will be failed with just the failure of 1 drive in each tray and
that's not acceptable.
