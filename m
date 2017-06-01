Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34787 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAOyz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 10:54:55 -0400
Received: by mail-pf0-f173.google.com with SMTP id 9so29385255pfj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 07:54:55 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Peganz <a.peganz@gmail.com>
Date: Thu, 1 Jun 2017 16:54:29 +0200
Message-ID: <CADtmLM88w-KH_SfoECB-N=PXwgvcswP6cyaBtypRHEEdPKZ1VA@mail.gmail.com>
Subject: understanding differences in recoverability of raid1 vs raid10 and
 performance implications of unusual numbers of devices
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am trying to understand what differences there are in using btrfs
raid1 vs raid10 in terms of recoverability and also performance.
This has proven itself to be more difficult than expected since all
search results I could come up with generally suffer from one of three
flaws: they either discuss terribly old versions of btrfs, only
discuss 4 disk settings, or are about traditional HW (or mdadm) RAID
modes.

>From what I gathered so far, with raid1 btrfs just puts the 2 copies
of a file on 2 different devices.
And raid10 splits files into stripes, then writes 2 copies of each
stripe to 2 different devices. By splitting the files into stripes it
can write stripe 1 to devices A and B, while at the same time writing
stripe 2 to devices C and D, and so on. So a single copy of a file
might end up split across all devices, as does the second, but with
the stripes distributed in a way that the copies of each one stripe
are never on the same device.

So my first question is: is that actually correct? Or does btrfs raid1
create copies of blocks or something akin to stripes instead of files?
Because I imagine if it is at the file level there is a difference in
recoverability if the "wrong" 2 devices die.
For a raid1 I'd expect to only loose those files whose copies were
located on those 2 devices. Every file with a copy on one of the still
working devices would be recoverable. So the more devices there are
the bigger the percentage of recoverable files could get.
While with raid10 the copies of every file's first stripe might end up
on device A and device B, damaging every single file if A and B die at
the same time.
This might just be a reason for me to choose raid1 over raid10, so I
really appreciate if someone could enlighten me ;)

As to performance, with raid1 write speed should (theoretically) be
the same as a single disk (although writing the first half of the data
to device A while at the same time writing the second half to device B
would allow to write the first copy in half the time, and would allow
to create the second copy at some later point in time I highly doubt
btrfs is quite that adventurous). And read speeds should be up to
twice that of a single device.
With raid10 write speeds should be N times those of a single disk to
create the first copy, and since of course a second one has to be
written as well, effectively up to N/2. Read speeds should be up to N
times that of a single disk. But I couldn't find useful comparisons
using more than 4 devices. Should I expect any weirdness if I don't
have a multiple of 4 devices? Or do I just need an even number of
devices? Or is everything ok, even odd numbers?

And finally, could using raid10 cause me more headache than raid1
farther down the line when adding additional devices? How about if
those devices are not the same size as the original ones, any
difference between raid1 and 10?

Thank you for your help!
Alexander
