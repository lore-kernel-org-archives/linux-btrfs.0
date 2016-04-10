Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41721 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbcDJGzW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 02:55:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ap9H7-0001RB-S3
	for linux-btrfs@vger.kernel.org; Sun, 10 Apr 2016 08:55:14 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 08:55:13 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 08:55:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 degraded does not mount or fsck
Date: Sun, 10 Apr 2016 06:55:05 +0000 (UTC)
Message-ID: <pan$aecbd$d6a08334$d380efdb$2697a184@cox.net>
References: <20160409224440.GC6768@gypsyops.denof.sin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Please keep your replies in standard quoted-context, then reply-in-
context, order.  I'm reordering here, but often either don't include 
complete context or simply don't bother replying, when it's too much work 
to get the reply in the proper context.]

Vladi Gergov posted on Sat, 09 Apr 2016 15:44:41 -0700 as excerpted:

> On Tuesday, 16.11.10 at 16:50, Chris Mason wrote:

>> Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:

[snip]

Wow, followups to old message threads!  A lot has changed since 2010!

>> Ok, I dug through this and found the bug responsible for your
>> unmountable FS.  When we're mounted in degraded mode, and we don't have
>> enough drives available to do raid1,10, we're can use the wrong raid
>> level for new allocations.
>> 
>> I'm fixing the kernel side so this doesn't happen anymore [...]

Interestingly that's still an issue, tho AFAIK now deliberate. [1] When 
mounted degraded-writable and there's not enough devices with free space 
to create new chunks of the appropriate raid type, btrfs will "degrade" 
to writing single-mode chunks.

While this does allow writing to continue, including either balances to 
change the raid level or btrfs replace or btrfs device add to again 
provide enough devices to properly handle the configured raid type, it 
usually results in a one-shot-writable bug, because once those single-
mode chunks are there, current kernels see single-mode on a filesystem 
missing devices and refuse to mount it degraded-writable again.  That 
means you get a one-time writable mount shot at correcting the problem, 
after which you won't be able to mount writable again (using current 
kernels) to correct it later, if the repair of the filesystem wasn't 
completed in that single degraded-writable mount.

You *can*, however, still mount degraded,read-only, which should give you 
access to the files to copy them elsewhere.

There are patches available that will change the chunks available check 
from per-filesystem to per-chunk.  With these patches applied, the kernel 
will allow degraded writable mounting of a nominally raidN filesystem 
with devices missing, even if there's single-mode chunks on the 
filesystem as well, *AS*LONG*AS* all chunks have at least one copy 
available.  What that means, in effect, is that as long as the degraded, 
writable filesystem doesn't lose ANOTHER device, this one with some of 
the single chunks already written to it, which would thus leave those 
chunks unavailable, it can mount a degraded filesystem writable more than 
once.

Unfortunately, those patches got added to a more complex patch set that 
wasn't considered ready for kernel 4.5 and didn't get into it.  I'm not 
sure whether they're in the current 4.6 development kernel or not.

But the patches ARE available.

> Anyone know if there is currently with updated kernel and tools a way to
> recover the data on this? I have tried btrfs chunk-recovery with not
> luck. Anything else I can do to try and get the data off at least?
> Thanks in advance!

As suggested above, if the only problem was a missing device, with 
anything approaching a current kernel (I'd suggest LTS 4.1 or 4.4 if 
you're conservative, 4.5 if you want the latest stable kernel series, and 
preferably a similarly versioned btrfs-progs userspace) you should at 
least be able to mount the filesystem degraded,ro.

A degraded,ro mount should be possible even if there are chunks entirely 
missing, as long as the superblocks and various other structures remain 
intact.

Or find and apply those patches and you *may* be able to mount the 
filesystem degraded,rw again, in ordered to replace the missing device 
and rebalance to normal operation.  However, this is a bit more iffy as 
it depends on no chunks being entirely missing, among other things, some 
of which may have changed since 2010, if you're still trying to recover 
that 2010 filesystem.


If the filesystem won't mount in degraded,ro or degraded,ro,recovery 
mode, then there's something wrong with it beyond the missing device.

In that case you may not be able to actually mount the filesystem (at 
least not without intensive surgery which the devs might be able to help 
you with but which is beyond my level as a simple sysadmin-level btrfs 
user and list regular)...

BUT THERE'S STILL HOPE to at least recover the files.

The tool you're looking for in that case is btrfs restore.

With luck you can simply point it at the remaining device and give it a 
place to restore the files to (and fill in options such as whether you 
want it to try to restore ownership/perms and other metadata, whether you 
want it to try to restore symlinks as well, etc), and it can do its 
thing.  There's a -D dry-run option you can use to see if it looks 
promising, before attempting to run it for real.

If restore on its own can't help, there's a more advanced mode that works 
in conjunction with btrfs-find-root, but fair warning, this gets rather 
technical and most people require some help to do it the first time, if 
they can manage it at all.  I won't go into detail here as there's a page 
on the wiki that describes the process, and there's another very recent 
on-list thread where I (and others) was working with someone else trying 
to do an advanced-mode btrfs-find-root and btrfs restore, and besides, 
with luck you won't need it anyway.  But here's the link to the wiki page 
and the thread in question, as found on gmane's web interface.

https://btrfs.wiki.kernel.org/index.php/Restore

http://thread.gmane.org/gmane.comp.file-systems.btrfs/55022

---
[1] C. Mason was working on patches to change it back then, but obviously 
it didn't work out as he then anticipated it would.  He'd have to fill in 
the specific details, but as I explained above, btrfs now requires a 
particular number of devices with writable unallocated space in ordered 
to allocate new chunks of the corresponding raid level, two devices for 
raid1, for instance.  If there's not enough devices with unallocated free 
space to create a new chunk in that raid mode, as explained, it falls 
back to single mode, which only requires a single device.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

