Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh4.e.nsc.no ([193.213.121.75]:35061 "EHLO nmsh4.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030793AbbKFEPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 23:15:19 -0500
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
 <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
 <563A5251.70300@gmail.com> <pan$f33d7$d1be1dd2$81273c9e$505ff3bb@cox.net>
From: Zoiled <zoiled@online.no>
Message-ID: <563C1C2F.3030503@online.no>
Date: Fri, 6 Nov 2015 04:19:11 +0100
MIME-Version: 1.0
In-Reply-To: <pan$f33d7$d1be1dd2$81273c9e$505ff3bb@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 04 Nov 2015 13:45:37 -0500 as
> excerpted:
>
>> On 2015-11-04 13:01, Janos Toth F. wrote:
>>> But the worst part is that there are some ISO files which were
>>> seemingly copied without errors but their external checksums (the one
>>> which I can calculate with md5sum and compare to the one supplied by
>>> the publisher of the ISO file) don't match!
>>> Well... this, I cannot understand.
>>> How could these files become corrupt from a single disk failure? And
>>> more importantly: how could these files be copied without errors? Why
>>> didn't Btrfs gave a read error when the checksums didn't add up?
>> If you can prove that there was a checksum mismatch and BTRFS returned
>> invalid data instead of a read error or going to the other disk, then
>> that is a very serious bug that needs to be fixed.  You need to keep in
>> mind also however that it's completely possible that the data was bad
>> before you wrote it to the filesystem, and if that's the case, there's
>> nothing any filesystem can do to fix it for you.
> As Austin suggests, if btrfs is returning data, and you haven't turned
> off checksumming with nodatasum or nocow, then it's almost certainly
> returning the data it was given to write out in the first place.  Whether
> that data it was given to write out was correct, however, is an
> /entirely/ different matter.
>
> If ISOs are failing their external checksums, then something is going
> on.  Had you verified the external checksums when you first got the
> files?  That is, are you sure the files were correct as downloaded and/or
> ripped?
>
> Where were the ISOs stored between original procurement/validation and
> writing to btrfs?  Is it possible you still have some/all of them on that
> media?  Do they still external-checksum-verify there?
>
> Basically, assuming btrfs checksums are validating, there's three other
> likely possibilities for where the corruption could have come from before
> writing to btrfs.  Either the files were bad as downloaded or otherwise
> procured -- which is why I asked whether you verified them upon receipt
> -- or you have memory that's going bad, or your temporary storage is
> going bad, before the files ever got written to btrfs.
>
> The memory going bad is a particularly worrying possibility,
> considering...
>
>>> Now I am really considering to move from Linux to Windows and from
>>> Btrfs RAID-5 to Storage Spaces RAID-1 + ReFS (the only limitation is
>>> that ReFS is only "self-healing" on RAID-1, not RAID-5, so I need a new
>>> motherboard with more native SATA connectors and an extra HDD). That
>>> one seemed to actually do what it promises (abort any read operations
>>> upon checksum errors [which always happens seamlessly on every read]
>>> but look at the redundant data first and seamlessly "self-heal" if
>>> possible). The only thing which made Btrfs to look as a better
>>> alternative was the RAID-5 support. But I recently experienced two
>>> cases of 1 drive failing of 3 and it always tuned out as a smaller or
>>> bigger disaster (completely lost data or inconsistent data).
>> Have you considered looking into ZFS?  I hate to suggest it as an
>> alternative to BTRFS, but it's a much more mature and well tested
>> technology than ReFS, and has many of the same features as BTRFS (and
>> even has the option for triple parity instead of the double you get with
>> RAID6).  If you do consider ZFS, make a point to look at FreeBSD in
>> addition to the Linux version, the BSD one was a much better written
>> port of the original Solaris drivers, and has better performance in many
>> cases (and as much as I hate to admit it, BSD is way more reliable than
>> Linux in most use cases).
>>
>> You should also seriously consider whether the convenience of having a
>> filesystem that fixes internal errors itself with no user intervention
>> is worth the risk of it corrupting your data.  Returning correct data
>> whenever possible is one thing, being 'self-healing' is completely
>> different.  When you start talking about things that automatically fix
>> internal errors without user intervention is when most seasoned system
>> administrators start to get really nervous.  Self correcting systems
>> have just as much chance to make things worse as they do to make things
>> better, and most of them depend on the underlying hardware working
>> correctly to actually provide any guarantee of reliability.
> I too would point you at ZFS, but there's one VERY BIG caveat, and one
> related smaller one!
>
> The people who have a lot of ZFS experience say it's generally quite
> reliable, but gobs of **RELIABLE** memory are *absolutely* *critical*!
> The self-healing works well, *PROVIDED* memory isn't producing errors.
> Absolutely reliable memory is in fact *so* critical, that running ZFS on
> non-ECC memory is severely discouraged as a very real risk to your data.
>
> Which is why the above hints that your memory may be bad are so
> worrying.  Don't even *THINK* about ZFS, particularly its self-healing
> features, if you're not absolutely sure your memory is 100% reliable,
> because apparently, based on the comment's I've seen, if it's not, you
> WILL have data loss, likely far worse than btrfs under similar
> circumstances, because when btrfs detects a checksum error it tries
> another copy if it has one (raid1/10 mode), and simply fails the read if
> it doesn't, while apparently, zfs with self-healing activated will give
> you what it thinks is the corrected data, writing it back to repair the
> problem as well, but if memory is bad, it'll be self-damaging instead of
> self-healing, and from what I've read, that's actually a reasonably
> common experience with non-ecc RAM, the reason they so severely
> discourage attempts to run zfs on non-ecc.  But people still keep doing
> it, and still keep getting burned as a result.
>
> (The smaller, in context, caveat, is that zfs works best with /lots/ of
> RAM, particularly when run on Linux, since it is designed to work with a
> different cache system than Linux uses, and won't work without it, so in
> effect with ZFS on Linux everything must be cached twice, upping the
> memory requirements dramatically.)
>
>
> (Tho I should mention, while not on zfs, I've actually had my own
> problems with ECC RAM too.  In my case, the RAM was certified to run at
> speeds faster than it was actually reliable at, such that actually stored
> data, what the ECC protects, was fine, the data was actually getting
> damaged in transit to/from the RAM.  On a lightly loaded system, such as
> one running many memory tests or under normal desktop usage conditions,
> the RAM was generally fine, no problems.  But on a heavily loaded system,
> such as when doing parallel builds (I run gentoo, which builds from
> sources in ordered to get the higher level of option flexibility that
> comes only when you can toggle build-time options), I'd often have memory
> faults and my builds would fail.
>
> The most common failure, BTW, was on tarball decompression, bunzip2 or
> the like, since the tarballs contained checksums that were verified on
> data decompression, and often they'd fail to verify.
>
> Once I updated the BIOS to one that would let me set the memory speed
> instead of using the speed the modules themselves reported, and I
> declocked the memory just one notch (this was DDR1, IIRC I declocked from
> the PC3200 it was rated, to PC3000 speeds), not only was the memory then
> 100% reliable, but I could and did actually reduce the number of wait-
> states for various operations, and it was STILL 100% reliable.  It simply
> couldn't handle the raw speeds it was certified to run, is all, tho it
> did handle it well enough, enough of the time, to make the problem far
> more difficult to diagnose and confirm than it would have been had the
> problem appeared at low load as well.
>
> As it happens, I was running reiserfs at the time, and it handled both
> that hardware issue, and a number of others I've had, far better than I'd
> have expected of /any/ filesystem, when the memory feeding it is simply
> not reliable.  Reiserfs metadata, in particular, seems incredibly
> resilient in the face of hardware issues, and I lost far less data than I
> might have expected, tho without checksums and with bad memory, I imagine
> I had occasional undetected bitflip corruption in files here or there,
> but generally nothing I detected.  I still use reiserfs on my spinning
> rust today, but it's not well suited to SSD, which is where I run btrfs.
>
> But the point for this discussion is that just because it's ECC RAM
> doesn't mean you can't have memory related errors, just that if you do,
> they're likely to be different errors, "transit errors", that will tend
> to be undetected by many memory checkers, at least the ones that don't
> tend to run full out memory bandwidth if they're simply checking that
> what was stored in a cell can be read back, unchanged.)
>
I just want to point out that please don't forget about your harddrive 
controlers memory. You mainboard might have ECC ram but your controller 
might not.
