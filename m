Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f42.google.com ([209.85.216.42]:40493 "EHLO
	mail-vn0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbbGAX3h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 19:29:37 -0400
Received: by vnbg1 with SMTP id g1so8392906vnb.7
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 16:29:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
	<CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
	<CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
	<CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
	<CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
Date: Wed, 1 Jul 2015 17:29:36 -0600
Message-ID: <CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 1, 2015 at 3:35 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:

> *** Error in `./btrfs': free(): invalid next size (fast): 0x0000000001332100 ***
> Segmentation fault

Blek. Well that's a bug then too. If you have space somewhere to put a
btrfs-image -c9 -t4, I'd do that now before making anymore changes.
Write up a bugzilla.kernel.org bug, include the URL for the image file
(which will be large). Include the URL for the bug in this thread. And
then it's wait time basically. I'm not a dev but this sounds rather
serious.

The pisser is that this is exactly the use case for raid6. You have a
failed drive, want an extra margin to cover possible additional
errors, you get a "BTRFS: failed to read chunk root on sdc" which
could be construed as a problem with sdc, so a 2nd failure, and yet no
reconstruction of the necessary metadata.

Is metadata also raid6? Or just data? I don't see a 'btrfs fi df'
probably because you can't mount the volume. Do you know if it was
created with -d raid6 -m raid6 at mkfs time? (Include this info in the
bug report.)

Failing device handling with Btrfs is still weak. In many cases it
will keep trying to use a device that produces spurious or even failed
read and write errors. It's possible this caused some confusion.

I propose trying the following. You could wait to see if someone else
has better suggestions, but this seems reasonably safe.

- Physically remove sdg from the system, reboot, and see if you can
mount the volume with the most conservative mount option: -o
ro,recovery,degraded,skip_balance

If that doesn't work, and you still get the message about chunk root
on devid 1/sdc (thing is, when you remove sdg it's possible drive
letters will change, so be sure to correlate any errors to devid by
using a current 'btrfs fi show' listing), then yuck.

I would try chunk recover again, now that known bad drive sdg is
physically removed. Do you get a different result, or still a seg
fault?

If those two things still fail, what's next is a toss up between two options:

- Find or build a "4.2" kernel (there is no rc1 yet); Fedora has
several "4.2"/linux-next binaries already built in the koji build
system, so your distro might have extremely new kernels available
somewhere for bleeding edgers. Try this with the above mount options
again. In the recent git pull for this kernel there were nearly 2000
lines added, and nearly that many deleted. A lot of changes. So it's
worth a shot. It could produce a good result or a worse result, or the
same result. *shrug* What I probably wouldn't try while running the
4.2 kernel is another chunk recover. Seems doubtful it will make much
difference.

and the other option:

- Physically remove the device that still produces the "BTRFS: failed
to read chunk root on sdX" error, which in the current state as you
posted it, was /dev/sdc (devid 1). Physically remove it. Reboot. And
then retry the same mount options from above and see what that results
in. If there were no problems with your file system, removing two
devices and mounting degraded should work without errors (I've done
it), so it seems like a valid thing to try seeing as two devices are
giving you a hard time. Will a 3rd? Dunno.

Anyway, not good news. But you're helping make Btrfs better!



-- 
Chris Murphy
