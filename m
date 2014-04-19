Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38414 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaDSLXk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 07:23:40 -0400
Date: Sat, 19 Apr 2014 13:23:35 +0200
From: Xavier Bassery <xavier@bartica.org>
To: Michael Welsh Duggan <mwd@md5i.com>
Cc: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>
Subject: Re: Fixing a degraded RAID
Message-ID: <20140419132335.05c96c1f@renoir.lan>
In-Reply-To: <87ppkeato3.fsf@maru2.md5i.com>
References: <87y4z2avvz.fsf@maru2.md5i.com>
	<87ppkeato3.fsf@maru2.md5i.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Apr 2014 23:23:56 -0400
Michael Welsh Duggan <mwd@md5i.com> wrote:

> Michael Welsh Duggan <mwd@md5i.com> writes:
> 
> > I had a disk in my RAID0 die:
> 
> My mistake.  This was a stupid typo.  The drives were in a RAID 1
> configuration.  Both data and metadata are DUP'd.
> 
> root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi df /mnt/
> Data, RAID1: total=353.00GiB, used=328.24GiB
> System, single: total=32.00MiB, used=56.00KiB
> Metadata, RAID1: total=4.00GiB, used=1.43GiB
> 
> >   root@maru2:~# /usr/local/src/btrfs-progs/btrfs fi show
> > 8c530f6f-7592-4d57-854d-1fae33ae7cb6 Label: none  uuid:
> > 8c530f6f-7592-4d57-854d-1fae33ae7cb6 Total devices 3 FS bytes used
> > 329.66GiB devid    1 size 1.79TiB used 357.03GiB path /dev/sdd1
> >           devid    3 size 931.51GiB used 178.00GiB path /dev/sdf
> >           *** Some devices missing
> >   
> >   Btrfs v3.12-43-gc2081e2-dirty
> >
> > So, I try to mount it with -o degraded.  That fails, implying that a
> > degraded mount needs to be read-only.  So I successfully mount it
> > read only.  Then I want to add a new disk to replace the missing
> > one:
> >
> >   root@maru2:~# /usr/local/src/btrfs-progs/btrfs dev
> > add /dev/sdg /mnt/ ERROR: error adding the device '/dev/sdg' -
> > Read-only file system
> >
> > So I can't add a disk if it's mounted read-only, and can't mount it
> > read-write?  What am I missing?  What's my way around this?
> 

As Chris Murphy noted, your "System" chunk still reported as "single" is
likely the issue here.
This reminds me of a bug i stumbled upon once:
https://bugzilla.kernel.org/show_bug.cgi?id=60594

Have you converted your fs from SINGLE to RAID-1 profile by running a
balance?

This conversion bug should no longer occur with the patch
"Btrfs: stop refusing the relocation of chunk 0" which has been merged
since 3.12.
But chances are that you've converted your fs with an older kernel
without that patch.
While Ilya Dryomov investigated the issue on my system, we managed to
work around this by using a patched module that ignored the safety
measure refusing to mount rw in this case.

I still have the patch, but i think the safest way and only other
option would be to copy the data from your ro fs and recreate it from
scratch.
Doing so with recent btrfs progs (v3.12 or newer) you'll benefit from
the new default metadata blocksize of 16KB that should increase
performance.

Xavier Bassery






