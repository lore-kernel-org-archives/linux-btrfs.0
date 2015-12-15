Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36518 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbbLOOSQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 09:18:16 -0500
Date: Tue, 15 Dec 2015 14:18:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Message-ID: <20151215141813.GG26782@carfax.org.uk>
References: <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net>
 <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net>
 <566EC2D7.3000101@gmail.com>
 <CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
 <56701B79.8030105@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
In-Reply-To: <56701B79.8030105@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 15, 2015 at 08:54:01AM -0500, Austin S. Hemmelgarn wrote:
> On 2015-12-14 16:26, Chris Murphy wrote:
> >On Mon, Dec 14, 2015 at 6:23 AM, Austin S. Hemmelgarn
> ><ahferroin7@gmail.com> wrote:
> >>
> >>Agreed, if yo9u can't substantiate _why_ it's bad practice, then you aren't
> >>making a valid argument.  The fact that there is software that doesn't
> >>handle it well would say to me based on established practice that that
> >>software is what's broken, not common practice.
> >
> >The automobile is invented and due to the ensuing chaos, common
> >practice of doing whatever the F you wanted came to an end in favor of
> >rules of the road and traffic lights. I'm sure some people went
> >ballistic, but for the most part things were much better without the
> >brokenness or prior common practice.
> Except for one thing:  Automobiles actually provide a measurable
> significant benefit to society.  What specific benefit does
> embedding the filesystem UUID in the metadata actually provide?

   That one's easy to answer. It deals with a major issue that
reiserfs had: if you have a filesystem with another filesystem image
stored on it, reiserfsck could end up deciding that both the metadata
blocks of the main filesystem *and* the metadata blocks of the image
were part of the same FS (because they're on the same block device),
and so would splice both filesystems into one, generally complaining
loudly along the way that there was a lot of corruption present that
it was trying to fix.

   Putting the UUID of the FS into the metadata blocks means that the
kind of low-level check/repair attempt which scans for "stuff that
looks like metadata" can at least distinguish between the stuff that's
really metadata and the stuff that's just data that looks like
metadata.

   Hugo.

> >So the fact we're going to have this problem with all file systems
> >that incorporate the volume UUID into the metadata stream, tells me
> >that the very rudimentary common practice of using dd needs to go
> >away, in general practice. I've already said data recovery (including
> >forensics) and sticking drives away on a shelf could be reasonable.
> >
> >>The assumption that a UUID is actually unique is an inherently flawed one,
> >>because it depends both on the method of generation guaranteeing it's unique
> >>(and none of the defined methods guarantee that), and a distinct absence of
> >>malicious intent.
> >
> >http://www.ietf.org/rfc/rfc4122.txt
> >"A UUID is 128 bits long, and can guarantee uniqueness across space and time."
> >
> >Also see security considerations in section 6.
> Both aspects ignore the facts that:
> Version 1 is easy to cause a collision with (MAC addresses are by no
> means unique, and are easy to spoof, and so are timestamps).
> Version 2 is relatively easy to cause a collision with, because UID
> and GID numbers are a fixed size namespace.
> Version 3 is slightly better, but still not by any means unique
> because you just have to guess the seed string (or a collision for
> it).
> Version 4 is probably the hardest to get a collision with, but only
> if you are using a true RNG, and evne then, 122 bits of entropy is
> not much protection.
> Version 5 has the same issues as Version 3, but is more secure
> against hash collisions.
> 
> In general, you should only use UUID's when either:
> a. You have absolutely 100% complete control of the storage of them,
> such that you can guarantee they don't get reused.
> b. They can be guaranteed to be relatively unique for the system using them.
> >
> >
> >>On that note, why exactly is it better to make the filesystem UUID such an
> >>integral part of the filesystem?  The other thing I'm reading out of this
> >>all, is that by writing a total of 64 bytes to a specific location in a
> >>single disk in a multi-device BTRFS filesystem, you can make the whole
> >>filesystem fall apart, which is absolutely absurd.
> >
> >
> >OK maybe I'm  missing something.
> >
> >1. UUID is 128 bits. So where are you getting the additional 48 bytes from?
> >2. The volume UUID is in every superblock, which for all practical
> >purposes means at least two instances of that UUID per device.
> >
> >Are you saying the file system falls apart when changing just one of
> >those volume UUIDs in one superblock? And how does it fall apart? I'd
> >say all volume UUID instances (each superblock, on every device)
> >should be checked and if any of them mismatch then fail to mount.
> You're right, it would probably take writing all the SB's (although
> I'm not 100% certain that we actually check that the SB UUID's
> match).
> The extra bytes, which I grossly miscalculated, are for the SB
> checksum, which would have to be updated to match the new SB.
> >
> >There could be some leveraging of the device WWN, or absent that its
> >serial number, propogated into all of the volume's devices (cross
> >referencing each other's devid to WWN or serial). And then that way
> >there's a way to differentiate. In the dd case, there would be
> >mismatching real device WWN/serial number and the one written in
> >metadata on all drives, including the copy. This doesn't say what
> >policy should happen next, just that at least it's known there's a
> >mismatch.
> >
> That gets tricky too, because for example you have stuff like flat
> files used as filesystem images.
> 
> However, if we then use some separate UUID (possibly hashed off of
> the file location) in place of the device serial/WWN, that could
> theoretically provide some better protection.  The obvious solution
> in the case of a mismatch would be to refuse the mount until either
> the issue is fixed using the tools, or the user specifies some
> particular mount option to either fix ti automatically, or ignore
> copies with a mismatching serial.
> 

-- 
Hugo Mills             | I think that everything darkling says is actually a
hugo@... carfax.org.uk | joke. It's just that we haven't worked out most of
http://carfax.org.uk/  | them yet.
PGP: E2AB1DE4          |                                                Vashka

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWcCElAAoJEFheFHXiqx3kx2kP/3tO8YbedA5UOeuD56jqmkAd
9FRb7TekzZABHhmtNJJmQR9UC/S7iqXlAxGcEoXTBX/2NWrdYWaF9JqWDs+dRoe9
ES+Ry4V5/OZV/ZRPdgW5nLnGfnIGP3wiRMemce81HgFs1N7DDg+rTweXLXW84gAl
TQxmhKkahsYq/9a4YaIaqT3IuZsaFOJ6oVXQDtrjvzjLCMerZpbrTvL+f1bgujp2
6IO3CGYhpiV+6oDtf+BrfmB/9QL1tAl3w6Ra/cKEcKh6rbaR858wFfxWYlr/URNL
sQ3GGcHcLr0fUVQH5kdXJ5/6K6OVf8cvH/rwChr225KtY2Q3CSkUZxtmN6cVMoKc
zGPBY0y8W1nD+G1jdX07vI0vp6MdkFmSW4ykK8rDImFRiZraDx7E9l1G406m/jYL
eJefkUKrxcKvxfupfLxzUafwIMuNMxNLqMCfkN02xtqBAdJVm7TW94dUd0wEPu3i
lRjlYcdQAnPguzFotJ7KOs/L5BBdXM0qSiwLDxmLblkQGs5f4N45fBJeQCVzA9JE
iY1lLcucF05vCaqzSsXO6cxkse9dUOxceuuVxc4vkZ+AD6AwcRlLz8bkN1DfIXnW
QHyO/eMJYDLFuJIlUjZI4KqY6bfpdLyneNSORIV6c4uyAdRBms6y/kOoDMRGUGT5
6x6NVWq7jwkR14CVXpFi
=3SCh
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
