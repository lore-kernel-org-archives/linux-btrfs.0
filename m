Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52584 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751090AbaLUQ1x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 11:27:53 -0500
Date: Sun, 21 Dec 2014 10:32:07 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141221163207.GA18988@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca>
 <54955624.5040808@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54955624.5040808@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Robert,

Thanks for the response.  Many of the things you mentioned I have tried, but
for completeness:

> Have you taken SMART (smartmotools etc) to these disks

Yes.  The disks are actually connected to a proper hardware RAID controller
that does SMART monitoring of all the disks, although I don't use the RAID
features of the controller.  By using mdadm, if the controller fails I can
slap the disks in another machine, or a different controller into this one,
and still have it work without needing to worry about getting a replacement
for this particular model of controller.

There are no errors or warnings from SMART for the disks.

> Try experimentally mounting the filesystem read-only

Actually, I'd already done that before I mailed the list.  It made no
difference to the symptoms.

> Have you changed any hardware lately in a way that could de-optimize
> your interrupt handling.

No.

> I have a vague recollection that somewhere in the last month and a
> half or so there was a patch here (or in the kernel changelogs)
> about an extra put operation (or something) that would cause a
> worker thread to roll over to -1, then spin back down to zero before
> work could proceed. I know, could I _be_ more vague? Right? Try
> switching to kernel 3.18.1 to see if the issue just goes away.

I tend to track linux-stable pretty closely (as that seems to be recommended
for btrfs use), so I already switched to 3.18.1 as soon as it came out.  That
made no difference to the symptoms either.

> When was the last time you did any of the maintenance things (like
> balance or defrag)? Not that I'd want to sit through 15Tb of that
> sort of thing, but I'm curious about the maintenance history.

I don't generally do those at all.  I was under the impression that balance
would not apply in my case as btrfs is on a single logical device, but I see
that I was wrong in that impression.  Is this something that is recommended on
a regular basis?  Most of the advice I've read regarding them is that it's no
longer necessary unless there is a particular problem that these will fix...

> Does the read performance fall off with uptime?

No.  I see these problems right from boot.

> I _imagine_ that if your filesystem huge and your server is modest by
> comparison in terms of ram, cache pinning and fragmentation can start
> becoming a real problem. What else besides marshaling this filesystem is
> this system used for?

This particular server is only used for holding backups of other machines,
nothing else.  It has far more CPU and memory (2x quad-core Xeon plus
hyperthreading, 16GB RAM) than it needs for this task.  So when I say the
machine is doing nothing other than this copy/rsync I'm currently running,
that's practically the literal truth - there are the normal system processes
and my ssh/shell running and that's about it.

> Have you tried segregating some of your system memory for to make
> sure that you aren't actually having application performance issues?

The system isn't running out of memory; as I say, about the only userspace
processes running are ssh, my shell, and rsync.

However, your first suggestion caused me to slap myself:

> Have you tried increasing the number of stripe buffers for the
> filesystem?

This I had totally forgotten.  When I bump up the stripe cache size, it
*seems* (so far, at least) to eliminate the slowest performance I'm seeing -
specifically, the periods I've been seeing where no I/O at all seems to
happen, plus the long runs of 1-3MB/s.  The copy is now staying pretty much in
the 22-27MB/s range.

That's not as fast as the hardware is capable of - as I say, with other
filesystems on the same hardware, I can easily see 100+MB/s - but it's much
better than it was.

Is this remaining difference (25 vs 100+ MB/s) simply due to btrfs not being
tuned for performance yet, or is there something else I'm probably
overlooking?

Thanks,

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
