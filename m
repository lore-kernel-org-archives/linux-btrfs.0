Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58344 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaKZSfl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 13:35:41 -0500
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MHoWj-1Xv3oc000D-003i4f for
 <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 19:35:39 +0100
Date: Wed, 26 Nov 2014 19:35:27 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Two persistent problems
Message-ID: <20141126193527.5f5a09c6@marcec.fritz.box>
In-Reply-To: <54667B7A.8050704@fb.com>
References: <20141114215159.GA32735@carfax.org.uk>
 <54667B7A.8050704@fb.com>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LQGTdWVAwD3E1cRTFrMxj64"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LQGTdWVAwD3E1cRTFrMxj64
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Fri, 14 Nov 2014 17:00:26 -0500
schrieb Josef Bacik <jbacik@fb.com>:

> On 11/14/2014 04:51 PM, Hugo Mills wrote:
> >     Chris, Josef, anyone else who's interested,
> >
> >     On IRC, I've been seeing reports of two persistent unsolved
> > problems. Neither is showing up very often, but both have turned up
> > often enough to indicate that there's something specific going on
> > worthy of investigation.
> >
> >     One of them is definitely a btrfs problem. The other may be btrfs,
> > or something in the block layer, or just broken hardware; it's hard to
> > tell from where I sit.
> >
> > Problem 1: ENOSPC on balance
> >
> >     This has been going on since about March this year. I can
> > reasonably certainly recall 8-10 cases, possibly a number more. When
> > running a balance, the operation fails with ENOSPC when there's plenty
> > of space remaining unallocated. This happens on full balance, filtered
> > balance, and device delete. Other than the ENOSPC on balance, the FS
> > seems to work OK. It seems to be more prevalent on filesystems
> > converted from ext*. The first few or more reports of this didn't make
> > it to bugzilla, but a few of them since then have gone in.
> >
> > Problem 2: Unexplained zeroes
> >
> >     Failure to mount. Transid failure, "expected xyz, have 0". Chris
> > looked at an early one of these (for Ke, on IRC) back in September
> > (the 27th -- sadly, the public IRC logs aren't there for it, but I can
> > supply a copy of the private log). He rapidly came to the conclusion
> > that it was something bad going on with TRIM, replacing some blocks
> > with zeroes. Since then, I've seen a bunch of these coming past on
> > IRC. It seems to be a 3.17 thing. I can successfully predict the
> > presence of an SSD and -odiscard from the "have 0". I've successfully
> > persuaded several people to put this into bugzilla and capture
> > btrfs-images.  btrfs recover doesn't generally seem to be helpful in
> > recovering data.
> >
> >
> >     I think Josef had problem 1 in his sights, but I don't know if
> > additional images or reports are helpful at this point. For problem 2,
> > there's obviously something bad going on, but there's not much else to
> > go on -- and the inability to recover data isn't good.
> >
> >     For each of these, what more information should I be trying to
> > collect from any future reporters?
> >
> >
>=20
> So for #2 I've been looking at that the last two weeks.  I'm always=20
> paranoid we're screwing up one of our data integrity sort of things,=20
> either not waiting on IO to complete properly or something like that.=20
> I've built a dm target to be as evil as possible and have been running=20
> it trying to make bad things happen.  I got slightly side tracked since=20
> my stress test exposed a bug in the tree log stuff an csums which I just=
=20
> fixed.  Now that I've fixed that I'm going back to try and make the=20
> "expected blah, have 0" type errors happen.

Just a quick question from a user: does Filipe's patch "Btrfs: fix race bet=
ween
fs trimming and block group remove/allocation" fix this?  Judging by the co=
mmit
message, it looks like it.  If so, can you say whether it will make it into
3.17.x?

Maybe I'm being overly paranoid, but I stuck with 3.16.7 because of this.  =
(I
mean, I have backups, but there's no need to provoke a situation where I wi=
ll
need them ;-) .)

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/LQGTdWVAwD3E1cRTFrMxj64
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUdh15AAoJEL/Q5oYsiHj03i8P/iN8IuzujFle/mIsMn8Au91u
e8NxOK+wsH/844xRu9BP185kwEot9ya0euOqG1rafbEc0FG/8fYIgrbidkAwOfMW
5UuwJByK0Xru/Z76l1sIqO+Gn/DAOREZ1RKro8q2TFcBAyFSXyY5ZPgP9XvXBlhs
RkGvum2KLjCFt0gl3qmNSrTeVU+wKB0polQCLGe2V6d2IWb5xHoGNIPpD1jrSdx1
NqS8loEo9/WTrqVW0P4ixNJF7qpFPpJmYS/FJdfNKGh207N8bQRVvP8t4VNq/oFx
oXuw0pnbKl7mdyJSysg3kvR7RlJbS/hF5YKc2WHlY97fd1tzaSDmKIf7C1w2v6yx
8S9BMb2+oJnyCSKtRhpnfo5c/ify7O3lYZC/ZbqEe4goMCtMrfDjELijPGipcE05
BUFJIA9q9GcZOb2KahNnBrSqu3MFMIq7NivXGSc+DTk3z1VLwRpqyAN9I7ykZP4A
fprVIRaRbi4TL5B2riP4BV6PChY/LybXJ7vXiQHAJxi+gVtSkIj213CMlQ4uR/fz
vkBwR0Za9tjXfaci4t4O4gxC50MmEqE3tbrPdGb8mSAZeY1kgrCRfmyKrCQzuG5h
+s5g231rN0fy1G6jEd4d+ccxn3WQlpaZCEzbaxhqtUjKV/bKxKDRsQYNhRb7VE0S
UJIjLR+eejy2CnXW/2Ms
=azMy
-----END PGP SIGNATURE-----

--Sig_/LQGTdWVAwD3E1cRTFrMxj64--
