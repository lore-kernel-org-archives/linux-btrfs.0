Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35124 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbbKDSBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2015 13:01:18 -0500
Received: by wmll128 with SMTP id l128so121098102wml.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2015 10:01:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
Date: Wed, 4 Nov 2015 19:01:16 +0100
Message-ID: <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well. Now I am really confused about Btrfs RAID-5!

So, I replaced all SATA cables (which are explicitly marked for beeing
aimed at SATA3 speeds) and all the 3x2Tb WD Red 2.0 drives with 3x4Tb
Seagate Contellation ES 3 drives and started from sratch. I
secure-erased every drives, created an empty filesystem and ran a
"long" SMART self-test on all drivers before I started using the
storage space (the tests finished without errors, all drivers looked
fine, 0 zero bad sectors, 0 read or SATA CEC errors... all looked
perfectly fine at the time...).

It didn't take long before I realized that one of the new drives
started failing.
I started a scrub and it reported both corrected and uncorrectable errors.
I looked at the SMART data. 2 drives look perfectly fine and 1 drive
seems to be really sick. The latter one has some "reallocated" and
several hundreds of "pending" sectors among other error indications in
the log. I guess it's not the drive surface but the HDD controller (or
may be a head) which is really dying.

I figured the uncorrectable errors are write errors which is not
surprising given the perceived "health" of the drive according to it's
SMART attributes and error logs. That's understandable.


Although, I tried to copy data from the filesystem and it failed at
various ways.
There was a file which couldn't be copied at all. Good question why. I
guess it's because the filesystem needs to be repaired to get the
checksums and parities sorted out first. That's also understandable
(though unexpected, I thought RAID-5 Btrfs is sort-of "self-healing"
in these situations, it should theoretically still be able to
reconstruct and present the correct data, based on checksums and
parities seamlessly and only place error in the kernel log...).

But the worst part is that there are some ISO files which were
seemingly copied without errors but their external checksums (the one
which I can calculate with md5sum and compare to the one supplied by
the publisher of the ISO file) don't match!
Well... this, I cannot understand.
How could these files become corrupt from a single disk failure? And
more importantly: how could these files be copied without errors? Why
didn't Btrfs gave a read error when the checksums didn't add up?


Isn't Btrfs supposed to constantly check the integrity of the file
data during any normal read operations and give an error instead of
spitting out corrupt data as if it was perfectly legit?
I thought that's how it is supposed to work.
What's the point of full data checksuming if only an explicitly
requested scrub operation might look for errors? I thought's it's the
logical thing to do if checksum verification happens during every
single read operation and passing that check is mandatory in order to
get any data out of the filesystem (might be excluding the Direct-I/O
mode but I never use that on Btrfs - if that's even actually
supported, I don't know).


Now I am really considering to move from Linux to Windows and from
Btrfs RAID-5 to Storage Spaces RAID-1 + ReFS (the only limitation is
that ReFS is only "self-healing" on RAID-1, not RAID-5, so I need a
new motherboard with more native SATA connectors and an extra HDD).
That one seemed to actually do what it promises (abort any read
operations upon checksum errors [which always happens seamlessly on
every read] but look at the redundant data first and seamlessly
"self-heal" if possible). The only thing which made Btrfs to look as a
better alternative was the RAID-5 support. But I recently experienced
two cases of 1 drive failing of 3 and it always tuned out as a smaller
or bigger disaster (completely lost data or inconsistent data).


Does anybody have ideas what might went wrong in this second scenario?
