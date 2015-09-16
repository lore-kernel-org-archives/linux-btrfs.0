Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48589 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbIPX3d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 19:29:33 -0400
Date: Wed, 16 Sep 2015 23:29:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Zia Nayamuth <zedestructor@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: FYIO: A rant about btrfs
Message-ID: <20150916232930.GD28645@carfax.org.uk>
References: <20150916144355.GA1285@invalid>
 <55F988A6.8070109@gmail.com>
 <55F997E9.8040401@gmail.com>
 <55F9BE3B.6070309@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veXX9dWIonWZEC6h"
In-Reply-To: <55F9BE3B.6070309@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--veXX9dWIonWZEC6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wed, Sep 16, 2015 at 03:08:43PM -0400, Austin S Hemmelgarn wrote:
> On 2015-09-16 12:25, Zia Nayamuth wrote:
> >Some response to your criticism:
> >
> >1. How would that hole fare with a fully battery-backed/flash-backed
> >path (battery-backed or flash-backed HBA with disks with full power-loss
> >protection, like the Intel S3500)? In such a situation (quite
> >commonplace in server-land), power-loss should not cause any data loss
> >since all data in the cache is guaranteed to be committed to
> >non-volatile memory at some point (whether such assurances may be
> >trusted is another matter entirely though, and well outside the scope of
> >this discussion).
> It's not as much of an issue if you have full power loss protection
> (assuming of course it works),

   "Power loss" is a shorthand for a number of issues, only one of
which is related to electrons ceasing to vibrate through the wires.
You can have a power-loss-like event when your kernel crashes hard. No
UPS will help you there.

> but even then having write-barriers
> turned off is still not as safe as having them turned on.  Most of
> the time when I've tried testing with 'nobarrier' (not just on BTRFS
> but on ext* as well), I had just as many issues with data loss when
> the system crashed as when it (simlated via killing the virtual
> machine) lost power.  Both journaling and COW filesystems need to
> ensure ordering of certain write operations to be able to maintain
> consistency.  For example, the new/updated data blocks need to be on
> disk before the metadata is updated to point to them, otherwise you
> database can end up corrupted.

   Indeed. The barriers are an ordering condition. The FS relies on
(i.e. *requires*) that ordering condition, in order to be truly
consistent. Running with "nobarrier" is a very strong signal that you
really don't care about the data on the FS. 

   This is not a case of me simply believing that because I've been
using btrfs for so long that I've got used to the peculiarities. The
first time I heard about the nobarrier option, something like 6 years
ago when I was first using btrfs, I thought "that's got to be a really
silly idea". Any complex data structure, like a filesystem, is going
to rely on some kind of ordering guarantees, somewhere in its
structure. (The ordering might be strict, with a global clock, or
barrier-based, or lattice-like, as for example a vector clock, but
there's going to be _some_ concept of order). nobarrier allows the FS
to ignore those guarantees, and even without knowing anything about
the FS at all, doing so is a big red DANGER flag.

   Hugo.

> >2. Fair point. I'd like to know his hardware, given how strongly
> >hardware can influence things.
> >
> >3. It's pretty obvious that the author of that blog is specifically
> >targeting OLTP performance (explicit statement in intro, choice of
> >benchmark, name and focus of blog), not common-case, and even states
> >that in the first two paragraphs of his conclusion. The focus is
> >somewhat less clear in said conclusion, namely, is he truly talking
> >about general purpose use or is he talking about general purpose OLTP use?
> >
> My takeaway was that he intended 'general purpose use' to mean
> generic every day usage across a wide variety of systems, he was not
> particularly specific about it however.

- -- 
Hugo Mills             | Our so-called leaders speak
hugo@... carfax.org.uk | with words they try to jail ya
http://carfax.org.uk/  | They subjugate the meek
PGP: E2AB1DE4          | but it's the rhetoric of failure.          The Police
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV+fswAAoJEFheFHXiqx3knD0QAJ0aBV6nE8npPF+daG0Nwdwi
U8ksTAxNYjJQPbwLVcoIDhBzuP/DD8yMBER/FaGuXDvOIOdaX05mffQblYLGc+bT
bze8nY9F0+5/5m2dGXiNyoouifHIZBtW+vaIipTqMwFU6I6IeOJIABIYeCxNmcm+
INcODG6rogCyRamJZGuSkZxnUe4GIu5yzHzPqnlXQ9PHVRa1IjYzAO17EMoBfHHo
bASoTQ7h1u1Kx3KqTnctgwKxBD1LdRNlZ/SeEmnAGrj6s8RPIYj2/nEtgjTLleU+
vGt2keIApk1mFPwayvxZdNBZhyuy4UrqGdXYVkmXYIJnoGshOulWr2Ntp83ZSw/f
pGHXubU7oHU+Lha7pKbDunTp8ktKlcyCKIU+3eyE2fhMozy0HChqR591uoGUtp3n
ylxchdl9GiUEsIpeZ7MLVEvfxHHob6Na18NuU3zLWtvMuch0+riWWWG8Wf73ql1b
JovCfdAAroowjWfThxApx4QT3Lz5c9K9JZsHeSNbvmPZz2kEsyXIBg7zVNMbKdcm
uqv8aMQxYMP6O8rrHXC6td8tizlLOKQVf8GNmAZS5BvfVSaPx5bbpDKYz6g87dRj
hbsAWwhIvWOE4S5/dhwKTinRXAJ+qNbeeASyGGXNgpa6afNzfAVErpFtte10SFuE
M3w+DYcbj1JEORvxvC3U
=LXO/
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV+ftaAAoJEFheFHXiqx3koIUP/A1vL0Mw8QFLf2tz8qefM7Vm
JRwntYTMpSJ8+UNaDEUl4s3AxBsXGrSDTb0w5ocPf1NSieEusJbFh8739ma8jKsk
kZPL7ZyXBIAuFmpm35EWDQDy8wlRNTXhTuXTg5OlYiIcjiUOk8CzhZJmMgz+gDLZ
lxWoHmk9vAktuajJ3p4cpF2/yf9QIaFAxmKjMK+Zm74Mc2Mj0lO4oZUwVzTKAWTl
JWhPAlMWYat7g5o1Z1V/HtLtebZxH+NAJHppENxNjJpye8SDeQrYRM7WP0vSPX7v
Ppdf2/+wPU1FTqWaEr01eoXOK9VNiL7vlfR3hzsXdjAi1uBdrNEGdj8BySZyZBZC
vSGGMxkJmHBbuppl80YPWQdzyIItNcqbaXSmsVvXtTNO565gLK/kakU1O2WWbZMW
e9eNt6UR7HaeO6IYMQc2K3ab/6vBq6flQI4Y1ZZCMP41a/1EtZTeNc6OSlJPRztA
K3IFsyNiZFVYLvfetX90+QXwfOCzWUPhzmhVQsYP3QhEFZe52a7DZQla0Irjq6X/
vGs+CvpFV10twSw+c7g7CRsWTzvdwWFWyOV3vucElwMsYhTbNd4FUH+lytOX3Hbz
eXV2sSsrwJPRiOxlQTzs84MiBh8RGab/ER0bSlHo+4VrAeSwXd3/rcFjgu9gZef7
8cxbD0iXcCBgDi/ltvpL
=YLkU
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h--
