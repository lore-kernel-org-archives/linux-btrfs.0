Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58892 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbbL1GMS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 01:12:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDR2V-0005oE-GD
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 07:12:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 07:12:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 07:12:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] improve documentation of snapshot unaware defrag
Date: Mon, 28 Dec 2015 06:12:09 +0000 (UTC)
Message-ID: <pan$9c6b5$324d66e6$f945a032$79f96239@cox.net>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
	<1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
	<pan$3bca9$74a60ba5$bf56792f$3c0040ca@cox.net>
	<1451263809.6320.9.camel@scientia.net>
	<pan$9c20a$2f693c09$f337c417$3719992c@cox.net>
	<1451271785.6320.47.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 28 Dec 2015 04:03:05 +0100 as
excerpted:

> On Mon, 2015-12-28 at 02:51 +0000, Duncan wrote:

>> 1) Btrfs very specifically and deliberately uses *lowercase* raidN in
>> part to make that distinction, as the btrfs variants are chunk- level
>> (and designed so that at some point in the future they can be subvolume
>> and/or file level), not device-level (and at that future point, not
>> necessarily filesystem level either).

> I guess no "normal" user would expect or understand that lower/upper
> case would imply any distinction.

I /could/ argue the case based on definition of the "normal" in "normal 
user", but I won't, as in any case I agree with you at least to the 
extent that a better explanation of the details should eventually be 
found both on the wiki (where it is arguably already covered in the 
sysadmin's and multiple devices pages) and in the btrfs-balance and 
mkfs.btrfs manpages (where it remains uncovered).

>> 2) Regarding btrfs raid1 and raid10's current very specific two-way-
>> mirroring in particular, limiting to two-way-mirroring in the 3+
>> devices case is well within established definitions and historic usage.
>> Apparently, the N-devices = N-way-mirroring usage is relatively new,
>> arguably first popularized by Linux mdraid, after which various
>> hardware raid suppliers also implemented it due to competitive
>> pressure.  But only two-way-mirroring is required by the RAID-1
>> definition.

> No, this is not true.
> 
> This http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf is
> the original paper on RAID.
> Chapter 7 describes RAID1 and the clearly says "all disks are
> duplicated" as well as "Level 1 RAID has only one data disk".

Kudos for digging up the reference. =:^)

Never-the-less, I (and others from which I got the position), believe 
your interpretation is arguably in error.  More precisely...

1) In the context of the Level 1 RAID discussed in chapter 7, from 
earlier in the paper, in chapter 6, introducing RAID, on page six of the 
paper which is page 8 of the PDF (quotes here between the >>>>> and <<<<< 
demarcs, [...] indicating elision, as traditional):

>>>>>

Reliability: Our basic approach will be to break the arrays into 
reliability groups, with each group having extra "check" disks containing 
redundant information. [...]

Here are some other terms that we use:

D = total number of disks with data (not including the extra check disks);

G = number of data disks in a group (not including the extra check disks);

[...]

C = number of check disks in a group;

<<<<<

That's the context, disks grouped for reliability, with data and check 
disks in a group, but multiple such groups.

Then later in the paper, in the First Level RAID discussion in chapter 7, 
starting on page 9 of the paper, page 11 of the pdf:

>>>>>

Mirrored disks are a traditional approach for improving reliability of 
magnetic disks.  This is the most expensive option since all disks are 
duplicated (G=1 and C=1), and every write to a data disk is also a write 
to a check disk.

<<<<<

With the definitions and context above, we see that the "(G=1 and C=1)" 
defines First Level RAID as exactly one data disk and one check disk in a 
reliability group, with multiple such groups.  So yes, it has "only one 
data disk"... in a defined context where that's per group, with exactly 
one check disk as well, with multiple groups, such that each write to a 
group writes to exactly one data disk and one check disk, but a full 
write may be to many groups.

