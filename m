Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42039 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdBDX4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 18:56:49 -0500
Date: Sat, 4 Feb 2017 23:56:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] python-btrfs: getting arch dependent ioctl handling right
Message-ID: <20170204235640.GB21899@carfax.org.uk>
References: <be2d182a-6b8e-158f-6653-611c1d1896d7@mendix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
In-Reply-To: <be2d182a-6b8e-158f-6653-611c1d1896d7@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 05, 2017 at 12:37:18AM +0100, Hans van Kranenburg wrote:
> Hi,
> 
> since I'd like to have my python btrfs library work correctly for users
> with other systems than amd64, I have been looking at IOCTL number
> generation a bit.
> 
> I just made something up in a branch, which follows the same way in
> which the IOC defines in kernel source are done:
> 
> https://github.com/knorrie/python-btrfs/commits/ioctl
> 
> The only other hardware than amd64 I have is a raspberry pi, which
> doesn't even seem to fall into the category having exceptions to the
> defaults...
> 
> So, my question is:
> 
> 1. am I still doing it wrong, or is this going into the right direction?
> 
> 2. can you please test this branch if you have access to any of 'alpha',
> 'mips', 'powerpc', 'sparc', 'parisc' which runs a btrfs filesystem and
> let me know if this makes it possible to use the library (e.g. run some
> examples from the examples/ dir)
> 
> 3. I also understand that there are difficulties for users who user 32
> bit userland with a 64 bit kernel.
>  - What is the exact technical reason for this?

   The usual problem with this configuration is that ioctl interfaces
are defined in terms of a C struct. The ioctl number uses the size of
the struct as part of its definition.

   The usual bug is that different bitnesses have different packing
rules, so

struct foo {
   u32 a;
   u64 b;
};

on 64-bit architectures is 16 bytes long. On 32-bit architectures,
it's 12 bytes. Since the length is different, those result in
different ioctl numbers in userspace and in the kernel, leading to
ioctl not found.

   Two approaches are available for dealing with this: either use the
"packed" attribute to prevent member alignment, so all architectures
have the same layout, or put in dummy members to ensure that
everything is aligned the way that 64-bit systems would do it.

>  - What's the general opinion about this usecase? (needs to work, or,
> "doctor, if I push here it hurts; well, don't push there"...)

   Definitely needs to work, but it's a rare use-case on most machines
(e.g. x86, arm, which covers the vast majority of machines out
there). sparc is the main one that I know of where a 64/32 system is
common; possibly mips as well. You will also find people running 64/32
systems on x86, but it's not normal.

   Hugo.

-- 
Hugo Mills             | Strive for apathy!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                      Andrew Zalotocky

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYlmo4AAoJEFheFHXiqx3kV1cQAIaofcZx1kUBt8mTsC8aUUCv
xGs34HE4T21Tsve+NqT+WGsOJ/khX6aE/tt9PN4a5Hmtzv2weeazo7TvSEvpGNJ6
Rg69vSY8uFFc645cfXezCdrETh/CtlbKmJvlmLa002CzbIw0L1XVUHwahTJ7f2pg
ujyt5cpRljs9cOYswMDRei2zdzFgaREYLwcMbkTE23TPTc4K9LgBdAOwGlCkD2Ff
rAfDtmrpqSrRiOkvn/3xtW9EYu26QOXfdlQBzcW3WGraosVsIQEgwovFkOLO8GGw
voGQl/7bSlpW9jWPY1OKM2AuXcbwTfTzTCS/0Yicpx8H7c78Wdonqx2j5ku5kAr1
gMquXSONGWpaGrQc30c0Ttbre3n7ToVGCHLQS7H5kqjaKvyZz9QUtuIHbrD1c9o4
jLZZ3rfHREUiBiUUzbz339QRUvQMzts6eqaHbe61RGzdVItjzKwg7nkgzbRmWchN
UhWf/XS8DQAQ1YGyHlbxAz0qRsPXMypis9YEYzailWTJNCfbCVfSEDmtZAky8c1u
qRgVMmridrGhk8WDOLHUvM3VC0UpqqLxtZQY51nd2AxEn1qTBT15FCd/fEOYVGvD
Y13KH+uGt5ot54zXkxtJZ9B4F6Q+y3745N/VrXhYvrwtFobYZKXrSk+but7Y+z5q
BiJuoLa5gbqXvduYjZx7
=1PAL
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
