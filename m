Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34338 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714AbaDJO6S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 10:58:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYGQh-0005zb-Oi
	for linux-btrfs@vger.kernel.org; Thu, 10 Apr 2014 16:58:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 16:58:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 16:58:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using noCow with snapshots ?
Date: Thu, 10 Apr 2014 14:58:04 +0000 (UTC)
Message-ID: <pan$9fcd4$1023a4e5$d241126e$285ca14@cox.net>
References: <1541415.olHfkWYf4R@zafu>
	<pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net> <3839313.LSaoXm11Qk@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Thu, 10 Apr 2014 10:22:15 +0200 as excerpted:

> Thanks Duncan for the perfect explanations.
> 
> From this, I understand that I might get both better performance by
> setting my akonadi dir to "nocow", and still be able to take a snapshot
> from time to time, which is exactly what I need.
> 
> Besides this, I'm still wondering about the changes in data security
> that turning a database to "NoCow" would bring, i.e. would the data
> still be well protected in case of a system crash or power failure ?
> 
> I have precious data in there and wouldn't like to jeopardize its
> security for a performance gain...

As eleftg suggests, the data integrity (and compression) features are 
turned off when something is set NOCOW, whether that "something" is an 
individual file or the whole subvolume (mounted with nodatacow).

However, that's not as bad a situation as one might initially think.  
Many of the applications that do routine internal-file-writes already 
have at least basic data integrity management of their own, as they've 
been more or less forced to in ordered to have any stability at all since 
filesystems traditionally do not have data integrity management of their 
own.  This being the case, they're already somewhat prepared to detect 
and do limited recovery from file corruption, perhaps losing the last 
couple transactions but preserving the data as a whole.

What can happen in the event of a crash is that btrfs and the application 
can both handle data integrity, but because they're implemented and work 
independently, with no knowledge of what the other one is doing, their 
restore efforts can "fight", such that the recovery snapshot that the app 
took internally and tries to recover with can be screwed up by btrfs 
trying to do its own recovery, due to timing differences between the two 
recovery mechanisms and btrfs restoring an image that's half from before 
the internal application snapshot and half after, such that were either 
mechanism to be used on its own, things would work, but the combination 
of the two independent mechanisms working on the same data is actually 
worse than either one alone.

This risk is compounded by delicate race/timing issues that develop in an 
ongoing incoming write stream scenario, where there's data commits in 
various stages of the pipeline at any particular point and strict 
ordering must be maintained so that new data doesn't get written to 
storage before the checksum for the old data is calculated and written to 
storage as well.  Normally, COW is designed to ensure all this is handled 
atomically, that either the old version or the new version is all there, 
not some combination of both such that the checksum doesn't match the mix 
of data that is actually in the file as it exists on-device, but NOCOW 
bypasses that mechanism and does rewrite-in-place, which dramatically 
complicates the ordering and timing issues related to getting everything 
written in the correct order so the checksum reflects the data that's 
actually there.

And of course if you have compression on, this complicates matters 
further with yet another step, plus since the new data probably 
compresses to a different size than the old, attempting to rewrite-in-
place is essentially impossible.

So turning both compression and datasum integrity checking off and 
bypassing both mechanisms entirely when nocow is set, really is the best 
choice, letting the application itself manage data integrity, or not, as 
it chooses based on what it considers the risk/value ratio of the data in 
question.


Tho based on my own experiences, I don't trust akonadi's data integrity 
management any farther than I could throw a multi-ton truck, which is to 
say not at all, which is why I switched to a different solution that 
seems to work far more reliably for me.

But that said, one thing the kmail and akonadi devs *DID* do right is 
that the original messages are still saved in the usual maildir format on-
device.  All the akonadi database does is cache that data in a form 
that's faster to use.  So in theory at least, if the database DOES get 
corrupted beyond recovery, it's only caching the data that's still on-
device as plain text files, and thus it's simple enough to simply delete 
and rebuild the caching database based on the still existing plain text 
files that contain the original data.

And actually, that was indeed my experience.  I don't think I ever 
actually lost data.  I just had to rebuild the cache more frequently than 
I thought I should, and that was a hassle I made an executive decision 
that I simply wasn't going to go thru any longer, since there were other 
alternatives that worked better for me, without that hassle.

So YMMV.  You appear to want to keep kmail and akonadi, and that's fine.  
But there are certain compromises that must be made in ordered to do so.  
As the saying goes, pick your poison.  You can either choose a filesystem 
other than btrfs to store the akonadi database on and deal with what it 
offers (generally standard rewrite-in-place and no filesystem-level-data-
integrity-management), or choose btrfs, with its other options.  If you 
choose btrfs, you can choose either the normal COW mode with its 
performance issues that go along with this type of usage, or one of the 
various NOCOW options.  If you take the NOCOW option, you can further 
choose to do snapshotting and accept the performance and fragmentation 
issues that brings altho they'll be somewhat less than with COW as long 
as you limit the snapshotting, or use a subvol for these files and don't 
snapshot it, instead doing conventional backups for it.

Here, if I were dealing with that type of file (either because I'd chosen 
to keep using akonadi or because something else I was using had the same 
access pattern), since I tend to use multi-partitioning more than most 
already, I'd probably simply use a dedicated partition for those files 
and make it something other than btrfs -- I'm familiar with reiserfs but 
for that use-case I'd probably try xfs.  If for some reason I didn't want 
to do the whole separate partition with its different filesystem thing, 
I'd use a dedicated btrfs subvolume for it, set the directory and files 
NOCOW, and do traditional backups rather than snapshotting for that 
subvolume.

But that's just me.  It's your system and priorities you have to deal 
with, so your choice.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

