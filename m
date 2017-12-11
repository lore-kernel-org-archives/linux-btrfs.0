Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41215 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdLKCHC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 21:07:02 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eODUa-0006ZI-44
        for linux-btrfs@vger.kernel.org; Mon, 11 Dec 2017 03:06:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: failed to repair root items: Input/output error
Date: Mon, 11 Dec 2017 02:06:46 +0000 (UTC)
Message-ID: <pan$1a99b$28ccada6$22edff6b$9a443957@cox.net>
References: <CANcfdL3LFXYFcr-qJDNhEvCttc3yEKKWY53aun0eC_gF0CXrrw@mail.gmail.com>
        <20171210153804.GA32313@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Sun, 10 Dec 2017 16:38:05 +0100 as excerpted:

> On Sun, Dec 10, 2017 at 15:18:32 +0000, constantine wrote:
> 
>> I have a laptop root hard drive (Samsung SSD 850 EVO 1TB), which is
>> within warranty.
>> I can't mount it read-write ("no rw mounting  after error").
> 
> There is a data-corruption issue with this controller!
> The same as 840 EVO - just google this.

That's a bit alarmist...

It's not a problem with recent kernels (I too have a Samsung 850
EVO 1 TB), as you mention below.  Given the focus of this list, btrfs,
and the fact that btrfs is still stabilizing, not yet fully stable and
mature, so reasonably new kernels are strongly recommended (with the
second newest mainline-LTS kernel series, now 4.9 since 4.14 is LTS,
being the oldest recommended)...

Anyone already following btrfs-list kernel recommendations is already
/well/ beyond the kernel versions you mention below as adding the
blacklisting, so it shouldn't be a problem.

And he mentions Ubuntu with kernel 4.13, so he's at least well beyond
the problem kernels now, tho of course it's possible he was running
an older one previously, and that's what did the damage.

> In short: either use recent kernel (AFAIR 4.0.5+ for 840 EVO and some
> newer for entire 8* Samsung SSD family blacklisting) or disable NCQ.
> 
> Using queued TRIM on this drive leads to data loss! Firmware zeroes
> fist 512 bytes of a block, sorry.
> 
> If you only had smaller drive, as 850s up to 512 GB have different
> controller...
> 
>> checksum verify failed on 103009173504 found 25334496 wanted 00003500
>> bytenr mismatch, want=103009173504, have=889192478
>> ERROR: failed to repair root items: Input/output error
>> 
>> What do these errors mean?
>> What should I do to fix the filesystem and be able to mount it
>> read-write?
> 
> You probably can't fix this - there is data missing on bare metal, so
> you should recover using backups. If you don't have one, you need to
> perform manual data recovery procedures (like photorec) with little
> chances to restore complete files due to the nature of data loss
> (beginning of blocks).

I'll agree here.  First sysadmin rule of backups.  The value of your
data is defined not by empty claims, but by the number of backups you
consider it worth having of that data.  No backups simply defines the
data as of only trivial value, worth less than the time, trouble and
resources necessary to make that backup.

So in the event of loss of the working copy, you can always rest easy.
Either there was a backup and recovery can proceed from it, or there
wasn't, in which case you can still be happy, since after all you still
saved what was self-evidently more important than that data, the time,
trouble and resources you'd have put into backing it up if it /were/
worth it.


Meanwhile, apparently the filesystem can still be mounted read-only,
just not read-write, so the first thing I'd do would be to mount it
read-only and see how much of the data I can successfully copy off
to some other filesystem.  With a bit of luck, only a few files are
damaged and will need restored from backup (assuming they were
valuable enough to have a backup, of course), while the rest are
fine.

If that's /not/ the case, and the filesystem won't mount read-only
either, or there's too much damaged, then it's time to try
btrfs restore, to try to restore some of the files to some other
location.  Tho note that btrfs restore is an effort at recovery,
and as such, it doesn't verify checksums as normal btrfs file
operations will, so some of the otherwise successfully restored
files may still be bitrotted.  (Tho most filesystems don't checksum
in any case, so the danger of bitrot is no worse than using a normal
filesystem that doesn't do checksumming anyway.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