This can be further seen by examining Table II on page 10 of the paper 
(12 of the pdf), where total number of disks is declared to be 2D (twice 
the number of data disks, based on the above definition of D), and usable 
storage capacity to be 50%.

Further, in the commentary on the same page, "Since a Level 1 RAID has 
only one data disk in its group, we assume that the large transfer 
requires the same number of disk acting in concert as found in groups of 
the higher level RAIDs: 10 to 25 disks."  Again, that emphasizes the per-
group aspect of the G=1, C=1 definition, and the fact that there's many 
such groups in the deployment.

Finally, "Duplicating all disks can mean doubling the cost of the 
database system or using only 50% of the disk storage capacity."  Again, 
very clearly pair-mirroring, with many such pair-mirrors in the array.

Which, other than the per-chunk rather than per-disk granularity, is 
_exactly_ what btrfs does.

It would actually seem that the N-way-mirroring, where N=number-of-
devices, usage of so-called raid1 is out of kilter with the original 
definition, not btrfs' very specific two-way-mirroring, regardless of the 
number of devices, which is actually very close to the original 
definition of two devices per groups, many such groups in an array.

Tho I'll certainly agree that in today's usage, RAID-1 certainly 
/incorporates/ the N-way-mirroring usage, and would even agree that, 
within my rather limited exposure at least, it's the more common usage.  
But that doesn't make it the original usage, nor does it mean that 
there's no room in today's broader definition for the original usage, 
which then must remain as valid as the broader usage, today.

So other than the per-chunk scope, btrfs raid1 would indeed seem to be 
real RAID-1.

Never-the-less, given the broader usage today, there's definitely a need 
for some word of explanation in the mkfs.btrfs and btrfs-balance 
manpages.  I'll agree there, but then I never disagreed with that in the 
first place, and indeed, that was my opinion from when I myself thought 
pair-mirroring wasn't proper raid1 -- that much hasn't changed.


Meanwhile, I've actually quoted about 50% of the original paper's raid1 
discussion in the above.  The Level 1 RAID discussion is actually quite 
short, under a double-spaced page in the original paper, which itself is 
only 26 pdf pages long, including two pages of title and blank page at 
the beginning (thus the pdf page numbering being two pages higher than 
the paper's page numbering), and two plus pages of acknowledgments, 
references and appendix at the end, so only 22 pages of well spaced 
actual content.  Those who haven't clicked thru to actually read it may 
be interested in doing so.  Here it is again for convenience. =:^)

http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf


> I wouldn't know any single case of a HW RAID controller (and we've had
> quite a few of them here at the Tier2) or other software implementation
> where RAID1 had another meaning than "N disks, N mirrors".

That may be.  I'm sure you have more experience with it than I do.  But 
that doesn't change the original definition, or mean that usage 
consistent with that original definition is incorrect, even if uncommon 
today.

>> Even were that not the case, point #1, btrfs' very specific use of
>> *lowercase* raid1, still covers the two-way-limitation case just as
>> well as it covers the chunk-level case.

> Hmm wouldn't still change anything, IMHO,... saying "lower case RAID is
> something different than upper case RAID" would be just a bit ... uhm...
> weird.
> 
> Actually, because btrfs doing it at the chunk level (while RAID being at
> the device level), proves while my point that "raid" or "RAID" or any
> other lower/upper case combination shouldn't be used at all.

I don't actually disagree with you there.  Weird it is, agreed.  But it's 
also the case, at least currently, and based on what Hugo said about a 
patch to change the terminology being in limbo for two years, during 
which the currently used terminology has become even more entrenched as 
btrfs is widely deployed in distro installations now (even if it isn't 
entirely stable yet), that it's unlikely to change.  The best that could 
be done at this point is make raid1 an alias for something else, but even 
then, I'd guess the raid1 terminology would continue pretty much 
unabated, since it's already widely used and well entrenched in the 
various google engines as well as the archives for this list.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

