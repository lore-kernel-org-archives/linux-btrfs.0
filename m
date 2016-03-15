Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:39781
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbcCOW3a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 18:29:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2FMT63I018946
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 22:29:06 GMT
Subject: Re: Snapshots slowing system
To: linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
From: Peter Chant <pete@petezilla.co.uk>
Message-ID: <56E88CB2.6020300@petezilla.co.uk>
Date: Tue, 15 Mar 2016 22:29:06 +0000
MIME-Version: 1.0
In-Reply-To: <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/15/2016 03:52 PM, Duncan wrote:

<snip>

> Meanwhile, FWIW, some months ago I finally got tired of having to specify 
> noatime on all my mounts, expanding my fstab width by 8 chars (including 
> the ,) and the total fstab character count by several multiples of that 
> as I added it to all entries, and decided to see if I might per chance, 
> even as a sysadmin not a dev, be able to come up with a patch that 
> changed the kernel default to noatime.  It wasn't actually hard, tho were 
> I a coder and actually knew what I was doing, I imagine I could create a 
> much better patch.  So now all my filesystems (barring a few of the 
> memory-only virtual-filesystem mounts) are mounted noatime by default, as 
> opposed to the unpatched relatime, and I was able to take all the noatimes 
> out of my fstab. =:^)

It is a pity you cannot use variables or macros in fstab.  Its not too
bad with traditional file systems on my home user machine but with
multiple subvolumes my fstab is huge and there is a lot of repetition
of the options.



>> Hmm.  A bit tight.  I've just ordered a replacement SSD.
> 
> While ~8 GiB unallocated on a ~118 GiB filesystem is indeed a bit tight, 
> it's nothing that should be giving btrfs fits yet.
> 

Too late, drive ordered.  It was only a matter of time anyway.


> Tho even with autodefrag, given the previous relatime and snapshotting, 
> it could be that the free-space in existing chunks is fragmented, which 
> over time and continued usage would force higher file fragmentation 
> despite the autodefrag, since there simply aren't any large contiguous 
> free-space areas left in which to write files.
>

Hmm. The following returns instantly as if it were a null operation.
btrfs fi defrag /

I thought though that btrfs fi defrag <name> would only defrag the one
file or directory?

btrfs fi defrag /srv/photos/
Is considerably slower, it is still running.  Disk light is on solid.
Processes kworker and btrfs-transacti are pretty busy according to iotop.

<snip>


> But either way, given the LZO compression it appears I've used under half 
> the 8 GiB capacity.  Meanwhile, du -xBM / says 4158M, so just over half 
> in uncompressed data  (with --apparent-size added it says 3624M).
> 

I seem to install a lot of interesting looking things I barely use.  I
am surprised about how full the filesystem gets, it should not.
However, large disks make life much easier rather than routing out
unused packages as a hobby.  Unless it gets silly.


<snip>
> 
> Boot is an exception to the usual btrfs raid1, with a separate working 
> boot partition on one device and its backup on the other, so I can point 
> the BIOS at and boot either one.  It's btrfs mixed-bg mode dup, 256 MiB 
> for each of working and backup, which because it's dup means 128 MiB 
> capacity.  That's actually a bit small, and why I'll be shrinking the log 
> partition the next time I repartition.  Making it 384 MiB dup, for 192 
> MiB capacity, would be much better, and since I can shrink the log 
> partition by that and still keep the main partitions GiB aligned, it all 
> works out.
> 

Slackware uses lilo so I need a separate /boot with something that is
supported by lilo.

<snip>

> If I had 500 GiB SSDs like the one you're getting, I could put the media 
> partition on SSDs and be rid of the spinning rust entirely.  But I seem 
> to keep finding higher priorities for the money I'd spend on a pair of 
> them...


I'm getting one, not two, so the system is raid0.  Data is more
important (and backed up).

> 
<snip>

> Good point.  Similar here except the backup/maintenance isn't a cutdown 
> system, it's a snapshot (in time, not btrfs snapshot) of exactly what was 
> on the system when I did the backup.  That way, should it be necessary, I 
> can boot the backup and have a fully functional system exactly as it was 
> the day I took that backup.  That's very nice to have for a maintenance 
> setup, since it means I have access to full manpages, even a full X, 
> media players, a full graphical browser to google my problems with, etc.
> 
I have that as well.  But the non-btrfs maintenance partition is there
in case btrfs is unbootable.

-- 
Peter Chant
