Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57907 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbbHMIzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 04:55:10 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx001) with ESMTPSA
 (Nemesis) id 0M3zT0-1YZd8r3QQc-00rUJ0 for <linux-btrfs@vger.kernel.org>; Thu,
 13 Aug 2015 10:55:07 +0200
Date: Thu, 13 Aug 2015 10:54:58 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Deleted files cause btrfs-send to fail
Message-ID: <20150813105458.676c884a@thetick>
In-Reply-To: <pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
References: <20150813003419.09f13c1a@thetick>
	<20150813090541.77f5c821@thetick>
	<pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YolRNH/4unkv+qpBIr+4zq5"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/YolRNH/4unkv+qpBIr+4zq5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Thu, 13 Aug 2015 08:29:19 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Marc Joliet posted on Thu, 13 Aug 2015 09:05:41 +0200 as excerpted:
>=20
> > Here's the actual output now, obtained via btrfs-progs 4.0.1 from an
> > initramfs emergency shell:
> >=20
> > checking extents checking free space cache checking fs roots root 5
> > inode 8338813 errors 2000, link count wrong
> >         unresolved ref dir 26699 index 50500 namelen 4 name root
> >         filetype 0 errors 3, no dir item, no dir index
> > root 5 inode 8338814 errors 2000, link count wrong
> >         unresolved ref dir 26699 index 50502 namelen 6 name marcec
> >         filetype 0 errors 3, no dir item, no dir index
> > root 5 inode 8338815 errors 2000, link count wrong
> >         unresolved ref dir 26699 index 50504 namelen 6 name systab
> >         filetype 0 errors 3, no dir item, no dir index
> > root 5 inode 8710030 errors 2000, link count wrong
> >         unresolved ref dir 26699 index 59588 namelen 6 name marcec
> >         filetype 0 errors 3, no dir item, no dir index
> > root 5 inode 8710031 errors 2000, link count wrong
> >         unresolved ref dir 26699 index 59590 namelen 4 name root
> >         filetype 0 errors 3, no dir item, no dir index
> > Checking filesystem on /dev/sda1 UUID:
> > 0267d8b3-a074-460a-832d-5d5fd36bae64 found 63467610172 bytes used err is
> > 1 total csum bytes: 59475016 total tree bytes: 1903411200 total fs tree
> > bytes: 1691504640 total extent tree bytes: 130322432 btree space waste
> > bytes: 442495212 file data blocks allocated: 555097092096
> >  referenced 72887840768
> > btrfs-progs v4.0.1
> >=20
> > Again: is this fixable?
>=20
> FWIW, root 5 (which you asked about upthread) is the main filesystem=20
> root.  So all these appear to be on the main filesystem, not on snapshots/
> subvolumes.

OK

> As for the problem itself, noting that I'm not a dev, just a user/admin=20
> following the list, I believe...
>=20
> There was a recent bug (early 4.0 or 4.1, IDR which) that (as I recall=20
> understanding it) would fail to decrement link count and would thus leave=
=20
> unnamed inodes hanging around in directories with no way to delete them. =
=20
> That looks very much like what you're seeing.

Now that you mention it, I think I remember seeing that patch (series?).

> The bug has indeed been=20
> fixed in current, and a current btrfs check should fix it, but I don't=20
> believe that v4.0.1 userspace from the initramfs is new enough to have=20
> that fix.  The 4.1.2 userspace on your main system (from the first post)=
=20
> is current and should fix it, I believe, however.

I have updated the initramfs in the meantime.  (Funny: I *just* started usi=
ng
one, mainly to be able to use btrfstune on /, but now I have a genuine
necessity for it.)

> But if it's critical, you may wish to wait and have someone else confirm=
=20
> that before acting on it, just in case I have it wrong.

I can wait until tonight, at least.  The FS still mounts, and it's just the=
 root
subvolume that's affected; running btrfs-send on the /home subvolume still
works.

Greetings
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/YolRNH/4unkv+qpBIr+4zq5
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzFtqAAoJEL/Q5oYsiHj0xycP/i1svrvZ3pFg/KQmpkwQKzMg
3IMEnBFu8VcMvMJBp+N+Co+bmrFv55QsaLNrbc0NL1sEjEdfO9VhKPZR/vzAlkg8
uy8ybxhRkHM1fIAMewL6haRpp2fFBfta8PKhaklKWjfbYweaC4Fiqfc8PCMzfllC
jXYkH0v5f4QQNaOfB/NY2ac2NdNXlZe9BhQDTng2ck0n2VKUGuHcdJnwIIc9n+Wb
1dQ6avykpPb4KBB3Tt2pgquNzQ5ZU7cOoVQ47X4frEbAvJf8vPEn4i5T6jGUDpRk
i26p0ESmB5pB062Q4nRBBFwoItxBbk+1ywkkMbWxF+vXkQtcKdZOr68yYO1im6R8
tJgwAUUjsp45SbDWKfswmnrES4keUjeIuj1sh5TG1387GwjmczZubxUi2u2AOPsV
xfCErxfDuvNSEKmKPW1/j3hMJeLdP2DeRKr+RKKtGU1lRSpo4LJvc5j/CsNCtEQE
cwYvYfiOosLINPyBR9v6UoVw/AqgfvNbJHPtMQD764RlrvED8epc/vICMJ/45yOH
AIGtWJEutPVTIoQhFgf3g5cRsJZNCLKtNsc3LiyqRlNg6BFynKuZ8gQm+1hb1/mY
deHyGYhT6U/6ALwn6876qSKdSMJdPHq6WvTR9t/xsj039yBzsm2JAfT2lMdanXjL
kM5WKs6PVjkyqQpFOtki
=SUEh
-----END PGP SIGNATURE-----

--Sig_/YolRNH/4unkv+qpBIr+4zq5--
