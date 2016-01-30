Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34748 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbcA3VTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 16:19:45 -0500
Received: by mail-lb0-f177.google.com with SMTP id cl12so57218969lbc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 13:19:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
 <CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
From: Christian Pernegger <pernegger@gmail.com>
Date: Sat, 30 Jan 2016 22:19:04 +0100
Message-ID: <CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 January 2016 at 21:10, Henk Slager <eye1tm@gmail.com> wrote:
> Can you mount the fs (readonly)?

No idea, it's still mounted (rw even), aside from the scrub failing
and debug-tree crashing I wouldn't know anything was amiss. I was kind
of reluctant to shut the machine down lest it then wouldn't come up at
all.

>  unmount and run a   btrfs check -p /dev/mapper/sda3_crypt

That would mean shutting it down and booting from a rescue image on
USB (any suggestions for something with a recent kernel and progs?).
That's fine of course, if there's nothing more to be gleaned from the
running system.

> I think there is a relation between the many ata2 messages and this
> scrub failure.

There's exactly one of these errors on every resume from suspend, I'd
assumed it's just the disk being slow to wake up. Even if they aren't
benign, I made sure beforehand that the box did not sleep during the
scrub and according to the logs it didn't.
Suspend-resume and/or systemd are still likely culprits of course.

> You can use brute-force rsync -c (and more, see manpage) to validate your
> data, assuming your sourcedata isn't on btrfs.

The data that I can verify, i.e. where the source machines still have
the version from the current backup, checks out.

> A workaround might be to disable PM for the system,

The system's supposed to wake up once daily (nightly), pull in
rdiff-backups from a few others and go back to sleep 20 min later.
Keeping it awake 24/7 is a no-go noise and cost-wise. (For testing /
debugging, sure, just not in the long run.)

> An an obvious advice is to use a 4.4 kernel and tools. Debian 'stable' doesn't mean
> that every piece of the kernel and tooling fits that 'stamp'. [...] Maybe you could switch
> to a rolling release linux distro or just update the debian kernel.

Using Debian stable usally means that once something is set up and
works it keeps working until the hardware dies with little to no user
interaction. For someting that sits in a corner and pulls in backups
that suits me just fine. If there's a specific reason to update the
kernel and btrfs-progs, it's easily done of course, but "let's hope it
has gone away with the newer version" doesn't inspire me with
confidence on its own.

> But the more fundamental question is why you use btrfs? What features
> do you need that ext4 or xfs or reiserfs don't have?

Data checksumming. I don't mind a bit flipping here or there in old
backups / archives but I'd have liked to know if something went bad
and which files were affected. Compression. Dedup that works on mortal
hardware. To a lesser degree, subvolumes.
Also I wanted to get familiar with the next big thing in Linux file
systems. :-) My bigger boxes use md + dm-crypt + lvm + manual
checksumming and the moment I can replace that (or part of it) with
something integrated, I will. Once the resilience and fault tolerance
is there. (The other day md-raid10 was so unfazed by what must have
been a disk with a half-dead controller that it took me half a day to
find out which one it was ...)
I was fully aware that I might run into trouble, I just didn't expect
it to take less than a month and/or happen without provocation.



The current install is expendable, even though it irks me to have to
redo it (I didn't backup that, wanted to get it just right first), but
I'd really like to find and fix the problem before I do, otherwise I
might be back to square one in a month or so ...

Cheers,
C.
